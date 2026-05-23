import 'dart:async';

import 'package:flutter/services.dart';
import 'package:openpgp/model/bridge_model_generated.dart' as model;
import 'package:openpgp/openpgp_bridge.dart';
import 'package:openpgp/mixin/openpgp_request_builders.dart';
import 'package:openpgp/mixin/openpgp_response_handlers.dart';

class OpenPGPException implements Exception {
  String cause;

  OpenPGPException(this.cause);

  @override
  String toString() {
    return 'OpenPGPException: $cause';
  }
}

enum Hash { SHA256, SHA224, SHA384, SHA512 }

enum Algorithm {
  RSA,
  ECDSA,
  EDDSA,
  ECHD,
  DSA,
  ELGAMAL,
  MLDSA65ED25519,
  MLDSA87ED448,
  MLKEM768X25519,
  MLKEM1024X448,
}

enum Curve {
  CURVE25519,
  CURVE448,
  P256,
  P384,
  P521,
  SECP256K1,
  BRAINPOOLP256,
  BRAINPOOLP384,
  BRAINPOOLP512,
}

enum Cipher { AES128, AES192, AES256, DES, CAST5 }

enum Compression { NONE, ZLIB, ZIP }

class Options {
  String? name;
  String? comment;
  String? email;
  String? passphrase;
  KeyOptions? keyOptions;
}

class KeyOptions {
  Curve? curve;
  Algorithm? algorithm;
  Hash? hash;
  Cipher? cipher;
  Compression? compression;
  int? compressionLevel;
  int? rsaBits;
  /// Key lifetime in seconds. 0 means the key does not expire.
  int? keyLifetimeSecs;
}

class KeyPair {
  String publicKey;
  String privateKey;

  KeyPair(this.publicKey, this.privateKey);
}

class Identity {
  String id;
  String name;
  String comment;
  String email;

  Identity(this.id, this.name, this.comment, this.email);

  Map toJson() => {
        'id': id,
        'name': name,
        'comment': comment,
        'email': email,
      };
}

class PublicKeyMetadata {
  String algorithm;
  String keyId;
  String keyIdShort;
  String creationTime;
  String fingerprint;
  String keyIdNumeric;
  bool isSubKey;
  bool canSign;
  bool canEncrypt;
  List<Identity> identities;

  PublicKeyMetadata(
      this.algorithm,
      this.keyId,
      this.keyIdShort,
      this.creationTime,
      this.fingerprint,
      this.keyIdNumeric,
      this.isSubKey,
      this.canSign,
      this.canEncrypt,
      this.identities);

  Map toJson() => {
        'algorithm': algorithm,
        'keyId': keyId,
        'keyIdShort': keyIdShort,
        'creationTime': creationTime,
        'fingerprint': fingerprint,
        'keyIdNumeric': keyIdNumeric,
        'isSubKey': isSubKey,
        'canSign': canSign,
        'canEncrypt': canEncrypt,
        'identities': identities,
      };
}

class PrivateKeyMetadata {
  String keyId;
  String keyIdShort;
  String creationTime;
  String fingerprint;
  String keyIdNumeric;
  bool isSubKey;
  bool encrypted;
  bool canSign;
  List<Identity> identities;

  PrivateKeyMetadata(
      this.keyId,
      this.keyIdShort,
      this.creationTime,
      this.fingerprint,
      this.keyIdNumeric,
      this.isSubKey,
      this.encrypted,
      this.canSign,
      this.identities);

  Map toJson() => {
        'keyId': keyId,
        'keyIdShort': keyIdShort,
        'creationTime': creationTime,
        'fingerprint': fingerprint,
        'keyIdNumeric': keyIdNumeric,
        'isSubKey': isSubKey,
        'encrypted': encrypted,
        'canSign': canSign,
        'identities': identities,
      };
}

class Entity {
  String? publicKey;
  String? privateKey;
  String? passphrase;
}

class FileHints {
  bool? isBinary;
  String? fileName;
  String? modTime;
}

class ArmorMetadata {
  String type;
  Uint8List body;

  ArmorMetadata(this.type, this.body);
}

