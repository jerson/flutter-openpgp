import 'dart:isolate';
import 'dart:typed_data';

import 'package:openpgp/bridge/binding.dart';

class BridgeArguments {
  final String name;
  final Uint8List payload;
  final SendPort port;

  BridgeArguments(this.name, this.payload, this.port);
}

callBridge(BridgeArguments args) async {
  var result = await Binding().call(args.name, args.payload);
  args.port.send(result);
}
