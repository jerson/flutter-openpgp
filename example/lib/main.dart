import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp_example/encrypt_decrypt.dart';
import 'package:openpgp_example/encrypt_decrypt_bytes.dart';
import 'package:openpgp_example/encrypt_decrypt_file.dart';
import 'package:openpgp_example/encrypt_decrypt_symmetric.dart';
import 'package:openpgp_example/encrypt_decrypt_symmetric_bytes.dart';
import 'package:openpgp_example/generate.dart';
import 'package:openpgp_example/sign_verify.dart';
import 'package:openpgp_example/sign_verify_bytes.dart';

const passphrase = 'test';

void main() {
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

const publicKey = '''
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: openpgp-mobile

xo0EYhESVwEEANJlqV1TdYvcKQbtMlW+L3cOIFT55YOVMfH0NMg9l0A8rSjJfir5
QL27McbEk0K4jFa0ZLM1DgFkOvw35qcIZ3YVMlBFiIeJMqRQUB/qzyGNS4cqN5Tj
TPK4zNVSjXF+Y0REA73/r9NGfG8vs7wEWOG/S6/eXomvcUQ4Htg4uMYLABEBAAHN
FHRlc3QgPHRlc3RAdGVzdC5jb20+wqgEEwEIABwFAmIRElcJEE00V8y9gx9zAhsD
AhkBAgsHAhUIAABmWAQABuX5cBVi0ZDZWdN4T0JELZF5S3Z8GUP7z8G53Mlum4ta
TUlc7qKGISEH8Rich/hxGdQsKp4llxOFS26v5lnkLBsAFTNhC1zJHW4FUpbcCagY
TxTAiAJV3GSBiCA2grWSD4BtN9XI6AdfrgUxAeWAK967vpiVTRo9NYvwV82jo0XO
jQRiERJXAQQA8KwmN+I7VBHTm3CU9oAhW3J6Ed4by6mAawf2rf9fERrOPiVKtc6h
vLFa2pl33mmVXk8C0bVEiiAP+1+QJHYPeztPN98AWGf51jGY4D2JoVtccou1469d
FoDHO+/+peO/Wrt8nvVWjvqCsmS0GQwug9NM78po7vBiWQYBXYVaJfcAEQEAAcKf
BBgBCAATBQJiERJXCRBNNFfMvYMfcwIbDAAAuq0EACbN1SNO8yCSd0lT1nxxYoA+
3x5fbzMhDABOM2gbMBUOWFsxQAEJKCYR6fA6PVZ5RV4PwyXDItkeqvXpNPFXDjo4
hXh+OPtI9VoUQF2cZTPd0sqshpF4h4FWkY6R+Hf2i4NGh/AjkEUlUf+uUHu5kXPK
TxxR3oMX+RLGBeIwCsmS
=iJPh
-----END PGP PUBLIC KEY BLOCK-----
''';
const privateKey = '''
-----BEGIN PGP PRIVATE KEY BLOCK-----
Version: openpgp-mobile

xcFGBGIRElcBBADSZaldU3WL3CkG7TJVvi93DiBU+eWDlTHx9DTIPZdAPK0oyX4q
+UC9uzHGxJNCuIxWtGSzNQ4BZDr8N+anCGd2FTJQRYiHiTKkUFAf6s8hjUuHKjeU
40zyuMzVUo1xfmNERAO9/6/TRnxvL7O8BFjhv0uv3l6Jr3FEOB7YOLjGCwARAQAB
/gcDCOIqx2h9O0HoYF+nCd6JFTiQCf4Tsnfilf+SV4ib+w6oP88A6d0BaJGss+Ui
7pI8tyH4LQ9bCNN+20dDd5AekETJ1JdzqlhR25bN0ZI5N0b1n5jywStGvFmxghJZ
hAvjR+dHP3fclhpIzH+cHAK4qlqf+At3af4DWELE68AvmUDcZcf1v1zUx6OT0f9B
hfpePxtJQwrcvsm2c06Y3Q4yF+A0iYfRii+0c6Vp4T+5Zj6WcPNxU5qr9lWelGMJ
FWNKuaqDdovqeRQWDHTl7nt5oDmNl1AdVyDduQBBPzYr1HXBLlzG4iUzA1Zv/YGk
sEXWYzCVe2IJxc4T1hr/KYNOPVQZxfknBx0ESZ4xlYFX0kg5Gi3LxA0C9Xq1LPLv
BHxvdf+fIyvJhAs9Yl/5xNDxnWl3opvYz+BsZtSzB5LsGs+BDbZLiSyetYSUEb52
+hM9Uu08kV25j5IbqbknM5k4ghxyi7quWZoPOl7a5vDa/NKj7taqUuTNFHRlc3Qg
PHRlc3RAdGVzdC5jb20+wqgEEwEIABwFAmIRElcJEE00V8y9gx9zAhsDAhkBAgsH
AhUIAABmWAQABuX5cBVi0ZDZWdN4T0JELZF5S3Z8GUP7z8G53Mlum4taTUlc7qKG
ISEH8Rich/hxGdQsKp4llxOFS26v5lnkLBsAFTNhC1zJHW4FUpbcCagYTxTAiAJV
3GSBiCA2grWSD4BtN9XI6AdfrgUxAeWAK967vpiVTRo9NYvwV82jo0XHwRgEYhES
VwEEAPCsJjfiO1QR05twlPaAIVtyehHeG8upgGsH9q3/XxEazj4lSrXOobyxWtqZ
d95plV5PAtG1RIogD/tfkCR2D3s7TzffAFhn+dYxmOA9iaFbXHKLteOvXRaAxzvv
/qXjv1q7fJ71Vo76grJktBkMLoPTTO/KaO7wYlkGAV2FWiX3ABEBAAEAA/0RFlfc
Td6ieGWKurKI0c4MfRM3o4pbqlwovTcBYYkxYLLV7LXiNJp9GCZ4ML829k4ZlQiB
NRp5qA8abM2CGTO+C9TJD2NwkMFiqf0qj3M69rM/gdeQEEy4D6/NW28gi7QMi+pg
xqkIxDkP1KYaP5pwdqSBRp4aokt83VhpUGwCwQIA8df4LCBfy7f5kqEys14lmxyT
EqkFhCWLLa7LRu2s6/IlGGqBONjkmKmtvTrGJ5D2U8d6IWlvawi0n741fZazlwIA
/sKhPI7gclYHyiqKIQqdXvcusbcZfG+Whqe0ijq7hZshD+arL6eQ5QVOEIHpjJp3
0QFPamveymQyaSnBtJzsoQIA8/jxCDCDR93oCEZjA9Aybna0Ot6N+ifcdjQQuQoR
LaaU4kKD7GoUKJ/fZk3GpekO9EKCe/dNK6er1C8cHBydP5scwp8EGAEIABMFAmIR
ElcJEE00V8y9gx9zAhsMAAC6rQQAJs3VI07zIJJ3SVPWfHFigD7fHl9vMyEMAE4z
aBswFQ5YWzFAAQkoJhHp8Do9VnlFXg/DJcMi2R6q9ek08VcOOjiFeH44+0j1WhRA
XZxlM93SyqyGkXiHgVaRjpH4d/aLg0aH8COQRSVR/65Qe7mRc8pPHFHegxf5EsYF
4jAKyZI=
=x08A
-----END PGP PRIVATE KEY BLOCK-----
''';

class _MyAppState extends State<MyApp> {
  KeyPair _defaultKeyPair = KeyPair(publicKey, privateKey);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_defaultKeyPair == null) {
      return Container();
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OpenPGP example app'),
        ),
        body: ListView(
          key: Key('list'),
          children: <Widget>[
            EncryptAndDecrypt(
              title: "Encrypt And Decrypt",
              keyPair: _defaultKeyPair,
              key: Key("encrypt-decrypt"),
            ),
            if (false)
              EncryptAndDecryptFile(
                title: "Encrypt And Decrypt file",
                keyPair: _defaultKeyPair,
                key: Key("encrypt-decrypt-file"),
              ),
            EncryptAndDecryptBytes(
              title: "Encrypt And Decrypt Bytes",
              keyPair: _defaultKeyPair,
              key: Key("encrypt-decrypt-bytes"),
            ),
            EncryptAndDecryptSymmetric(
              title: "Encrypt And Decrypt Symmetric",
              keyPair: _defaultKeyPair,
              key: Key("encrypt-decrypt-symmetric"),
            ),
            EncryptAndDecryptSymmetricBytes(
              title: "Encrypt And Decrypt Symmetric Bytes",
              keyPair: _defaultKeyPair,
              key: Key("encrypt-decrypt-symmetric-bytes"),
            ),
            SignAndVerify(
              title: "Sign And Verify",
              keyPair: _defaultKeyPair,
              key: Key("sign-verify"),
            ),
            SignAndVerifyBytes(
              title: "Sign And Verify Bytes",
              keyPair: _defaultKeyPair,
              key: Key("sign-verify-bytes"),
            ),
            Generate(
              title: "Generate",
              key: Key("generate"),
            ),
          ],
        ),
      ),
    );
  }
}
