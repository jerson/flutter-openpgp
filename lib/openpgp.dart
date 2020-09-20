import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:openpgp/binding.dart';
import 'package:openpgp/bridge/bridge.pb.dart';
import 'package:openpgp/shared.dart';

class OpenPGP {
  static const MethodChannel _channel = const MethodChannel('openpgp');
  static bool _bindingSupported = Platform.isMacOS ||
      Platform.isWindows ||
      Platform.isLinux ||
      Platform.isFuchsia;

  static Future<Uint8List> _call(String message, Uint8List payload) async {
    if (_bindingSupported) {
      // the idea its that only should use this
      return await Binding().call(message, payload);
    }
    // this is a fallback not sure but here its :D
    return await _channel.invokeMethod('call', payload);
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
    if (_bindingSupported) {
      var request = DecryptRequest()
        ..message = message
        ..privateKey = privateKey
        ..passphrase = passphrase;
      return await _stringResponse("decrypt", request.writeToBuffer());
    }
    return await _channel.invokeMethod('decrypt', {
      "message": message,
      "privateKey": privateKey,
      "passphrase": passphrase,
    });
  }

  static Future<Uint8List> decryptBytes(
      Uint8List message, String privateKey, String passphrase) async {
    if (_bindingSupported) {
      var request = DecryptBytesRequest()
        ..message = message
        ..privateKey = privateKey
        ..passphrase = passphrase;
      return await _bytesResponse("decryptBytes", request.writeToBuffer());
    }
    return await _channel.invokeMethod('decryptBytes', {
      "message": message,
      "privateKey": privateKey,
      "passphrase": passphrase,
    });
  }

  static Future<String> encrypt(String message, String publicKey) async {
    if (_bindingSupported) {
      var request = EncryptRequest()
        ..message = message
        ..publicKey = publicKey;
      return await _stringResponse("encrypt", request.writeToBuffer());
    }
    return await _channel.invokeMethod('encrypt', {
      "message": message,
      "publicKey": publicKey,
    });
  }

  static Future<Uint8List> encryptBytes(
      Uint8List message, String publicKey) async {
    if (_bindingSupported) {
      var request = EncryptBytesRequest()
        ..message = message
        ..publicKey = publicKey;
      return await _bytesResponse("encryptBytes", request.writeToBuffer());
    }
    return await _channel.invokeMethod('encryptBytes', {
      "message": message,
      "publicKey": publicKey,
    });
  }

  static Future<String> sign(String message, String publicKey,
      String privateKey, String passphrase) async {
    if (_bindingSupported) {
      var request = SignRequest()
        ..message = message
        ..publicKey = publicKey
        ..privateKey = privateKey
        ..passphrase = passphrase;
      return await _stringResponse("sign", request.writeToBuffer());
    }
    return await _channel.invokeMethod('sign', {
      "message": message,
      "publicKey": publicKey,
      "privateKey": privateKey,
      "passphrase": passphrase,
    });
  }

  static Future<Uint8List> signBytes(Uint8List message, String publicKey,
      String privateKey, String passphrase) async {
    if (_bindingSupported) {
      var request = SignBytesRequest()
        ..message = message
        ..publicKey = publicKey
        ..privateKey = privateKey
        ..passphrase = passphrase;
      return await _bytesResponse("signBytes", request.writeToBuffer());
    }
    return await _channel.invokeMethod('signBytes', {
      "message": message,
      "publicKey": publicKey,
      "privateKey": privateKey,
      "passphrase": passphrase,
    });
  }

  static Future<String> signBytesToString(Uint8List message, String publicKey,
      String privateKey, String passphrase) async {
    if (_bindingSupported) {
      var request = SignBytesRequest()
        ..message = message
        ..publicKey = publicKey
        ..privateKey = privateKey
        ..passphrase = passphrase;
      return await _stringResponse(
          "signBytesToString", request.writeToBuffer());
    }
    return await _channel.invokeMethod('signBytesToString', {
      "message": message,
      "publicKey": publicKey,
      "privateKey": privateKey,
      "passphrase": passphrase,
    });
  }

  static Future<bool> verify(
      String signature, String message, String publicKey) async {
    if (_bindingSupported) {
      var request = VerifyRequest()
        ..message = message
        ..publicKey = publicKey
        ..signature = signature;
      return await _boolResponse("verify", request.writeToBuffer());
    }
    return await _channel.invokeMethod('verify', {
      "signature": signature,
      "message": message,
      "publicKey": publicKey,
    });
  }

  static Future<bool> verifyBytes(
      String signature, Uint8List message, String publicKey) async {
    if (_bindingSupported) {
      var request = VerifyBytesRequest()
        ..message = message
        ..publicKey = publicKey
        ..signature = signature;
      return await _boolResponse("verifyBytes", request.writeToBuffer());
    }
    return await _channel.invokeMethod('verifyBytes', {
      "signature": signature,
      "message": message,
      "publicKey": publicKey,
    });
  }

  static Future<String> decryptSymmetric(String message, String passphrase,
      {KeyOptions options}) async {
    if (_bindingSupported) {
      var request = DecryptSymmetricRequest()
        ..message = message
        ..passphrase = passphrase
        ..options = options;
      return await _stringResponse("decryptSymmetric", request.writeToBuffer());
    }
    return await _channel.invokeMethod('decryptSymmetric', {
      "message": message,
      "passphrase": passphrase,
      "options": _getKeyOptionsMap(options),
    });
  }

  static Future<Uint8List> decryptSymmetricBytes(
      Uint8List message, String passphrase,
      {KeyOptions options}) async {
    if (_bindingSupported) {
      var request = DecryptSymmetricBytesRequest()
        ..message = message
        ..passphrase = passphrase
        ..options = options;
      return await _bytesResponse(
          "decryptSymmetricBytes", request.writeToBuffer());
    }
    return await _channel.invokeMethod('decryptSymmetricBytes', {
      "message": message,
      "passphrase": passphrase,
      "options": _getKeyOptionsMap(options),
    });
  }

  static Future<String> encryptSymmetric(String message, String passphrase,
      {KeyOptions options}) async {
    if (_bindingSupported) {
      var request = EncryptSymmetricRequest()
        ..message = message
        ..passphrase = passphrase
        ..options = options;
      return await _stringResponse("encryptSymmetric", request.writeToBuffer());
    }
    return await _channel.invokeMethod('encryptSymmetric', {
      "message": message,
      "passphrase": passphrase,
      "options": _getKeyOptionsMap(options),
    });
  }

  static Future<Uint8List> encryptSymmetricBytes(
      Uint8List message, String passphrase,
      {KeyOptions options}) async {
    if (_bindingSupported) {
      var request = EncryptSymmetricBytesRequest()
        ..message = message
        ..passphrase = passphrase
        ..options = options;
      return await _bytesResponse(
          "encryptSymmetricBytes", request.writeToBuffer());
    }
    return await _channel.invokeMethod('encryptSymmetricBytes', {
      "message": message,
      "passphrase": passphrase,
      "options": _getKeyOptionsMap(options),
    });
  }

  static Future<KeyPair> generate({Options options}) async {
    if (_bindingSupported) {
      var request = GenerateRequest()..options = options;
      return await _keyPairResponse("generate", request.writeToBuffer());
    }
    var result = await _channel.invokeMethod('generate', {
      "options": _getOptionsMap(options),
    });

    return KeyPair()
      ..privateKey = result["privateKey"]
      ..publicKey = result["publicKey"];
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
