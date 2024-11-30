import 'dart:async';

import 'package:flutter/services.dart';
import 'package:openpgp/bridge/binding_stub.dart'
    if (dart.library.io) 'package:openpgp/bridge/binding.dart'
    if (dart.library.js) 'package:openpgp/bridge/binding_stub.dart';
import 'package:openpgp/model/bridge_model_generated.dart' as model;

class OpenPGPException implements Exception {
  String cause;

  OpenPGPException(this.cause);

  @override
  String toString() {
    return 'OpenPGPException: $cause';
  }
}

enum Hash { SHA256, SHA224, SHA384, SHA512 }

enum Algorithm { RSA, ECDSA, EDDSA, ECHD, DSA, ELGAMAL }

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

class OpenPGP {
  static const MethodChannel _channel = MethodChannel('openpgp');
  static bool bindingEnabled = Binding().isSupported();

  static Future<Uint8List> _call(String name, Uint8List payload) async {
    if (bindingEnabled) {
      return await Binding().callAsync(name, payload);
    }
    return await _channel.invokeMethod(name, payload);
  }

  static Future<Uint8List> _bytesResponse(
      String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = model.BytesResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    return Uint8List.fromList(response.output!);
  }

  static Future<String> _stringResponse(String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = model.StringResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    return response.output!;
  }

  static Future<bool> _boolResponse(String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = model.BoolResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    return response.output;
  }

  static Future<PublicKeyMetadata> _publicKeyMetadataResponse(
      String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = model.PublicKeyMetadataResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    var metadata = response.output!;
    return PublicKeyMetadata(
      metadata.algorithm!,
      metadata.keyId!,
      metadata.keyIdShort!,
      metadata.creationTime!,
      metadata.fingerprint!,
      metadata.keyIdNumeric!,
      metadata.isSubKey,
      metadata.canSign,
      metadata.canEncrypt,
      _identities(metadata.identities),
    );
  }

  static Future<PrivateKeyMetadata> _privateKeyMetadataResponse(
      String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = model.PrivateKeyMetadataResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    var metadata = response.output!;
    return PrivateKeyMetadata(
      metadata.keyId!,
      metadata.keyIdShort!,
      metadata.creationTime!,
      metadata.fingerprint!,
      metadata.keyIdNumeric!,
      metadata.isSubKey,
      metadata.encrypted,
      metadata.canSign,
      _identities(metadata.identities),
    );
  }

  static Future<ArmorMetadata> _armorDecodeResponse(
      String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = model.ArmorDecodeResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    var metadata = response.output!;
    return ArmorMetadata(
      metadata.type!,
      Uint8List.fromList(metadata.body!),
    );
  }

  static List<Identity> _identities(List<model.Identity>? identities) {
    List<Identity> list = [];
    if (identities == null) {
      return list;
    }

    for (var element in identities) {
      list.add(Identity(
        element.id!,
        element.name!,
        element.comment!,
        element.email!,
      ));
    }

    return list;
  }

  static Future<KeyPair> _keyPairResponse(
      String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = model.KeyPairResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    var keyPair = response.output!;
    return KeyPair(keyPair.publicKey!, keyPair.privateKey!);
  }

  static Future<String> decrypt(
      String message, String privateKey, String passphrase,
      {KeyOptions? options, Entity? signed}) async {
    var requestBuilder = model.DecryptRequestObjectBuilder(
      message: message,
      privateKey: privateKey,
      passphrase: passphrase,
      options: _keyOptionsBuilder(options),
      signed: _entityBuilder(signed),
    );

    return await _stringResponse("decrypt", requestBuilder.toBytes());
  }

