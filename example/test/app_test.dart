import 'package:test/test.dart';
import 'package:openpgp/openpgp.dart';

void main() {
  test('Generate Keypair', () async {
    var keyPair = await OpenPGP.generate(options: Options()..email="sample@sample.com");
    print(keyPair.privateKey);
    expect(keyPair.publicKey != "", true);
  });
}
