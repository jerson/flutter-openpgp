import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:openpgp/binding/key_options.dart';
import 'package:openpgp/binding/return.dart';

import 'options.dart';

typedef encrypt_func = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
typedef Encrypt = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);

typedef decrypt_func = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
typedef Decrypt = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);

typedef sign_func = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
typedef Sign = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);

typedef verify_func = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
typedef Verify = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);

typedef encryptSymmetric_func = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<ffiKeyOptions>,
);
typedef EncryptSymmetric = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<ffiKeyOptions>,
);

typedef decryptSymmetric_func = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<ffiKeyOptions>,
);
typedef DecryptSymmetric = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
  ffi.Pointer<ffiKeyOptions>,
);

typedef generate_func = ffi.Pointer<ffiKeyPairReturn> Function(
  ffi.Pointer<ffiKeyOptions>,
);
typedef Generate = ffi.Pointer<ffiKeyPairReturn> Function(
  ffi.Pointer<ffiKeyOptions>,
);
