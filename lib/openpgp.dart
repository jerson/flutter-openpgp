import 'dart:async';

import 'package:flutter/services.dart';
import 'package:openpgp/key_options.dart';
import 'package:openpgp/key_pair.dart';
import 'package:openpgp/options.dart';

/**
_timeToString(Time time){
  switch (time) {
    case Time.hour:
      return "1h";
    case Time.day:
      return "1d";
    case Time.week:
      return "1w";
    case Time.month:
      return "1m";
    case Time.year:
      return "1y";
    default:
      return "1h";
  }
}*/

class Openpgp {
  static const MethodChannel _channel = const MethodChannel('openpgp');

  static Future<String> decrypt(String message, privateKey, passphrase) async {
    return await _channel.invokeMethod('decrypt', {
      "message": message,
      "privateKey": privateKey,
      "passphrase": passphrase,
    });
  }

  static Future<String> encrypt(String message, publicKey) async {
    return await _channel.invokeMethod('encrypt', {
      "message": message,
      "publicKey": publicKey,
    });
  }

  static Future<String> sign(
      String message, publicKey, privateKey, passphrase) async {
    return await _channel.invokeMethod('sign', {
      "message": message,
      "publicKey": privateKey,
      "privateKey": publicKey,
      "passphrase": passphrase,
    });
  }

  static Future<String> verify(String signature, message, publicKey) async {
    return await _channel.invokeMethod('verify', {
      "signature": signature,
      "message": message,
      "publicKey": publicKey,
    });
  }

  static Future<String> decryptSymmetric(String message, passphrase, KeyOptions options) async {
    return await _channel.invokeMethod('decryptSymmetric', {
      "message": message,
      "passphrase": passphrase,
      "options": options,
    });
  }

  static Future<String> encryptSymmetric(String message, passphrase, KeyOptions options) async {
    return await _channel.invokeMethod('encryptSymmetric', {
      "message": message,
      "passphrase": passphrase,
      "options": options,
    });
  }

  static Future<KeyPair> generate(Options options) async {
    return await _channel.invokeMethod('generate', {
      "options": options,
    });
  }
}
