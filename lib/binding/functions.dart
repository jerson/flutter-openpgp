import 'dart:ffi' as ffi;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:openpgp/binding/key_options.dart';
import 'package:openpgp/binding/return.dart';


typedef call_func = ffi.Pointer<ffiBytesReturn> Function(
    ffi.Pointer<Utf8>,
    ffi.Pointer<ffi.Void>,
    ffi.Int32,
    );
typedef Call = ffi.Pointer<ffiBytesReturn> Function(
    ffi.Pointer<Utf8>,
    ffi.Pointer<ffi.Void>,
    int,
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

typedef decryptBytes_func = ffi.Pointer<ffiSliceReturn> Function(
  ffi.Pointer<ffi.Void>,
  ffi.Int32,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
typedef DecryptBytes = ffi.Pointer<ffiSliceReturn> Function(
  ffi.Pointer<ffi.Void>,
  int,
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);

typedef encrypt_func = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);
typedef Encrypt = ffi.Pointer<ffiStringReturn> Function(
  ffi.Pointer<Utf8>,
  ffi.Pointer<Utf8>,
);

typedef encryptBytes_func = ffi.Pointer<ffiSliceReturn> Function(
  ffi.Pointer<ffi.Void>,
  ffi.Int32,
  ffi.Pointer<Utf8>,
);
typedef EncryptBytes = ffi.Pointer<ffiSliceReturn> Function(
  ffi.Pointer<ffi.Void>,
  int,
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
