import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openpgp/key_pair.dart';
import 'package:openpgp/openpgp.dart';
import 'package:openpgp_example/main.dart';
import 'package:openpgp_example/shared/button_widget.dart';
import 'package:openpgp_example/shared/input_widget.dart';
import 'package:openpgp_example/shared/title_widget.dart';

class SignAndVerifyBytes extends StatefulWidget {
  const SignAndVerifyBytes({
    Key key,
    @required this.title,
    @required KeyPair keyPair,
  })  : keyPair = keyPair,
        super(key: key);

  final KeyPair keyPair;
  final String title;

  @override
  _SignAndVerifyBytesState createState() => _SignAndVerifyBytesState();
}

class _SignAndVerifyBytesState extends State<SignAndVerifyBytes> {
  String _signed = "";
  String _signedBytes = "";
  String _verify = "";
  String _text = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Column(
          children: [
            TitleWidget(widget.title),
            InputWidget(
              title: "Sign",
              key: Key("sign"),
              result: _signed,
              onPressed: (controller) async {
                var result = await OpenPGP.signBytesToString(
                  Uint8List.fromList(controller.text.codeUnits),
                  widget.keyPair.publicKey,
                  widget.keyPair.privateKey,
                  passphrase,
                );
                setState(() {
                  _text = controller.text;
                  _signed = result;
                });
              },
            ),
            ButtonWidget(
              title: "Verify",
              key: Key("verify"),
              result: _verify,
              onPressed: () async {
                var result = await OpenPGP.verifyBytes(
                  _signed,
                  Uint8List.fromList(_text.codeUnits),
                  widget.keyPair.publicKey,
                );
                setState(() {
                  _verify = result ? "VALID" : "INVALID";
                });
              },
            ),
            InputWidget(
              title: "Sign Bytes",
              key: Key("sign-bytes"),
              result: _signedBytes,
              onPressed: (controller) async {
                var result = await OpenPGP.signBytes(
                  Uint8List.fromList(controller.text.codeUnits),
                  widget.keyPair.publicKey,
                  widget.keyPair.privateKey,
                  passphrase,
                );
                setState(() {
                  _signedBytes = base64Encode(result);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
