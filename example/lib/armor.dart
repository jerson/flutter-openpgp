import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp_example/shared/button_widget.dart';
import 'package:openpgp_example/shared/title_widget.dart';
import 'package:openpgp_example/shared/input_widget.dart';

class Armor extends StatefulWidget {
  const Armor({
    super.key,
    required this.title,
  });

  final String title;

  @override
  _ArmorState createState() => _ArmorState();
}

class _ArmorState extends State<Armor> {
  String _encoded = "";
  String _decoded = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Column(
          children: [
            TitleWidget(widget.title),
            InputWidget(
              title: "Armor encode",
              key: Key("encode"),
              result: _encoded,
              onPressed: (controller) async {
                var result = await OpenPGP.armorEncode(
                  "PGP MESSAGE",
                  Uint8List.fromList(controller.text.codeUnits),
                );

                setState(() {
                  _encoded = result;
                });
              },
            ),
            ButtonWidget(
              title: "Decode",
              key: Key("decode"),
              result: _decoded,
              onPressed: () async {
                try {
                  var decoded = await OpenPGP.armorDecode(
                    _encoded,
                  );

                  setState(() {
                    _decoded = "${decoded.type}: ${utf8.decode(decoded.body)}";
                  });
                } on OpenPGPException catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
