import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

class ffiKeyOptions extends ffi.Struct {
  ffi.Pointer<Utf8> hash;
  ffi.Pointer<Utf8> cipher;
  ffi.Pointer<Utf8> compression;
  ffi.Pointer<Utf8> compressionLevel;
  ffi.Pointer<Utf8> rsaBits;

  factory ffiKeyOptions.allocate(
    ffi.Pointer<Utf8> hash,
    ffi.Pointer<Utf8> cipher,
    ffi.Pointer<Utf8> compression,
    ffi.Pointer<Utf8> compressionLevel,
    ffi.Pointer<Utf8> rsaBits,
  ) =>
      allocate<ffiKeyOptions>().ref
        ..hash = hash
        ..cipher = cipher
        ..compression = compression
        ..compressionLevel = compressionLevel
        ..rsaBits = rsaBits;
}
