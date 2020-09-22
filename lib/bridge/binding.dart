import 'dart:typed_data';

import 'dart:ffi' as ffi;
import 'dart:io' show Platform;
import 'package:openpgp/bridge/functions.dart';
import 'package:openpgp/bridge/return.dart';
import "package:path/path.dart" show join;
import 'dart:io';

import 'package:ffi/ffi.dart';

class Binding {
  static final Binding _singleton = Binding._internal();
  ffi.DynamicLibrary _library;

  factory Binding() {
    return _singleton;
  }

  Binding._internal() {
    _library = openLib();
  }

  Future<Uint8List> call(String name, Uint8List payload) async {
    final callable = _library
        .lookup<ffi.NativeFunction<call_func>>('Call')
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
}

ffi.DynamicLibrary _dlopenPlatformSpecific(String name, {String path}) {
  String fullPath = _platformPath(name, path: path);
  return ffi.DynamicLibrary.open(fullPath);
}

String _platformPath(String name, {String path = ''}) {
  if (Platform.isMacOS) {
    return path + name + "_darwin_amd64.dylib";
  }
  if (Platform.isLinux || Platform.isAndroid) {
    return path + name + "_linux_amd64.so";
  }
  if (Platform.isWindows) {
    return path + name + "_windows_amd64.dll";
  }
  throw Exception("Platform not implemented");
}

ffi.DynamicLibrary openLib() {
  return _dlopenPlatformSpecific('openpgp',
      path: join(
        Directory(Platform.resolvedExecutable).parent.path,
        // data prefix is needed for linux at least
        'flutter_assets/packages/openpgp/static/',
      ));
}
