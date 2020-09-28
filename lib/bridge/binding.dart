import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'dart:ffi' as ffi;
import 'dart:io' show Platform;
import 'package:openpgp/bridge/isolate.dart';
import 'package:openpgp/bridge/ffi.dart';
import 'dart:io';

import 'package:ffi/ffi.dart';

class Binding {
  static final String _callFuncName = 'OpenPGPBridgeCall';
  static final String _libraryName = 'libopenpgp_bridge';
  static final Binding _singleton = Binding._internal();

  ffi.DynamicLibrary _library;

  factory Binding() {
    return _singleton;
  }

  Binding._internal() {
    _library = openLib();
  }

  static callBridge(IsolateArguments args) async {
    var result = await Binding().call(args.name, args.payload);
    args.port.send(result);
  }

  Future<Uint8List> callAsync(String name, Uint8List payload) async {
    final port = ReceivePort();
    final args = IsolateArguments(name, payload, port.sendPort);

    Isolate.spawn<IsolateArguments>(
      callBridge,
      args,
      onError: port.sendPort,
      onExit: port.sendPort,
    );

    Completer<Uint8List> completer = new Completer();

    StreamSubscription subscription;
    subscription = port.listen((message) async {
      await subscription?.cancel();
      completer.complete(message);
    });
    return completer.future;
  }

  Future<Uint8List> call(String name, Uint8List payload) async {
    final callable = _library
        .lookup<ffi.NativeFunction<call_func>>(_callFuncName)
        .asFunction<Call>();

    final pointer = allocate<ffi.Uint8>(count: payload.length);

    // https://github.com/dart-lang/ffi/issues/27
    // https://github.com/objectbox/objectbox-dart/issues/69
    for (var i = 0; i < payload.length; i++) {
      pointer[i] = payload[i];
    }
    final voidStar = pointer.cast<ffi.Void>();

    var result = callable(toUtf8(name), voidStar, payload.length)
        .cast<FFIBytesReturn>()
        .ref;

    handleError(result.error, result.addressOf);

    var output = result.message.cast<ffi.Uint8>().asTypedList(result.size);
    free(result.addressOf);
    return output;
  }

  void handleError(ffi.Pointer<Utf8> error, ffi.Pointer pointer) {
    if (error.address != ffi.nullptr.address) {
      var message = fromUtf8(error);
      free(pointer);
      throw message;
    }
  }

  ffi.Pointer<Utf8> toUtf8(String text) {
    return text == null ? Utf8.toUtf8("") : Utf8.toUtf8(text);
  }

  String fromUtf8(ffi.Pointer<Utf8> text) {
    return text == null ? "" : Utf8.fromUtf8(text);
  }

  bool isSupported() {
    return Platform.isWindows ||
        Platform.isLinux ||
        Platform.isAndroid ||
        Platform.isMacOS ||
        Platform.isIOS;
  }

  ffi.DynamicLibrary openLib() {
    if (Platform.isMacOS) {
      return ffi.DynamicLibrary.process();
      // return ffi.DynamicLibrary.open("${_library_name}.dylib");
    }
    if (Platform.isWindows) {
      //  Platform.script.resolve("build/windows/x64/Debug/Runner/hello.dll").path
      return ffi.DynamicLibrary.open("$_libraryName.dll");
    }
    if (Platform.isIOS) {
      return ffi.DynamicLibrary.process();
    }
    if (Platform.isLinux) {
      return ffi.DynamicLibrary.executable();
    }
    return ffi.DynamicLibrary.open("$_libraryName.so");
  }
}
