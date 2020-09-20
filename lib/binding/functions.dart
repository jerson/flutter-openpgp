import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:openpgp/binding/return.dart';

typedef call_func = ffi.Pointer<FFIBytesReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<ffi.Void>,
  ffi.Int32,
);
typedef Call = ffi.Pointer<FFIBytesReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<ffi.Void>,
  int,
);
