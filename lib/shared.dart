import 'package:openpgp/models.dart';

String toStringCypher(Cypher input) {
  if (input == null) {
    input = Cypher.aes128;
  }
  return input.toString().replaceFirst("Cypher.", "");
}

String toStringCompression(Compression input) {
  if (input == null) {
    input = Compression.none;
  }
  return input.toString().replaceFirst("Compression.", "");
}

String toStringHash(Hash input) {
  if (input == null) {
    input = Hash.sha256;
  }
  return input.toString().replaceFirst("Hash.", "");
}
