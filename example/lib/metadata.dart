import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp_example/main.dart';
import 'package:openpgp_example/shared/button_widget.dart';
import 'package:openpgp_example/shared/input_widget.dart';
import 'package:openpgp_example/shared/title_widget.dart';

class Metadata extends StatefulWidget {
  const Metadata({
    Key? key,
    required this.title,
    required KeyPair? keyPair,
  })  : keyPair = keyPair,
        super(key: key);

  final KeyPair? keyPair;
  final String title;

  @override
  _MetadataState createState() => _MetadataState();
}

class _MetadataState extends State<Metadata> {
  String _privateKeyMetadata = "";
  String _publicKeyMetadata = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Column(
          children: [
            TitleWidget(widget.title),
            ButtonWidget(
              title: "PublicKey Metadata",
              key: Key("publicKey"),
              result: _publicKeyMetadata,
              onPressed: () async {
                var result = await OpenPGP.getPublicKeyMetadata(
                  widget.keyPair!.publicKey,
                );
                setState(() {
                  var encoder = JsonEncoder.withIndent(" ");
                  _publicKeyMetadata = encoder.convert(result);
                });
              },
            ),
            ButtonWidget(
              title: "PrivateKeyMetadata",
              key: Key("privateKey"),
              result: _privateKeyMetadata,
              onPressed: () async {
                var result = await OpenPGP.getPrivateKeyMetadata(
                  widget.keyPair!.privateKey,
                );
                setState(() {
                  var encoder = JsonEncoder.withIndent(" ");
                  _privateKeyMetadata = encoder.convert(result);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
