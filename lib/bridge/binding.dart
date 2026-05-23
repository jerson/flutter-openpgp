import 'dart:async';
import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:openpgp/bridge/ffi.dart';
import 'package:openpgp/bridge/isolate.dart';
import 'package:openpgp/openpgp.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as Path;

class Binding {
  static final String _callFuncName = 'OpenPGPBridgeCall';
  static final String _libraryName = 'libopenpgp_bridge';
  static final Binding _instance = Binding._internal();

  late final DynamicLibrary _library;
  late final BridgeCallDart _bridgeCall;

  // Persistent worker isolate — spawned once, reused for all async calls.
  SendPort? _workerPort;
  final _pending = <int, Completer<Uint8List>>{};
  int _nextId = 0;
  Future<void>? _workerReady;

  factory Binding() {
    return _instance;
  }

  Binding._internal() {
    _library = openLib();
    _bridgeCall =
        _library.lookupFunction<BridgeCallC, BridgeCallDart>(_callFuncName);
  }

  // ── Worker isolate entry point ──────────────────────────────────────────────
  // Runs in the worker isolate. Initialises its own Binding (FFI handles are
  // per-isolate) then services BridgeRequest messages.
  @pragma('vm:entry-point')
  static void _workerEntryPoint(SendPort replyTo) {
    final inbox = ReceivePort();
    replyTo.send(inbox.sendPort); // signal ready + hand back the inbox port

    inbox.listen((msg) {
      if (msg is! BridgeRequest) return;
      try {
        final result = _instance.call(msg.name, msg.payload);
        replyTo.send(BridgeResponse(id: msg.id, data: result));
      } catch (e) {
        replyTo.send(BridgeResponse(id: msg.id, error: e.toString()));
      }
    });
  }

  // ── Async dispatch via persistent worker ────────────────────────────────────
  Future<void> _ensureWorker() {
    _workerReady ??= _spawnWorker();
    return _workerReady!;
  }

  Future<void> _spawnWorker() async {
    final inbox = ReceivePort();
    await Isolate.spawn(
      _workerEntryPoint,
      inbox.sendPort,
      debugName: '${_libraryName}_worker',
      errorsAreFatal: false,
    );
    final ready = Completer<void>();
    inbox.listen((msg) {
      if (msg is SendPort) {
        _workerPort = msg;
        if (!ready.isCompleted) ready.complete();
        return;
      }
      if (msg is BridgeResponse) {
        final c = _pending.remove(msg.id);
        if (c == null) return;
        if (msg.error != null) {
          c.completeError(OpenPGPException(msg.error!));
        } else {
          c.complete(msg.data!);
        }
      }
    });
    return ready.future;
  }

  Future<Uint8List> callAsync(String name, Uint8List payload) async {
    await _ensureWorker();
    final id = _nextId++;
    final c = Completer<Uint8List>();
    _pending[id] = c;
    _workerPort!.send(BridgeRequest(id, name, payload));
    return c.future;
  }

  // ── Synchronous dispatch (main isolate, blocks) ─────────────────────────────
  Uint8List call(String name, Uint8List payload) {
    final namePointer = name.toNativeUtf8();
    final payloadPointer = malloc.allocate<Uint8>(payload.length);
    payloadPointer.asTypedList(payload.length).setAll(0, payload);

    final result =
        _bridgeCall(namePointer, payloadPointer.cast<Void>(), payload.length);

    malloc.free(namePointer);
    malloc.free(payloadPointer);

    if (result.address == 0) {
      throw OpenPGPException(
          'FFI function $_callFuncName returned null pointer.');
    }

    handleError(result.ref.errorMessage, result);
    final output = Uint8List.fromList(result.ref.toUint8List());
    freeResult(result);
    return output;
  }

  void handleError(String? error, Pointer<BytesReturn> result) {
    if (error != null && error.isNotEmpty) {
      freeResult(result);
      throw OpenPGPException(error);
    }
  }

  void freeResult(Pointer<BytesReturn> result) {
    // Free the two inner C.malloc allocations before the struct itself.
    if (result.ref.message != nullptr) {
      malloc.free(result.ref.message);
    }
    if (result.ref.error != nullptr) {
      malloc.free(result.ref.error);
    }
    if (!Platform.isWindows) {
      malloc.free(result);
    }
  }

  bool isSupported() {
    return Platform.isWindows ||
        Platform.isLinux ||
        Platform.isAndroid ||
        Platform.isMacOS ||
        Platform.isFuchsia ||
        Platform.isIOS;
  }

  void validateTestFFIFile(String path) {
    if (!File(path).existsSync()) {
      debugPrint('dynamic library not found: $path');
      throw Exception(
          'In order to run unit tests, run the project first: '
          '"flutter run -d ${Platform.operatingSystem}"');
    }
  }

  Directory _findAppDirectory(Directory directory) {
    try {
      return directory
          .listSync(recursive: false, followLinks: false)
          .whereType<Directory>()
          .firstWhere((dir) => dir.path.endsWith('.app'));
    } catch (e) {
      return directory;
    }
  }

  DynamicLibrary openLib() {
    final isFlutterTest = Platform.environment.containsKey('FLUTTER_TEST');

    if (Platform.isMacOS || Platform.isIOS) {
      if (isFlutterTest) {
        final appDirectory =
            _findAppDirectory(Directory('build/macos/Build/Products/Debug'));
        final ffiFile = Path.join(
            appDirectory.path, 'Contents', 'Frameworks', '$_libraryName.dylib');
        validateTestFFIFile(ffiFile);
        return DynamicLibrary.open(ffiFile);
      }
      if (Platform.isMacOS) {
        return DynamicLibrary.open('$_libraryName.dylib');
      }
      if (Platform.isIOS) {
        return DynamicLibrary.process();
      }
    }

    if (Platform.isAndroid || Platform.isLinux) {
      if (isFlutterTest) {
        final arch =
            Platform.resolvedExecutable.contains('linux-x64') ? 'x64' : 'arm64';
        final ffiFile =
            'build/linux/$arch/debug/bundle/lib/$_libraryName.so';
        validateTestFFIFile(ffiFile);
        return DynamicLibrary.open(ffiFile);
      }

      if (Platform.isLinux) {
        try {
          return DynamicLibrary.open('$_libraryName.so');
        } catch (e) {
          final binary = File('/proc/self/cmdline').readAsStringSync();
          final suggestedFile =
              Path.join(Path.dirname(binary), 'lib', '$_libraryName.so');
          return DynamicLibrary.open(suggestedFile);
        }
      }

      if (Platform.isAndroid) {
        try {
          return DynamicLibrary.open('$_libraryName.so');
        } catch (e) {
          debugPrint('Falling back to absolute path for older Android devices');
          var appid = File('/proc/self/cmdline').readAsStringSync();
          appid = String.fromCharCodes(
              appid.codeUnits.where((c) => c != 0));
          return DynamicLibrary.open('/data/data/$appid/lib/$_libraryName.so');
        }
      }
    }

    if (Platform.isWindows) {
      if (isFlutterTest) {
        final arch =
            Platform.resolvedExecutable.contains('x64') ? 'x64' : 'arm64';
        final ffiFile = Path.canonicalize(Path.join(
            r'build\windows', arch, r'runner\Debug', '$_libraryName.dll'));
        validateTestFFIFile(ffiFile);
        return DynamicLibrary.open(ffiFile);
      }
      return DynamicLibrary.open('$_libraryName.dll');
    }

    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }
}
