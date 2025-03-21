import 'dart:async';

import 'package:flutter/services.dart';
import 'package:openpgp/bridge/binding_stub.dart'
    if (dart.library.io) 'package:openpgp/bridge/binding.dart'
    if (dart.library.js) 'package:openpgp/bridge/binding_stub.dart';

class OpenPGPBridge {
  static const MethodChannel _channel = MethodChannel('openpgp');
  static final bool bindingEnabled = Binding().isSupported();

  static Future<Uint8List> call(String name, Uint8List payload) async {
    if (bindingEnabled) {
      return Binding().callAsync(name, payload);
    }

    return await _channel.invokeMethod(name, payload);
  }

  static Uint8List callSync(String name, Uint8List payload) {
    if (!bindingEnabled) {
      throw UnimplementedError(
          'Synchronous call is not supported on this platform');
    }
    return Binding().call(name, payload);
  }
}
