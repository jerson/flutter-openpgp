@JS()
library js_openpgp_bridge;

import 'package:js/js.dart';

@JS()
external openPGPBridgeCall(
  String name,
  String payload,
  Function(String error, String result) callback,
);
