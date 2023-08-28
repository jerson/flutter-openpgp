import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp_example/main.dart';
import 'package:openpgp_example/shared/button_widget.dart';
import 'package:openpgp_example/shared/input_widget.dart';
import 'package:openpgp_example/shared/title_widget.dart';

class SignAndVerifyData extends StatefulWidget {
  const SignAndVerifyData({
    Key? key,
    required this.title,
    required KeyPair? keyPair,
  })  : keyPair = keyPair,
        super(key: key);

  final KeyPair? keyPair;
  final String title;

  @override
  _SignAndVerifyDataState createState() => _SignAndVerifyDataState();
}

class _SignAndVerifyDataState extends State<SignAndVerifyData> {
  String _signed = "";
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
                var result = await OpenPGP.signData(
                  controller.text,
                  widget.keyPair!.privateKey,
                  passphrase,
                );
                setState(() {
                  _signed = result;
                });
              },
            ),
            ButtonWidget(
              title: "Verify",
              key: Key("verify"),
              result: _verify,
              onPressed: () async {
                var result = await OpenPGP.verifyData(
                  _signed,
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
