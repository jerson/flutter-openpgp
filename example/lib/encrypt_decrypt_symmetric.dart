import 'package:flutter/material.dart';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp_example/main.dart';
import 'package:openpgp_example/shared/button_widget.dart';
import 'package:openpgp_example/shared/input_widget.dart';
import 'package:openpgp_example/shared/title_widget.dart';

class EncryptAndDecryptSymmetric extends StatefulWidget {
  const EncryptAndDecryptSymmetric({
    super.key,
    required this.title,
    required KeyPair? keyPair,
  }) : keyPair = keyPair;

  final KeyPair? keyPair;
  final String title;

  @override
  _EncryptAndDecryptSymmetricState createState() =>
      _EncryptAndDecryptSymmetricState();
}

class _EncryptAndDecryptSymmetricState
    extends State<EncryptAndDecryptSymmetric> {
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
                var encrypted = await OpenPGP.encryptSymmetric(
                  controller.text,
                  passphrase,
                );
                setState(() {
                  _encrypted = encrypted;
                });
              },
            ),
            ButtonWidget(
              title: "Decrypt",
              key: Key("decrypt"),
              result: _decrypted,
              onPressed: () async {
                var decrypted = await OpenPGP.decryptSymmetric(
                  _encrypted,
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
