import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:openpgp/binding/key_options.dart';
import 'package:openpgp/binding/key_pair.dart';

typedef encrypt_func = ffi.Pointer<Utf8> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
typedef Encrypt = ffi.Pointer<Utf8> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);

typedef generate_func = ffi.Pointer<ffiGenerate_return> Function(
  ffi.Pointer<ffiKeyOptions>,
  ffi.Pointer<ffiGenerate_return>,
);
typedef Generate = ffi.Pointer<ffiGenerate_return> Function(
  ffi.Pointer<ffiKeyOptions>,
  ffi.Pointer<ffiGenerate_return>,
);
