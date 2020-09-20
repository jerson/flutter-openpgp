import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openpgp/bridge/bridge.pb.dart';
import 'package:openpgp/openpgp.dart';
import 'package:openpgp_example/main.dart';
import 'package:openpgp_example/shared/button_widget.dart';
import 'package:openpgp_example/shared/input_widget.dart';
import 'package:openpgp_example/shared/title_widget.dart';

class EncryptAndDecrypt extends StatefulWidget {
  const EncryptAndDecrypt({
    Key key,
    @required this.title,
    @required KeyPair keyPair,
  })  : keyPair = keyPair,
        super(key: key);

  final KeyPair keyPair;
  final String title;

  @override
  _EncryptAndDecryptState createState() => _EncryptAndDecryptState();
}

class _EncryptAndDecryptState extends State<EncryptAndDecrypt> {
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
              title: "Encrypt",
              key: Key("encrypt"),
              result: _encrypted,
              onPressed: (controller) async {
                try {
                  var encrypted = await OpenPGP.encrypt(
                    controller.text,
                    widget.keyPair.publicKey,
                  );
                  setState(() {
                    _encrypted = encrypted;
                  });
                } catch (e) {
                  print(e);
                }
              },
            ),
            ButtonWidget(
              title: "Decrypt",
              key: Key("decrypt"),
              result: _decrypted,
              onPressed: () async {
                var decrypted = await OpenPGP.decrypt(
                  _encrypted,
                  widget.keyPair.privateKey,
                  passphrase,
                );
                setState(() {
                  _decrypted = decrypted;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
