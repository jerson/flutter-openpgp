import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:openpgp/binding.dart';
import 'package:openpgp/key_options.dart';
import 'package:openpgp/key_pair.dart';
import 'package:openpgp/options.dart';
import 'package:openpgp/shared.dart';

class OpenPGP {
  static const MethodChannel _channel = const MethodChannel('openpgp');
  static Future<String> decrypt(
      String message, String privateKey, String passphrase) async {
    return await _channel.invokeMethod('decrypt', {
      "message": message,
      "privateKey": privateKey,
      "passphrase": passphrase,
    });
  }

  static Future<Uint8List> decryptBytes(
      Uint8List message, String privateKey, String passphrase) async {
    return await _channel.invokeMethod('decryptBytes', {
      "message": message,
      "privateKey": privateKey,
      "passphrase": passphrase,
    });
  }

  static Future<String> encrypt(String message, String publicKey) async {
    return Binding().encrypt(message, publicKey);
    // return await _channel.invokeMethod('encrypt', {
    //   "message": message,
    //   "publicKey": publicKey,
    // });
  }

  static Future<Uint8List> encryptBytes(
      Uint8List message, String publicKey) async {
    return await _channel.invokeMethod('encryptBytes', {
      "message": message,
      "publicKey": publicKey,
    });
  }

  static Future<String> sign(String message, String publicKey,
      String privateKey, String passphrase) async {
    return await _channel.invokeMethod('sign', {
      "message": message,
      "publicKey": publicKey,
      "privateKey": privateKey,
      "passphrase": passphrase,
    });
  }

  static Future<Uint8List> signBytes(Uint8List message, String publicKey,
      String privateKey, String passphrase) async {
    return await _channel.invokeMethod('signBytes', {
      "message": message,
      "publicKey": publicKey,
      "privateKey": privateKey,
      "passphrase": passphrase,
    });
  }

  static Future<String> signBytesToString(Uint8List message, String publicKey,
      String privateKey, String passphrase) async {
    return await _channel.invokeMethod('signBytesToString', {
      "message": message,
      "publicKey": publicKey,
      "privateKey": privateKey,
      "passphrase": passphrase,
    });
  }

  static Future<bool> verify(
      String signature, String message, String publicKey) async {
    return await _channel.invokeMethod('verify', {
      "signature": signature,
      "message": message,
      "publicKey": publicKey,
    });
  }

  static Future<bool> verifyBytes(
      String signature, Uint8List message, String publicKey) async {
    return await _channel.invokeMethod('verifyBytes', {
      "signature": signature,
      "message": message,
      "publicKey": publicKey,
    });
  }

  static Future<String> decryptSymmetric(String message, String passphrase,
      {KeyOptions options}) async {
    return await _channel.invokeMethod('decryptSymmetric', {
      "message": message,
      "passphrase": passphrase,
      "options": _getKeyOptionsMap(options),
    });
  }

  static Future<Uint8List> decryptSymmetricBytes(
      Uint8List message, String passphrase,
      {KeyOptions options}) async {
    return await _channel.invokeMethod('decryptSymmetricBytes', {
      "message": message,
      "passphrase": passphrase,
      "options": _getKeyOptionsMap(options),
    });
  }

  static Future<String> encryptSymmetric(String message, String passphrase,
      {KeyOptions options}) async {
    return await _channel.invokeMethod('encryptSymmetric', {
      "message": message,
      "passphrase": passphrase,
      "options": _getKeyOptionsMap(options),
    });
  }

  static Future<Uint8List> encryptSymmetricBytes(
      Uint8List message, String passphrase,
      {KeyOptions options}) async {
    return await _channel.invokeMethod('encryptSymmetricBytes', {
      "message": message,
      "passphrase": passphrase,
      "options": _getKeyOptionsMap(options),
    });
  }

  static Future<KeyPair> generate({Options options}) async {
    return Binding().generate(options);
    // var result = await _channel.invokeMethod('generate', {
    //   "options": _getOptionsMap(options),
    // });
    //
    // return KeyPair(
    //   privateKey: result["privateKey"],
    //   publicKey: result["publicKey"],
    // );
  }

  static _getOptionsMap(Options options) {
    var result = {};
    if (options == null) {
      return result;
    }
    if (options.email != null) {
      result["email"] = options.email;
    }
    if (options.name != null) {
      result["name"] = options.name;
    }
    if (options.comment != null) {
      result["comment"] = options.comment;
    }
    if (options.passphrase != null) {
      result["passphrase"] = options.passphrase;
    }
    if (options.keyOptions != null) {
      result["keyOptions"] = _getKeyOptionsMap(options.keyOptions);
    }

    return result;
  }

  static _getKeyOptionsMap(KeyOptions options) {
    var result = {};
    if (options == null) {
      return result;
    }

    if (options.cipher != null) {
      result["cipher"] = toStringCypher(options.cipher);
    }
    if (options.compression != null) {
      result["compression"] = toStringCompression(options.compression);
    }
    if (options.compressionLevel != null) {
      result["compressionLevel"] = options.compressionLevel;
    }
    if (options.hash != null) {
      result["hash"] = toStringHash(options.hash);
    }
    if (options.rsaBits != null) {
      result["rsaBits"] = options.rsaBits;
    }
    return result;
  }

}
