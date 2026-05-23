import 'package:flutter/foundation.dart';
import 'package:openpgp/openpgp.dart';
import 'package:openpgp/openpgp_sync.dart';
import 'package:test/test.dart';

void main() {
  var keyOptions = KeyOptions()..rsaBits = 2048;
  var options = Options()
    ..email = "sample@sample.com"
    ..keyOptions = keyOptions;

  test('Generate Keypair', () async {
    var keyPair = await OpenPGP.generate(options: options);

    expect(keyPair, isNotNull, reason: "Key pair generation failed.");
    expect(keyPair.publicKey, isNotEmpty,
        reason: "Public key should not be empty.");
    expect(keyPair.privateKey, isNotEmpty,
        reason: "Private key should not be empty.");
  });

  test('Encrypt/Decrypt', () async {
    var keyPair = await OpenPGP.generate(options: options);

    var encrypted = await OpenPGP.encrypt("hello", keyPair.publicKey);
    var decrypted = await OpenPGP.decrypt(encrypted, keyPair.privateKey, "");
    expect(decrypted, equals("hello"));
  });

  test('Generate Keypair Sync/Compute', () async {
    final keyPair = await compute(
      (options) => OpenPGPSync.generate(options: options),
      options,
    );

    expect(keyPair, isNotNull, reason: "Key pair generation failed.");
    expect(keyPair.publicKey, isNotEmpty,
        reason: "Public key should not be empty.");
    expect(keyPair.privateKey, isNotEmpty,
        reason: "Private key should not be empty.");

    print(keyPair.privateKey);
  });

  // ── PQC tests ──────────────────────────────────────────────────────────────

  test('PQC: Generate ML-DSA-65+Ed25519 keypair', () async {
    var pqcOptions = Options()
      ..email = "pqc@sample.com"
      ..keyOptions = (KeyOptions()..algorithm = Algorithm.MLDSA65ED25519);

    var keyPair = await OpenPGP.generate(options: pqcOptions);

    expect(keyPair.publicKey, isNotEmpty);
    expect(keyPair.privateKey, isNotEmpty);
    expect(keyPair.publicKey, contains('BEGIN PGP PUBLIC KEY BLOCK'));
  });

  test('PQC: Generate ML-DSA-87+Ed448 keypair', () async {
    var pqcOptions = Options()
      ..email = "pqc87@sample.com"
      ..keyOptions = (KeyOptions()..algorithm = Algorithm.MLDSA87ED448);

    var keyPair = await OpenPGP.generate(options: pqcOptions);

    expect(keyPair.publicKey, isNotEmpty);
    expect(keyPair.privateKey, isNotEmpty);
  });

  test('PQC: Generate ML-KEM-768+X25519 keypair', () async {
    var pqcOptions = Options()
      ..email = "mlkem@sample.com"
      ..keyOptions = (KeyOptions()..algorithm = Algorithm.MLKEM768X25519);

    var keyPair = await OpenPGP.generate(options: pqcOptions);

    expect(keyPair.publicKey, isNotEmpty);
    expect(keyPair.privateKey, isNotEmpty);
  });

  test('PQC: ML-DSA-65 key metadata shows correct algorithm', () async {
    var pqcOptions = Options()
      ..email = "meta@sample.com"
      ..keyOptions = (KeyOptions()..algorithm = Algorithm.MLDSA65ED25519);

    var keyPair = await OpenPGP.generate(options: pqcOptions);
    var meta = await OpenPGP.getPublicKeyMetadata(keyPair.publicKey);

    expect(meta.algorithm, equals('ML-DSA-65+Ed25519'));
  });
}
