import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

class ffiKeyPair extends ffi.Struct {
  ffi.Pointer<Utf8> publicKey;
  ffi.Pointer<Utf8> privateKey;

  factory ffiKeyPair.allocateEmpty() => allocate<ffiKeyPair>().ref
  ..publicKey = null
  ..privateKey = null;

  factory ffiKeyPair.allocate(
    ffi.Pointer<Utf8> publicKey,
    ffi.Pointer<Utf8> privateKey,
  ) =>
      allocate<ffiKeyPair>().ref
        ..publicKey=publicKey
        ..privateKey=privateKey;
}

class ffiKeyPairReturn extends ffi.Struct {
  ffi.Pointer<ffiKeyPair> keyPair;
  ffi.Pointer<Utf8> error;
}
