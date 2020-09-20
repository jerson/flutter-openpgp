import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

class FFIBytesReturn extends ffi.Struct {
  ffi.Pointer<ffi.Void> message;

  @ffi.Int32()
  int size;

  ffi.Pointer<Utf8> error;
}
