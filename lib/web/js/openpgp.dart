@JS()
library openpgp;

import 'package:js/js.dart';

@JS()
external OpenPGPDecryptOAEP(
  String message,
  String label,
  String hashName,
  String pkcs12,
  String passphrase,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPDecryptPKCS1v15(
  String message,
  String pkcs12,
  String passphrase,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPEncryptOAEP(
  String message,
  String label,
  String hashName,
  String pkcs12,
  String passphrase,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPEncryptPKCS1v15(
  String message,
  String pkcs12,
  String passphrase,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPSignPSS(
  String message,
  String hashName,
  String pkcs12,
  String passphrase,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPSignPKCS1v15(
  String message,
  String hashName,
  String pkcs12,
  String passphrase,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPVerifyPSS(
  String signature,
  String message,
  String hashName,
  String pkcs12,
  String passphrase,
  Function(String error, bool result) callback,
);

@JS()
external OpenPGPVerifyPKCS1v15(
  String signature,
  String message,
  String hashName,
  String pkcs12,
  String passphrase,
  Function(String error, bool result) callback,
);

@JS()
external OpenPGPHash(
  String message,
  String hash,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPBase64(
  String message,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPGenerate(
  int bits,
  Function(String error, KeyPairObject result) callback,
);

@JS()
class KeyPairObject {
  external String get publicKey;
  external String get privateKey;
}
