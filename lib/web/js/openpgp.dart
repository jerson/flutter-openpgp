@JS()
library openpgp;

import 'package:js/js.dart';

@JS()
external OpenPGPDecrypt(String message,
    String privateKey,
    String passphrase,
    Function(String error, String result) callback,);

@JS()
external OpenPGPEncrypt(String message,
    String publicKey,
    Function(String error, String result) callback,);

@JS()
external OpenPGPSign(String message,
    String publicKey,
    String privateKey,
    String passphrase,
    Function(String error, String result) callback,);

@JS()
external OpenPGPVerify(String signature,
    String message,
    String publicKey,
    Function(String error, bool result) callback,);

@JS()
external OpenPGPDecryptSymmetric(String message,
    String passphrase,
    dynamic options,
    Function(String error, String result) callback,);

@JS()
external OpenPGPEncryptSymmetric(String message,
    String passphrase,
    dynamic options,
    Function(String error, String result) callback,);

@JS()
external OpenPGPGenerate(dynamic options,
    Function(String error, KeyPairObject result) callback,);

@JS()
class KeyPairObject {
  external String get publicKey;

  external String get privateKey;
}
