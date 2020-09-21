import 'dart:typed_data';

import 'package:openpgp/binding/functions.dart';
import 'package:openpgp/binding/return.dart';
import 'package:openpgp/ffi.dart';
import 'dart:ffi' as ffi;

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
