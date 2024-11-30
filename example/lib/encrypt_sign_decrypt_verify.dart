import 'package:flutter/material.dart';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp_example/main.dart';
import 'package:openpgp_example/shared/button_widget.dart';
import 'package:openpgp_example/shared/input_widget.dart';
import 'package:openpgp_example/shared/title_widget.dart';

class EncryptSignAndDecryptVerify extends StatefulWidget {
  const EncryptSignAndDecryptVerify({
    Key? key,
    required this.title,
    required KeyPair? keyPair,
  })  : keyPair = keyPair,
        super(key: key);

  final KeyPair? keyPair;
  final String title;

  @override
  _EncryptSignAndDecryptVerifyState createState() =>
      _EncryptSignAndDecryptVerifyState();
}

class _EncryptSignAndDecryptVerifyState
    extends State<EncryptSignAndDecryptVerify> {
  String _encrypted = "";
  String _decrypted = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Column(
          children: [
            TitleWidget(widget.title),
            InputWidget(
              title: "EncryptSign",
              key: Key("encrypt"),
              result: _encrypted,
              onPressed: (controller) async {
                try {
                  var entity = Entity();
                  entity.privateKey = widget.keyPair!.privateKey;
                  entity.passphrase = passphrase;
                  var encrypted = await OpenPGP.encrypt(
                    controller.text,
                    widget.keyPair!.publicKey,
                    signed: entity,
                  );
                  setState(() {
                    _encrypted = encrypted;
                  });
                } catch (e) {
                  print(e.toString());
                }
              },
            ),
            ButtonWidget(
              title: "DecryptVerify",
              key: Key("decrypt"),
              result: _decrypted,
              onPressed: () async {
                try {
                  var entity = Entity();
                  entity.publicKey = widget.keyPair!.publicKey;
                  var decrypted = await OpenPGP.decrypt(
                    _encrypted,
                    widget.keyPair!.privateKey,
                    passphrase,
                    signed: entity,
                  );
                  setState(() {
                    _decrypted = decrypted;
                  });
                } catch (e) {
                  print(e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
