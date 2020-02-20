import 'dart:async';

import 'package:flutter/services.dart';
import 'package:openpgp/key_options.dart';
import 'package:openpgp/key_pair.dart';
import 'package:openpgp/options.dart';

class OpenPGP {
  static const MethodChannel _channel = const MethodChannel('openpgp');

  static Future<String> decrypt(String message,String privateKey,String passphrase) async {
    return await _channel.invokeMethod('decrypt', {
      "message": message,
      "privateKey": privateKey,
      "passphrase": passphrase,
    });
  }

  static Future<String> encrypt(String message,String publicKey) async {
    return await _channel.invokeMethod('encrypt', {
      "message": message,
      "publicKey": publicKey,
    });
  }

  static Future<String> sign(
      String message,String publicKey,String privateKey,String passphrase) async {
    return await _channel.invokeMethod('sign', {
      "message": message,
      "publicKey": privateKey,
      "privateKey": publicKey,
      "passphrase": passphrase,
    });
  }

  static Future<bool> verify(String signature,String message,String publicKey) async {
    return await _channel.invokeMethod('verify', {
      "signature": signature,
      "message": message,
      "publicKey": publicKey,
    });
  }

  static Future<String> decryptSymmetric(String message,String passphrase,
      {KeyOptions options}) async {
    return await _channel.invokeMethod('decryptSymmetric', {
      "message": message,
      "passphrase": passphrase,
      "options": _getKeyOptionsMap(options),
    });
  }

  static Future<String> encryptSymmetric(String message,String passphrase,
      {KeyOptions options}) async {
    return await _channel.invokeMethod('encryptSymmetric', {
      "message": message,
      "passphrase": passphrase,
      "options": _getKeyOptionsMap(options),
    });
  }

  static Future<KeyPair> generate({Options options}) async {
    var result = await _channel.invokeMethod('generate', {
      "options": _getOptionsMap(options),
    });

    return KeyPair(
      privateKey: result["privateKey"],
      publicKey: result["publicKey"],
    );
  }

  static _getOptionsMap(Options options) {
    return options != null
        ? {
            "email": options.email,
            "name": options.name,
            "comment": options.comment,
            "passphrase": options.passphrase,
            "keyOptions": _getKeyOptionsMap(options.keyOptions),
          }
        : {};
  }

  static _getKeyOptionsMap(KeyOptions options) {
    return options != null
        ? {
            "cipher": options.cipher.toString(),
            "compression": options.compression.toString(),
            "compressionLevel": options.compressionLevel,
            "hash": options.hash.toString(),
            "rsaBits": options.rsaBits,
          }
        : {};
  }
}
