import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:openpgp/web/js/js_go.dart';
import 'package:openpgp/web/js/js_promise.dart';
import 'package:openpgp/web/js/js_openpgp_bridge.dart';
import 'package:openpgp/web/js/js_wasm.dart';

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
    return await bridgeCall(call.method, call.arguments);
  }

  Future<Uint8List> bridgeCall(String name, Uint8List payload) async {
    var completer = new Completer<Uint8List>();
    openPGPBridgeCall(name, base64Encode(payload),
        allowInterop((String error, String result) {
      if (error != null && error != "") {
        completer.completeError(error);
        return;
      }
      completer.complete(base64Decode(result));
    }));
    return completer.future;
  }
}