  static Future<Uint8List> decryptBytes(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options, Entity? signed}) async {
    var requestBuilder = model.DecryptBytesRequestObjectBuilder(
      message: message,
      privateKey: privateKey,
      passphrase: passphrase,
      options: _keyOptionsBuilder(options),
      signed: _entityBuilder(signed),
    );

    return await _bytesResponse("decryptBytes", requestBuilder.toBytes());
  }

  static Future<String> encrypt(String message, String publicKey,
      {KeyOptions? options, Entity? signed, FileHints? fileHints}) async {
    var requestBuilder = model.EncryptRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      options: _keyOptionsBuilder(options),
      signed: _entityBuilder(signed),
      fileHints: _fileHintsBuilder(fileHints),
    );

    return await _stringResponse("encrypt", requestBuilder.toBytes());
  }

  static Future<Uint8List> encryptBytes(Uint8List message, String publicKey,
      {KeyOptions? options, Entity? signed, FileHints? fileHints}) async {
    var requestBuilder = model.EncryptBytesRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      options: _keyOptionsBuilder(options),
      signed: _entityBuilder(signed),
      fileHints: _fileHintsBuilder(fileHints),
    );

    return await _bytesResponse("encryptBytes", requestBuilder.toBytes());
  }

  static Future<String> sign(
      String message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: _keyOptionsBuilder(options),
    );

    return await _stringResponse("sign", requestBuilder.toBytes());
  }

  static Future<Uint8List> signBytes(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: _keyOptionsBuilder(options),
    );

    return await _bytesResponse("signBytes", requestBuilder.toBytes());
  }

  static Future<String> signBytesToString(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: _keyOptionsBuilder(options),
    );

    return await _stringResponse("signBytesToString", requestBuilder.toBytes());
  }

  static Future<String> signData(
      String message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignDataRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: _keyOptionsBuilder(options),
    );

    return await _stringResponse("signData", requestBuilder.toBytes());
  }

  static Future<Uint8List> signDataBytes(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignDataBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: _keyOptionsBuilder(options),
    );

    return await _bytesResponse("signDataBytes", requestBuilder.toBytes());
  }

  static Future<String> signDataBytesToString(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignDataBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: _keyOptionsBuilder(options),
    );

    return await _stringResponse(
        "signDataBytesToString", requestBuilder.toBytes());
  }

  static Future<bool> verify(
      String signature, String message, String publicKey) async {
    var requestBuilder = model.VerifyRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      signature: signature,
    );

    return await _boolResponse("verify", requestBuilder.toBytes());
  }

  static Future<bool> verifyBytes(
      String signature, Uint8List message, String publicKey) async {
    var requestBuilder = model.VerifyBytesRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      signature: signature,
    );

    return await _boolResponse("verifyBytes", requestBuilder.toBytes());
  }

  static Future<bool> verifyData(String signature, String publicKey) async {
    var requestBuilder = model.VerifyDataRequestObjectBuilder(
      publicKey: publicKey,
      signature: signature,
    );

    return await _boolResponse("verifyData", requestBuilder.toBytes());
  }

  static Future<bool> verifyDataBytes(
      Uint8List signature, String publicKey) async {
    var requestBuilder = model.VerifyDataBytesRequestObjectBuilder(
      publicKey: publicKey,
      signature: signature,
    );

    return await _boolResponse("verifyDataBytes", requestBuilder.toBytes());
  }

  static Future<String> decryptSymmetric(String message, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.DecryptSymmetricRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      options: _keyOptionsBuilder(options),
    );

    return await _stringResponse("decryptSymmetric", requestBuilder.toBytes());
  }

  static Future<Uint8List> decryptSymmetricBytes(
      Uint8List message, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.DecryptSymmetricBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      options: _keyOptionsBuilder(options),
    );

    return await _bytesResponse(
        "decryptSymmetricBytes", requestBuilder.toBytes());
  }

  static Future<String> encryptSymmetric(String message, String passphrase,
      {KeyOptions? options, FileHints? fileHints}) async {
    var requestBuilder = model.EncryptSymmetricRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      fileHints: _fileHintsBuilder(fileHints),
      options: _keyOptionsBuilder(options),
    );

    return await _stringResponse("encryptSymmetric", requestBuilder.toBytes());
  }

  static Future<Uint8List> encryptSymmetricBytes(
      Uint8List message, String passphrase,
      {KeyOptions? options, FileHints? fileHints}) async {
    var requestBuilder = model.EncryptSymmetricBytesRequestObjectBuilder(
      message: message,
      passphrase: passphrase,
      fileHints: _fileHintsBuilder(fileHints),
      options: _keyOptionsBuilder(options),
    );

    return await _bytesResponse(
        "encryptSymmetricBytes", requestBuilder.toBytes());
  }

  static Future<String> armorEncode(String type, Uint8List data) async {
    var requestBuilder = model.ArmorEncodeRequestObjectBuilder(
      packet: data,
      type: type,
    );

    return await _stringResponse("armorEncode", requestBuilder.toBytes());
  }

  static Future<ArmorMetadata> armorDecode(String message) async {
    var requestBuilder = model.ArmorDecodeRequestObjectBuilder(
      message: message,
    );

    return await _armorDecodeResponse("armorDecode", requestBuilder.toBytes());
  }

  static Future<String> convertPrivateKeyToPublicKey(String privateKey) async {
    var requestBuilder = model.ConvertPrivateKeyToPublicKeyRequestObjectBuilder(
      privateKey: privateKey,
    );

    return await _stringResponse(
        "convertPrivateKeyToPublicKey", requestBuilder.toBytes());
  }

  static Future<PrivateKeyMetadata> getPrivateKeyMetadata(
      String privateKey) async {
    var requestBuilder = model.GetPrivateKeyMetadataRequestObjectBuilder(
      privateKey: privateKey,
    );

    return await _privateKeyMetadataResponse(
        "getPrivateKeyMetadata", requestBuilder.toBytes());
  }

  static Future<PublicKeyMetadata> getPublicKeyMetadata(
      String publicKey) async {
    var requestBuilder = model.GetPublicKeyMetadataRequestObjectBuilder(
      publicKey: publicKey,
    );

    return await _publicKeyMetadataResponse(
        "getPublicKeyMetadata", requestBuilder.toBytes());
  }

  static Future<KeyPair> generate({Options? options}) async {
    var requestBuilder = model.GenerateRequestObjectBuilder(
      options: _optionsBuilder(options),
    );
    return await _keyPairResponse("generate", requestBuilder.toBytes());
  }

  static model.KeyOptionsObjectBuilder? _keyOptionsBuilder(KeyOptions? input) {
    model.KeyOptionsObjectBuilder? builder;
    if (input != null) {
      builder = model.KeyOptionsObjectBuilder(
        cipher: input.cipher != null
            ? model.Cipher.values[input.cipher!.index]
            : null,
        compression: input.compression != null
            ? model.Compression.values[input.compression!.index]
            : null,
        algorithm: input.algorithm != null
            ? model.Algorithm.values[input.algorithm!.index]
            : null,
        curve:
            input.curve != null ? model.Curve.values[input.curve!.index] : null,
        compressionLevel: input.compressionLevel ?? 0,
        hash: input.hash != null ? model.Hash.values[input.hash!.index] : null,
        rsaBits: input.rsaBits ?? 0,
      );
    }
    return builder;
  }

  static model.OptionsObjectBuilder? _optionsBuilder(Options? input) {
    model.OptionsObjectBuilder? builder;
    if (input != null) {
      builder = model.OptionsObjectBuilder(
        passphrase: input.passphrase ?? "",
        comment: input.comment ?? "",
        email: input.email ?? "",
        name: input.name ?? "",
        keyOptions: _keyOptionsBuilder(input.keyOptions),
      );
    }
    return builder;
  }

  static model.EntityObjectBuilder? _entityBuilder(Entity? input) {
    model.EntityObjectBuilder? builder;
    if (input != null) {
      builder = model.EntityObjectBuilder(
        passphrase: input.passphrase ?? "",
        privateKey: input.privateKey ?? "",
        publicKey: input.publicKey ?? "",
      );
    }
    return builder;
  }

  static model.FileHintsObjectBuilder? _fileHintsBuilder(FileHints? input) {
    model.FileHintsObjectBuilder? builder;
    if (input != null) {
      builder = model.FileHintsObjectBuilder(
        fileName: input.fileName ?? "",
        isBinary: input.isBinary ?? false,
        modTime: input.modTime ?? "",
      );
    }
    return builder;
  }
}
