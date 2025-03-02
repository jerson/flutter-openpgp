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
}
