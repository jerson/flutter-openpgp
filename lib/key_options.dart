enum Cypher {
  aes128,
  aes192,
  aes256,
}
enum Compression {
  none,
  zlib,
  zip,
}
enum CompressionLevel {
  none,
  zlib,
  zip,
}
enum Hash {
  sha256,
  sha224,
  sha384,
  sha512,
}

class KeyOptions {
  ///  2048 | 4096 | 1024
  final int rsaBits;
  final Cypher cipher;
  final Compression compression;
  final Hash hash;

  ///  Values: 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
  final int compressionLevel;

  KeyOptions({
    this.rsaBits = 2048,
    this.cipher = Cypher.aes128,
    this.compression = Compression.none,
    this.hash = Hash.sha256,
    this.compressionLevel = 0,
  });
}
