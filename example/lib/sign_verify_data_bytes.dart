import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp_example/main.dart';
import 'package:openpgp_example/shared/button_widget.dart';
import 'package:openpgp_example/shared/input_widget.dart';
import 'package:openpgp_example/shared/title_widget.dart';

class SignAndVerifyDataBytes extends StatefulWidget {
  const SignAndVerifyDataBytes({
    super.key,
    required this.title,
    required KeyPair? keyPair,
  })  : keyPair = keyPair;

  final KeyPair? keyPair;
  final String title;

  @override
  _SignAndVerifyDataBytesState createState() => _SignAndVerifyDataBytesState();
}

class _SignAndVerifyDataBytesState extends State<SignAndVerifyDataBytes> {
  String _signed = "";
  final String _signedBytes = "";
  String _verify = "";

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
                var result = await OpenPGP.signDataBytes(
                  Uint8List.fromList(controller.text.codeUnits),
                  widget.keyPair!.privateKey,
                  passphrase,
                );
                setState(() {
                  _signed = base64Encode(result);
                });
              },
            ),
            ButtonWidget(
              title: "Verify",
              key: Key("verify"),
              result: _verify,
              onPressed: () async {
                var result = await OpenPGP.verifyDataBytes(
                  base64Decode(_signed),
                  widget.keyPair!.publicKey,
                );
                setState(() {
                  _verify = result ? "VALID" : "INVALID";
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
