import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp_example/shared/button_widget.dart';
import 'package:openpgp_example/shared/title_widget.dart';

class Convert extends StatefulWidget {
  const Convert({
    Key? key,
    required this.title,
    required KeyPair? this.keyPair,
  }) : super(key: key);

  final String title;
  final KeyPair? keyPair;

  @override
  _ConvertState createState() => _ConvertState();
}

class _ConvertState extends State<Convert> {
  String _result = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Column(
          children: [
            TitleWidget(widget.title),
            ButtonWidget(
              title: "Convert privateKey to publicKey",
              key: Key("action"),
              result: _result,
              onPressed: () async {
                var result = await OpenPGP.convertPrivateKeyToPublicKey(
                    widget.keyPair!.privateKey,
                );

                setState(() {
                  _result = result;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
