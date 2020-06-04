@JS()
library openpgp;

import 'package:js/js.dart';

@JS()
external OpenPGPDecrypt(
  String message,
  String privateKey,
  String passphrase,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPDecryptBytes(
  String message,
  String privateKey,
  String passphrase,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPEncrypt(
  String message,
  String publicKey,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPEncryptBytes(
  String message,
  String publicKey,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPSign(
  String message,
  String publicKey,
  String privateKey,
  String passphrase,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPSignBytes(
  String message,
  String publicKey,
  String privateKey,
  String passphrase,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPSignBytesToString(
  String message,
  String publicKey,
  String privateKey,
  String passphrase,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPVerify(
  String signature,
  String message,
  String publicKey,
  Function(String error, bool result) callback,
);

@JS()
external OpenPGPVerifyBytes(
  String signature,
  String message,
  String publicKey,
  Function(String error, bool result) callback,
);

@JS()
external OpenPGPDecryptSymmetric(
  String message,
  String passphrase,
  KeyOptionsObject options,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPDecryptSymmetricBytes(
  String message,
  String passphrase,
  KeyOptionsObject options,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPEncryptSymmetric(
  String message,
  String passphrase,
  KeyOptionsObject options,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPEncryptSymmetricBytes(
  String message,
  String passphrase,
  KeyOptionsObject options,
  Function(String error, String result) callback,
);

@JS()
external OpenPGPGenerate(
  OptionsObject options,
  Function(String error, KeyPairObject result) callback,
);

@JS()
@anonymous
class KeyPairObject {
  external String get publicKey;

  external String get privateKey;
}

@JS()
@anonymous
class KeyOptionsObject {
  external String get cipher;
  external set cipher(String cipher);
  external String get compression;
  external set compression(String compression);
  external int get compressionLevel;
  external set compressionLevel(int compressionLevel);
  external String get hash;
  external set hash(String hash);
  external int get rsaBits;
  external set rsaBits(int rsaBits);
}

@JS()
@anonymous
class OptionsObject {
  external String get email;
  external set email(String email);
  external String get name;
  external set name(String name);
  external String get comment;
  external set comment(String comment);
  external String get passphrase;
  external set passphrase(String passphrase);
  external KeyOptionsObject get keyOptions;
  external set keyOptions(KeyOptionsObject keyOptions);
}
