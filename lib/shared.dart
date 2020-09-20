import 'package:openpgp/bridge/bridge.pb.dart';

String toStringCypher(Cypher input) {
  if (input == null) {
    input = Cypher.CYPHER_AES128;
  }
  return input.toString().replaceFirst("Cypher.", "");
}

String toStringCompression(Compression input) {
  if (input == null) {
    input = Compression.COMPRESSION_NONE;
  }
  return input.toString().replaceFirst("Compression.", "");
}

String toStringHash(Hash input) {
  if (input == null) {
    input = Hash.HASH_SHA256;
  }
  return input.toString().replaceFirst("Hash.", "");
}
