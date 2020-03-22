import 'dart:async';

import 'package:openpgp/web/js/go.dart';
import 'package:openpgp/web/js/promise.dart';
import 'package:openpgp/web/js/openpgp.dart';
import 'package:openpgp/web/js/wasm.dart';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';

class OpenpgpPlugin {
  bool _ready = false;

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        'openpgp', const StandardMethodCodec(), registrar.messenger);
    final OpenpgpPlugin instance = OpenpgpPlugin();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<bool> loadInstance() async {
    if (_ready == true) {
      return true;
    }

    var data =
        await rootBundle.load('packages/openpgp/web/assets/openpgp.wasm');
    var go = new Go();

    var result = await promiseToFutureInterop(WebAssembly.instantiate(
      data.buffer,
      go.importObject,
    ));

    promiseToFutureInterop(go.run(result.instance)).then((result) {
      consoleLog(result);
      _ready = false;
      loadInstance();
    });

    _ready = true;

    return true;
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    await loadInstance();

    switch (call.method) {
      case 'decrypt':
        return await decrypt(
          call.arguments['message'],
          call.arguments['privateKey'],
          call.arguments['passphrase'],
        );
      case 'encrypt':
        return await encrypt(
          call.arguments['message'],
          call.arguments['publicKey'],
        );
      case 'sign':
        return await sign(
          call.arguments['message'],
          call.arguments['publicKey'],
          call.arguments['privateKey'],
          call.arguments['passphrase'],
        );
      case 'verify':
        return await verify(
          call.arguments['signature'],
          call.arguments['message'],
          call.arguments['publicKey'],
        );
      case 'decryptSymmetric':
        return await decryptSymmetric(
          call.arguments['message'],
          call.arguments['passphrase'],
          call.arguments['options'],
        );
      case 'encryptSymmetric':
        return await encryptSymmetric(
          call.arguments['message'],
          call.arguments['passphrase'],
          call.arguments['options'],
        );
      case 'generate':
        return await generate(
          call.arguments['options'],
        );
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The openpgp plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  Future<String> decrypt(
      String message, String privateKey, String passphrase) async {
    var completer = new Completer<String>();
    OpenPGPDecrypt(message, privateKey, passphrase,
        allowInterop((String error, String result) {
      if (error != null && error != "") {
        completer.completeError(error);
        return;
      }
      completer.complete(result);
    }));
    return completer.future;
  }

  Future<String> encrypt(String message, String publicKey) async {
    var completer = new Completer<String>();
    OpenPGPEncrypt(message, publicKey,
        allowInterop((String error, String result) {
      if (error != null && error != "") {
        completer.completeError(error);
        return;
      }
      completer.complete(result);
    }));
    return completer.future;
  }

  Future<String> sign(String message, String publicKey, String privateKey,
      String passphrase) async {
    var completer = new Completer<String>();
    OpenPGPSign(message, publicKey, privateKey, passphrase,
        allowInterop((String error, String result) {
      if (error != null && error != "") {
        completer.completeError(error);
        return;
      }
      completer.complete(result);
    }));
    return completer.future;
  }

  Future<bool> verify(
      String signature, String message, String publicKey) async {
    var completer = new Completer<bool>();
    OpenPGPVerify(signature, message, publicKey,
        allowInterop((String error, bool result) {
      if (error != null && error != "") {
        completer.completeError(error);
        return;
      }
      completer.complete(result);
    }));
    return completer.future;
  }

  Future<String> decryptSymmetric(
      String message, String passphrase, dynamic options) async {
    var completer = new Completer<String>();
    OpenPGPDecryptSymmetric(message, passphrase, _getKeyOptionsMap(options),
        allowInterop((String error, String result) {
      if (error != null && error != "") {
        completer.completeError(error);
        return;
      }
      completer.complete(result);
    }));
    return completer.future;
  }

  Future<String> encryptSymmetric(
      String message, String passphrase, dynamic options) async {
    var completer = new Completer<String>();
    OpenPGPEncryptSymmetric(message, passphrase, _getKeyOptionsMap(options),
        allowInterop((String error, String result) {
      if (error != null && error != "") {
        completer.completeError(error);
        return;
      }
      completer.complete(result);
    }));
    return completer.future;
  }

  Future<dynamic> generate(dynamic options) async {
    var completer = new Completer<dynamic>();
    OpenPGPGenerate(_getOptionsMap(options),
        allowInterop((String error, KeyPairObject result) {
      if (error != null && error != "") {
        completer.completeError(error);
        return;
      }
      completer.complete({
        "publicKey": result.publicKey,
        "privateKey": result.privateKey,
      });
    }));
    return completer.future;
  }

  static OptionsObject _getOptionsMap(dynamic options) {
    var result = OptionsObject();
    if (options == null) {
      return result;
    }
    if (options["email"] != null) {
      result.email = options["email"];
    }
    if (options["name"] != null) {
      result.name = options["name"];
    }
    if (options["comment"] != null) {
      result.comment = options["comment"];
    }
    if (options["passphrase"] != null) {
      result.passphrase = options["passphrase"];
    }
    if (options["keyOptions"] != null) {
      result.keyOptions = _getKeyOptionsMap(options["keyOptions"]);
    }

    return result;
  }

  static KeyOptionsObject _getKeyOptionsMap(dynamic options) {
    var result = KeyOptionsObject();
    if (options == null) {
      return result;
    }

    if (options["cipher"] != null) {
      result.cipher = options["cipher"];
    }
    if (options["compression"] != null) {
      result.compression = options["compression"];
    }
    if (options["compressionLevel"] != null) {
      result.compressionLevel = options["compressionLevel"];
    }
    if (options["hash"] != null) {
      result.hash = options["hash"];
    }
    if (options["rsaBits"] != null) {
      result.rsaBits = options["rsaBits"];
    }

    return result;
  }
}
