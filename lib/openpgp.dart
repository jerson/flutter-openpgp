import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:openpgp/bridge/binding_stub.dart'
    if (dart.library.io) 'package:openpgp/bridge/binding.dart'
    if (dart.library.js) 'package:openpgp/bridge/binding_stub.dart';
import 'package:openpgp/model/bridge_model_generated.dart' as model;

class OpenPGPException implements Exception {
  String cause;

  OpenPGPException(this.cause);
}

enum Hash { SHA256, SHA224, SHA384, SHA512 }

enum Cipher { AES128, AES192, AES256 }

enum Compression { NONE, ZLIB, ZIP }

class Options {
  String? name;
  String? comment;
  String? email;
  String? passphrase;
  KeyOptions? keyOptions;
}

class KeyOptions {
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

class OpenPGP {
  static const MethodChannel _channel = const MethodChannel('openpgp');
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
      throw new OpenPGPException(response.error!);
    }
    return Uint8List.fromList(response.output!);
  }

  static Future<String> _stringResponse(String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = model.StringResponse(data);
    if (response.error != null && response.error != "") {
      throw new OpenPGPException(response.error!);
    }
    return response.output!;
  }

  static Future<bool> _boolResponse(String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = model.BoolResponse(data);
    if (response.error != null && response.error != "") {
      throw new OpenPGPException(response.error!);
    }
    return response.output;
  }

  static Future<KeyPair> _keyPairResponse(
      String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = model.KeyPairResponse(data);
    if (response.error != null && response.error != "") {
      throw new OpenPGPException(response.error!);
    }
    var keyPair = response.output!;
    return KeyPair(keyPair.publicKey!, keyPair.privateKey!);
  }

  static Future<String> decrypt(
      String message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.DecryptRequestObjectBuilder(
      message: message,
      privateKey: privateKey,
      passphrase: passphrase,
      options: _keyOptionsBuilder(options),
    );

    return await _stringResponse("decrypt", requestBuilder.toBytes());
  }

  static Future<Uint8List> decryptBytes(
      Uint8List message, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.DecryptBytesRequestObjectBuilder(
      message: message,
      privateKey: privateKey,
      passphrase: passphrase,
      options: _keyOptionsBuilder(options),
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
      String message, String publicKey, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: _keyOptionsBuilder(options),
    );

    return await _stringResponse("sign", requestBuilder.toBytes());
  }

  static Future<Uint8List> signBytes(
      Uint8List message, String publicKey, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignBytesRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: _keyOptionsBuilder(options),
    );

    return await _bytesResponse("signBytes", requestBuilder.toBytes());
  }

  static Future<String> signBytesToString(
      Uint8List message, String publicKey, String privateKey, String passphrase,
      {KeyOptions? options}) async {
    var requestBuilder = model.SignBytesRequestObjectBuilder(
      publicKey: publicKey,
      message: message,
      passphrase: passphrase,
      privateKey: privateKey,
      options: _keyOptionsBuilder(options),
    );

    return await _stringResponse("signBytesToString", requestBuilder.toBytes());
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
