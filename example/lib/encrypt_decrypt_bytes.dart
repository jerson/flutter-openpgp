import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openpgp/bridge/model/bridge.pb.dart';
import 'package:openpgp/openpgp.dart';
import 'package:openpgp_example/main.dart';
import 'package:openpgp_example/shared/button_widget.dart';
import 'package:openpgp_example/shared/input_widget.dart';
import 'package:openpgp_example/shared/title_widget.dart';

class EncryptAndDecryptBytes extends StatefulWidget {
  const EncryptAndDecryptBytes({
    Key key,
    @required this.title,
    @required KeyPair keyPair,
  })  : keyPair = keyPair,
        super(key: key);

  final KeyPair keyPair;
  final String title;

  @override
  _EncryptAndDecryptBytesState createState() => _EncryptAndDecryptBytesState();
}

class _EncryptAndDecryptBytesState extends State<EncryptAndDecryptBytes> {
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
                var encrypted = await OpenPGP.encryptBytes(
                  Uint8List.fromList(controller.text.codeUnits),
                  widget.keyPair.publicKey,
                );
                setState(() {
                  _encrypted = base64Encode(encrypted);
                });
              },
            ),
            ButtonWidget(
              title: "Decrypt",
              key: Key("decrypt"),
              result: _decrypted,
              onPressed: () async {
                var decrypted = await OpenPGP.decryptBytes(
                  base64Decode(_encrypted),
                  widget.keyPair.privateKey,
                  passphrase,
                );
                setState(() {
                  _decrypted = String.fromCharCodes(decrypted);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
