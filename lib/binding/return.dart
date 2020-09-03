import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:openpgp/binding/key_pair.dart';

class ffiKeyPairReturn extends ffi.Struct {
  ffi.Pointer<ffiKeyPair> keyPair;
  ffi.Pointer<Utf8> error;
}
class ffiSliceReturn extends ffi.Struct {
  ffi.Pointer<ffi.Void> message;

  @ffi.Int32()
  int size;

  ffi.Pointer<Utf8> error;
}
class ffiStringReturn extends ffi.Struct {
  ffi.Pointer<Utf8> result;
  ffi.Pointer<Utf8> error;
}