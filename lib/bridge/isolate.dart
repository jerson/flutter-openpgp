import 'dart:typed_data';
import 'dart:isolate';

// Legacy argument bag — kept so nothing else needs to change.
class IsolateArguments {
  final String name;
  final Uint8List payload;
  final SendPort port;
  IsolateArguments(this.name, this.payload, this.port);
}

// Message types used by the persistent BridgeIsolate in binding.dart.
class BridgeRequest {
  final int id;
  final String name;
  final Uint8List payload;
  BridgeRequest(this.id, this.name, this.payload);
}

class BridgeResponse {
  final int id;
  final Uint8List? data;
  final String? error;
  BridgeResponse({required this.id, this.data, this.error});
}
