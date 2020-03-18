# OpenPGP

Library for use openPGP with support for android, ios, web and hover, more comming

## Usage

```dart
import 'package:openpgp/key_options.dart';
import 'package:openpgp/key_pair.dart';
import 'package:openpgp/openpgp.dart';
import 'package:openpgp/options.dart';

var keyPair = await OpenPGP.generate(
      options: Options(
        name: 'test',
        comment: 'test',
        email: 'test@test.com',
        passphrase: "123456",
        keyOptions: KeyOptions(
            rsaBits: 2048,
            cipher: Cypher.aes128,
            compression: Compression.none,
            hash: Hash.sha256,
            compressionLevel: 0,
        ),
      ),
);


var encrypted = await OpenPGP.encrypt("text","[publicKey here]");

var decrypted = await OpenPGP.decrypt("text encrypted","[privateKey here]","[passphrase here]");

var signed = await OpenPGP.sign("text","[publicKey here]","[privateKey here]","[passphrase here]");

var verified = await OpenPGP.verify("text signed","text","[publicKey here]");

var encryptedSymmetric = await OpenPGP.encryptSymmetric("text","[passphrase here]");

var decryptedSymmetric = await OpenPGP.decryptSymmetric("text encrypted","[passphrase here]");

```


## Android
### ProGuard

Add this lines to `android/app/proguard-rules.pro` for proguard support

```proguard
-keep class go.** { *; }
-keep class openpgp.** { *; }
```
## iOS

no additional setup required

## Web

add to you `pubspec.yaml`

```yaml
  assets:
    - packages/openpgp/web/assets/wasm_exec.js
    - packages/openpgp/web/assets/openpgp.wasm
```
ref: https://github.com/jerson/flutter-openpgp/blob/master/example/pubspec.yaml


and in you `web/index.html`
```html
<script src="assets/packages/openpgp/web/assets/wasm_exec.js" type="application/javascript"></script>
```
ref: https://github.com/jerson/flutter-openpgp/blob/master/example/web/index.html

## Linux (comming soon)

add to you `linux/app_configuration.mk`

```make
EXTRA_LDFLAGS=-lopenpgp
```
ref: https://github.com/jerson/flutter-openpgp/blob/master/example/linux/app_configuration.mk

## MacOS (comming soon)

no additional setup required

## Hover

just update your plugins

```bash
hover plugins get
```


## Native Code

the native library is made in Golang and build with gomobile for faster performance

https://github.com/jerson/openpgp-mobile
