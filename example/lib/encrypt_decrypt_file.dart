import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp_example/main.dart';
import 'package:openpgp_example/shared/button_widget.dart';
import 'package:openpgp_example/shared/title_widget.dart';

class EncryptAndDecryptFile extends StatefulWidget {
  const EncryptAndDecryptFile({
    Key? key,
    required this.title,
    required KeyPair? keyPair,
  })   : keyPair = keyPair,
        super(key: key);

  final KeyPair? keyPair;
  final String title;

  @override
  _EncryptAndDecryptFileState createState() => _EncryptAndDecryptFileState();
}

class _EncryptAndDecryptFileState extends State<EncryptAndDecryptFile> {
  String _encrypted = "";
  String _decrypted = "";

  _encrypt() async {
    String inputPath = "/home/usuario/Desktop/zip/sample.zip";
    File input = File(inputPath);
    print("start");
    var encrypted = await OpenPGP.encryptBytes(
      input.readAsBytesSync(),
      widget.keyPair!.publicKey,
      fileHints: FileHints()..isBinary = true,
    );
    print("end");
    String outputPath = inputPath + ".encrypted";
    print("output $outputPath");
    File output = File(outputPath);
    await output.writeAsBytes(encrypted);

    await File(inputPath + ".pub").writeAsString(widget.keyPair!.publicKey);
    await File(inputPath + ".key").writeAsString(widget.keyPair!.privateKey);

    print("saved");
    setState(() {
      _encrypted = "saved in $outputPath";
    });
  }

  _decrypt() async {
    {
      String inputPath = "/home/usuario/Desktop/zip/sample.zip.encrypted";
      File input = File(inputPath);
      print("start");
      var decrypted = await OpenPGP.decryptBytes(
        input.readAsBytesSync(),
        widget.keyPair!.privateKey,
        passphrase,
      );
      print("end");
      String outputPath = inputPath + ".decrypted.zip";
      print("output $outputPath");
      File output = File(outputPath);
      await output.writeAsBytes(decrypted);
      print("saved");
      setState(() {
        _decrypted = "saved in $outputPath";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Column(
          children: [
            TitleWidget(widget.title),
            ButtonWidget(
              title: "Encrypt file",
              key: Key("encrypt-file"),
              result: _encrypted,
              onPressed: _encrypt,
            ),
            ButtonWidget(
              title: "Decrypt file",
              key: Key("decrypt-file"),
              result: _decrypted,
              onPressed: _decrypt,
            ),
          ],
        ),
      ),
    );
  }
}
