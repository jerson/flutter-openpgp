import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:openpgp/openpgp.dart' as OpenPGP;
import 'package:openpgp_example/shared/button_widget.dart';
import 'package:openpgp_example/shared/title_widget.dart';

class Generate extends StatefulWidget {
  const Generate({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _GenerateState createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  OpenPGP.KeyPair _keyPair = OpenPGP.KeyPair("", "");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Column(
          children: [
            TitleWidget(widget.title),
            ButtonWidget(
              title: "Generate",
              key: Key("action"),
              result: _keyPair.privateKey,
              onPressed: () async {
                var keyOptions = OpenPGP.KeyOptions()
                  ..rsaBits = 2048
                  ..algorithm = OpenPGP.Algorithm.EDDSA;
                var keyPair = await OpenPGP.OpenPGP.generate(
                    options: OpenPGP.Options()
                      ..name = 'test'
                      ..email = 'test@test.com'
                      ..passphrase = 'test'
                      ..keyOptions = keyOptions);

                setState(() {
                  _keyPair = keyPair;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
