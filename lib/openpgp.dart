import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:openpgp/bridge/binding.dart';
import 'package:openpgp/bridge/model/bridge.pb.dart';

class OpenPGP {
  static const MethodChannel _channel = const MethodChannel('openpgp');
  static bool _bindingSupported = Platform.isWindows || Platform.isLinux;

  static Future<Uint8List> _call(String message, Uint8List payload) async {
    print(Platform.resolvedExecutable);
    print("Platform.isAndroid");
    print(Platform.isAndroid);
    print("Platform.isFuchsia");
    print(Platform.isFuchsia);
    print("Platform.isLinux");
    print(Platform.isLinux);
    print(Platform.operatingSystem);
    print(Platform.packageConfig);
    print(Platform.localeName);
    print(Platform.localHostname);
    print(Platform.numberOfProcessors);
    if (_bindingSupported) {
        return await Binding().call(message, payload);
    }
    return await _channel.invokeMethod(message, payload);
  }

  static Future<Uint8List> _bytesResponse(
      String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = BytesResponse()..mergeFromBuffer(data);
    if (response.hasError()) {
      throw response.error;
    }
    return response.output;
  }

  static Future<String> _stringResponse(String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = StringResponse()..mergeFromBuffer(data);
    if (response.hasError()) {
      throw response.error;
    }
    return response.output;
  }

  static Future<bool> _boolResponse(String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = BoolResponse()..mergeFromBuffer(data);
    if (response.hasError()) {
      throw response.error;
    }
    return response.output;
  }

  static Future<KeyPair> _keyPairResponse(
      String name, Uint8List payload) async {
    var data = await _call(name, payload);
    var response = KeyPairResponse()..mergeFromBuffer(data);
    if (response.hasError()) {
      throw response.error;
    }
    return response.output;
  }

  static Future<String> decrypt(
      String message, String privateKey, String passphrase) async {
    var request = DecryptRequest()
      ..message = message
      ..privateKey = privateKey
      ..passphrase = passphrase;
    return await _stringResponse("decrypt", request.writeToBuffer());
  }

  static Future<Uint8List> decryptBytes(
      Uint8List message, String privateKey, String passphrase) async {
    var request = DecryptBytesRequest()
      ..message = message
      ..privateKey = privateKey
      ..passphrase = passphrase;
    return await _bytesResponse("decryptBytes", request.writeToBuffer());
  }

  static Future<String> encrypt(String message, String publicKey) async {
    var request = EncryptRequest()
      ..message = message
      ..publicKey = publicKey;
    return await _stringResponse("encrypt", request.writeToBuffer());
  }

  static Future<Uint8List> encryptBytes(
      Uint8List message, String publicKey) async {
    var request = EncryptBytesRequest()
      ..message = message
      ..publicKey = publicKey;
    return await _bytesResponse("encryptBytes", request.writeToBuffer());
  }

  static Future<String> sign(String message, String publicKey,
      String privateKey, String passphrase) async {
    var request = SignRequest()
      ..message = message
      ..publicKey = publicKey
      ..privateKey = privateKey
      ..passphrase = passphrase;
    return await _stringResponse("sign", request.writeToBuffer());
  }

  static Future<Uint8List> signBytes(Uint8List message, String publicKey,
      String privateKey, String passphrase) async {
    var request = SignBytesRequest()
      ..message = message
      ..publicKey = publicKey
      ..privateKey = privateKey
      ..passphrase = passphrase;
    return await _bytesResponse("signBytes", request.writeToBuffer());
  }

  static Future<String> signBytesToString(Uint8List message, String publicKey,
      String privateKey, String passphrase) async {
    var request = SignBytesRequest()
      ..message = message
      ..publicKey = publicKey
      ..privateKey = privateKey
      ..passphrase = passphrase;
    return await _stringResponse("signBytesToString", request.writeToBuffer());
  }

  static Future<bool> verify(
      String signature, String message, String publicKey) async {
    var request = VerifyRequest()
      ..message = message
      ..publicKey = publicKey
      ..signature = signature;
    return await _boolResponse("verify", request.writeToBuffer());
  }

  static Future<bool> verifyBytes(
      String signature, Uint8List message, String publicKey) async {
    var request = VerifyBytesRequest()
      ..message = message
      ..publicKey = publicKey
      ..signature = signature;
    return await _boolResponse("verifyBytes", request.writeToBuffer());
  }

  static Future<String> decryptSymmetric(String message, String passphrase,
      {KeyOptions options}) async {
    var request = DecryptSymmetricRequest()
      ..message = message
      ..passphrase = passphrase;
    if (options != null) {
      request.options = options;
    }
    return await _stringResponse("decryptSymmetric", request.writeToBuffer());
  }

  static Future<Uint8List> decryptSymmetricBytes(
      Uint8List message, String passphrase,
      {KeyOptions options}) async {
    var request = DecryptSymmetricBytesRequest()
      ..message = message
      ..passphrase = passphrase;
    if (options != null) {
      request.options = options;
    }
    return await _bytesResponse(
        "decryptSymmetricBytes", request.writeToBuffer());
  }

  static Future<String> encryptSymmetric(String message, String passphrase,
      {KeyOptions options}) async {
    var request = EncryptSymmetricRequest()
      ..message = message
      ..passphrase = passphrase;
    if (options != null) {
      request.options = options;
    }
    return await _stringResponse("encryptSymmetric", request.writeToBuffer());
  }

  static Future<Uint8List> encryptSymmetricBytes(
      Uint8List message, String passphrase,
      {KeyOptions options}) async {
    var request = EncryptSymmetricBytesRequest()
      ..message = message
      ..passphrase = passphrase;
    if (options != null) {
      request.options = options;
    }
    return await _bytesResponse(
        "encryptSymmetricBytes", request.writeToBuffer());
  }

  static Future<KeyPair> generate({Options options}) async {
    var request = GenerateRequest();
    if (options != null) {
      request.options = options;
    }
    return await _keyPairResponse("generate", request.writeToBuffer());
  }
}
