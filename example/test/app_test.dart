import 'package:test/test.dart';
import 'package:openpgp/openpgp.dart';

void main() {
  test('Generate Keypair', () async {
    var keyOptions = KeyOptions()..rsaBits=1024;
    var keyPair =
        await OpenPGP.generate(options: Options()..email = "sample@sample.com"..keyOptions=keyOptions);
    print(keyPair.privateKey);
    expect(keyPair.publicKey != "", true);
  });
}
