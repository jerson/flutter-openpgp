import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:openpgp/binding/key_options.dart';

class ffiOptions extends ffi.Struct {
  ffi.Pointer<Utf8> name;
  ffi.Pointer<Utf8> comment;
  ffi.Pointer<Utf8> email;
  ffi.Pointer<Utf8> passphrase;
  ffi.Pointer<ffiKeyOptions> keyOptions;

  factory ffiOptions.allocate(
      ffi.Pointer<Utf8> name,
      ffi.Pointer<Utf8> comment,
      ffi.Pointer<Utf8> email,
      ffi.Pointer<Utf8> passphrase,
      ffiKeyOptions keyOptions,
      ) =>
      allocate<ffiOptions>().ref
        ..name= name
        ..comment= comment
        ..email= email
        ..passphrase= passphrase
        ..keyOptions= keyOptions.addressOf;
}