class OpenPGP with OpenPGPResponseHandlers, OpenPGPRequestBuilders {
  /// Decrypts an ASCII-armored PGP message using [privateKey] and [passphrase].
  ///
  /// Pass [signed] with a [Entity.publicKey] to also verify the embedded
  /// signature; throws [OpenPGPException] if verification fails.
  static Future<String> decrypt(
      String message, String privateKey, String passphrase,
      {KeyOptions? options, Entity? signed}) async {
    var requestBuilder = model.DecryptRequestObjectBuilder(
      message: message,
      privateKey: privateKey,
      passphrase: passphrase,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
      signed: OpenPGPRequestBuilders.entityBuilder(signed),
    );

    return OpenPGPBridge.call("decrypt", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.stringResponse);
  }

  /// Decrypts a binary PGP message using [privateKey] and [passphrase].
  static Future<Uint8List> decryptBytes(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options, Entity? signed}) async {
    var requestBuilder = model.DecryptBytesRequestObjectBuilder(
      message: message,
      privateKey: privateKey,
      passphrase: passphrase,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
      signed: OpenPGPRequestBuilders.entityBuilder(signed),
    );

    return OpenPGPBridge.call("decryptBytes", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.bytesResponse);
  }

  /// Encrypts [message] for the holder of [publicKey].
  ///
  /// Pass [signed] with a [Entity.privateKey] and [Entity.passphrase] to
  /// produce a signed+encrypted message.
  static Future<String> encrypt(String message, String publicKey,
      {KeyOptions? options, Entity? signed, FileHints? fileHints}) async {
    var requestBuilder = model.EncryptRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
      signed: OpenPGPRequestBuilders.entityBuilder(signed),
      fileHints: OpenPGPRequestBuilders.fileHintsBuilder(fileHints),
    );

    return OpenPGPBridge.call("encrypt", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.stringResponse);
  }

  /// Encrypts binary [message] for the holder of [publicKey].
  static Future<Uint8List> encryptBytes(Uint8List message, String publicKey,
      {KeyOptions? options, Entity? signed, FileHints? fileHints}) async {
    var requestBuilder = model.EncryptBytesRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
      signed: OpenPGPRequestBuilders.entityBuilder(signed),
      fileHints: OpenPGPRequestBuilders.fileHintsBuilder(fileHints),
    );

    return OpenPGPBridge.call("encryptBytes", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.bytesResponse);
  }

  /// Creates a detached ASCII-armored signature over [message].
  ///
  /// Use [verify] to check the returned signature against the original message.
  static Future<String> sign(
      String message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPBridge.call("sign", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.stringResponse);
  }

  /// Creates a detached binary signature over [message].
  ///
  /// Use [verifyBytes] to check the returned signature.
  static Future<Uint8List> signBytes(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPBridge.call("signBytes", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.bytesResponse);
  }

  /// Creates a detached binary signature over [message], returned as an
  /// ASCII-armored string. Use [verifyBytes] to check the signature.
  static Future<String> signBytesToString(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPBridge.call("signBytesToString", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.stringResponse);
  }

  /// Produces a cleartext-signed message (RFC 4880 §7) embedding [message]
  /// inline alongside the signature. Use [verifyData] to verify.
  static Future<String> signData(
      String message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignDataRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPBridge.call("signData", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.stringResponse);
  }

  /// Signs binary [message] and returns a PGP literal-data packet containing
  /// both the data and the signature. Use [verifyDataBytes] to verify.
  static Future<Uint8List> signDataBytes(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignDataBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPBridge.call("signDataBytes", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.bytesResponse);
  }

  /// Signs binary [message] and returns the signed packet as an ASCII-armored
  /// string. Use [verifyDataBytes] to verify.
  static Future<String> signDataBytesToString(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignDataBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPBridge.call("signDataBytesToString", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.stringResponse);
  }

  /// Verifies a detached text [signature] (from [sign]) against [message].
  static Future<bool> verify(
      String signature, String message, String publicKey) async {
    var requestBuilder = model.VerifyRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      signature: signature,
    );

    return OpenPGPBridge.call("verify", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.boolResponse);
  }

  /// Verifies a detached binary [signature] (from [signBytes] /
  /// [signBytesToString]) against binary [message].
  static Future<bool> verifyBytes(
      String signature, Uint8List message, String publicKey) async {
    var requestBuilder = model.VerifyBytesRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      signature: signature,
    );

    return OpenPGPBridge.call("verifyBytes", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.boolResponse);
  }

  /// Verifies a cleartext-signed message (from [signData]).
  /// [signature] is the full signed block including the embedded plaintext.
  static Future<bool> verifyData(String signature, String publicKey) async {
    var requestBuilder = model.VerifyDataRequestObjectBuilder(
      publicKey: publicKey,
      signature: signature,
    );

    return OpenPGPBridge.call("verifyData", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.boolResponse);
  }

  /// Verifies a signed literal-data packet (from [signDataBytes] /
  /// [signDataBytesToString]).
  static Future<bool> verifyDataBytes(
      Uint8List signature, String publicKey) async {
    var requestBuilder = model.VerifyDataBytesRequestObjectBuilder(
      publicKey: publicKey,
      signature: signature,
    );

    return OpenPGPBridge.call("verifyDataBytes", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.boolResponse);
  }

  static Future<String> decryptSymmetric(String message, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.DecryptSymmetricRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPBridge.call("decryptSymmetric", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.stringResponse);
  }

  static Future<Uint8List> decryptSymmetricBytes(
      Uint8List message, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.DecryptSymmetricBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPBridge.call("decryptSymmetricBytes", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.bytesResponse);
  }

  static Future<String> encryptSymmetric(String message, String passphrase,
      {KeyOptions? options, FileHints? fileHints}) async {
    var requestBuilder = model.EncryptSymmetricRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      fileHints: OpenPGPRequestBuilders.fileHintsBuilder(fileHints),
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPBridge.call("encryptSymmetric", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.stringResponse);
  }

  static Future<Uint8List> encryptSymmetricBytes(
      Uint8List message, String passphrase,
      {KeyOptions? options, FileHints? fileHints}) async {
    var requestBuilder = model.EncryptSymmetricBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      fileHints: OpenPGPRequestBuilders.fileHintsBuilder(fileHints),
      options: OpenPGPRequestBuilders.keyOptionsBuilder(options),
    );

    return OpenPGPBridge.call("encryptSymmetricBytes", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.bytesResponse);
  }

  static Future<String> armorEncode(String type, Uint8List data) async {
    var requestBuilder = model.ArmorEncodeRequestObjectBuilder(
      packet: data,
      type: type,
    );

    return OpenPGPBridge.call("armorEncode", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.stringResponse);
  }

  static Future<ArmorMetadata> armorDecode(String message) async {
    var requestBuilder = model.ArmorDecodeRequestObjectBuilder(
      message: message,
    );

    return OpenPGPBridge.call("armorDecode", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.armorDecodeResponse);
  }

  /// Extracts the public key from [privateKey] and returns it armored.
  static Future<String> convertPrivateKeyToPublicKey(String privateKey) async {
    var requestBuilder = model.ConvertPrivateKeyToPublicKeyRequestObjectBuilder(
      privateKey: privateKey,
    );

    return OpenPGPBridge.call(
            "convertPrivateKeyToPublicKey", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.stringResponse);
  }

  /// Returns metadata (key ID, algorithm, creation time, etc.) for [privateKey].
  static Future<PrivateKeyMetadata> getPrivateKeyMetadata(
      String privateKey) async {
    var requestBuilder = model.GetPrivateKeyMetadataRequestObjectBuilder(
      privateKey: privateKey,
    );

    return OpenPGPBridge.call("getPrivateKeyMetadata", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.privateKeyMetadataResponse);
  }

  /// Returns metadata (key ID, algorithm, creation time, etc.) for [publicKey].
  static Future<PublicKeyMetadata> getPublicKeyMetadata(
      String publicKey) async {
    var requestBuilder = model.GetPublicKeyMetadataRequestObjectBuilder(
      publicKey: publicKey,
    );

    return OpenPGPBridge.call("getPublicKeyMetadata", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.publicKeyMetadataResponse);
  }

  /// Generates a new key pair.
  ///
  /// Use [Options.keyOptions] to control the algorithm (including PQC variants
  /// via [Algorithm.MLDSA65ED25519] etc.), curve, RSA bits, and expiry.
  static Future<KeyPair> generate({Options? options}) async {
    var requestBuilder = model.GenerateRequestObjectBuilder(
      options: OpenPGPRequestBuilders.optionsBuilder(options),
    );
    return OpenPGPBridge.call("generate", requestBuilder.toBytes())
        .then(OpenPGPResponseHandlers.keyPairResponse);
  }
}
