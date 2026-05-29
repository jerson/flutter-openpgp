# OpenPGP

Library for use openPGP with support for android, ios, macos, windows, linux and web, including post-quantum cryptography (ML-DSA / ML-KEM, FIPS 203/204).

[![Integration Tests Android](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_android.yml/badge.svg)](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_android.yml)

[![Integration Tests Linux](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_linux.yml/badge.svg)](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_linux.yml)

[![Integration Tests Windows](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_windows.yml/badge.svg)](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_windows.yml)

[![Integration Tests iOS](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_ios.yml/badge.svg)](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_ios.yml)

[![Integration Tests macOS](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_macos.yml/badge.svg)](https://github.com/jerson/flutter-openpgp/actions/workflows/tests_macos.yml)
## Contents
 
- [OpenPGP](#openpgp)
  - [Contents](#contents)
  - [Post-Quantum Cryptography](#post-quantum-cryptography)
  - [Usage](#usage)
    - [Async methods](#async-methods)
    - [Sync methods](#sync-methods)
  - [Setup](#setup)
    - [Android](#android)
    - [iOS](#ios)
    - [Web](#web)
    - [MacOS](#macos)
    - [Linux](#linux)
    - [Windows](#windows)
    - [Swift Package Manager (iOS \& macOS)](#swift-package-manager-ios--macos)
  - [Example](#example)
  - [Native Code](#native-code)
  - [Upgrade Library](#upgrade-library)
  - [Tests](#tests)

## Post-Quantum Cryptography

This library supports the four composite PQC algorithms introduced in GnuPG 2.5.x, implemented via FIPS 203 (ML-KEM) and FIPS 204 (ML-DSA):

| Algorithm enum | GnuPG name | Description |
|---|---|---|
| `Algorithm.MLDSA65ED25519` | `dil3x25519` | ML-DSA-65 + Ed25519 signing key (OpenPGP v6) |
| `Algorithm.MLDSA87ED448` | `dil5x448` | ML-DSA-87 + Ed448 signing key (OpenPGP v6) |
| `Algorithm.MLKEM768X25519` | `ky768x25519` | ML-KEM-768 + X25519 encryption key |
| `Algorithm.MLKEM1024X448` | `ky1024x448` | ML-KEM-1024 + X448 encryption key (OpenPGP v6) |

ML-DSA keys are signing keys that automatically include a matching ML-KEM encryption subkey. ML-KEM keys are encryption keys that automatically include an Ed25519/Ed448 primary signing key.

```dart
void main() async {
  // Generate a post-quantum signing + encryption key pair
  var keyPair = await OpenPGP.generate(
    options: Options()
      ..name = 'Alice'
      ..email = 'alice@example.com'
      ..passphrase = 'secret'
      ..keyOptions = (KeyOptions()..algorithm = Algorithm.MLDSA65ED25519),
  );

  // Works with all existing encrypt/decrypt/sign/verify operations
  var encrypted = await OpenPGP.encrypt("hello", keyPair.publicKey);
  var decrypted = await OpenPGP.decrypt(encrypted, keyPair.privateKey, "secret");
}
```

## Usage

### Async methods

#### Generate methods
```dart

void main() async {
    // Classic key
    var keyOptions = KeyOptions()..rsaBits = 2048;
    var keyPair = await OpenPGP.generate(
            options: Options()
              ..name = 'test'
              ..email = 'test@test.com'
              ..passphrase = passphrase
              ..keyOptions = keyOptions);

    // Post-quantum key (ML-DSA-65 + Ed25519)
    var pqcKeyPair = await OpenPGP.generate(
            options: Options()
              ..name = 'test'
              ..email = 'test@test.com'
              ..passphrase = passphrase
              ..keyOptions = (KeyOptions()..algorithm = Algorithm.MLDSA65ED25519));
}
```

#### Encrypt methods

```dart

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = await OpenPGP.encrypt("text","[publicKey here]");
    var result = await OpenPGP.encryptSymmetric("text","[passphrase here]");
    var result = await OpenPGP.encryptBytes(bytesSample,"[publicKey here]");
    var result = await OpenPGP.encryptSymmetricBytes(bytesSample,"[passphrase here]");

}

```

#### Decrypt methods

```dart

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = await OpenPGP.decrypt("text encrypted","[privateKey here]","[passphrase here]");
    var result = await OpenPGP.decryptSymmetric("text encrypted","[passphrase here]");
    var result = await OpenPGP.decryptBytes(bytesSample,"[privateKey here]","[passphrase here]");
    var result = await OpenPGP.decryptSymmetricBytes(bytesSample,"[passphrase here]");

}
```

#### Sign methods

```dart

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = await OpenPGP.sign("text","[privateKey here]","[passphrase here]");
    var result = await OpenPGP.signBytesToString(bytesSample,"[privateKey here]","[passphrase here]");
    
    // sign including data
    var result = await OpenPGP.signData("text","[privateKey here]","[passphrase here]");
    var result = await OpenPGP.signDataBytesToString(bytesSample,"[privateKey here]","[passphrase here]");

}

```

#### Verify methods

```dart

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = await OpenPGP.verify("text signed","text","[publicKey here]");
    var result = await OpenPGP.verifyBytes("text signed", bytesSample,"[publicKey here]");
    
    // verify signed with data
    var result = await OpenPGP.verifyData("text signed","[publicKey here]");
    var result = await OpenPGP.verifyDataBytes(bytesSample,"[publicKey here]");

}

```

#### Encode methods

```dart

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = await OpenPGP.armorEncode("PGP MESSAGE", bytesSample);
}

```
#### Decode methods

```dart

void main() async {    
    var result = await OpenPGP.armorDecode("message here");
}

```


#### Metadata methods

```dart

void main() async {
    var result = await OpenPGP.getPrivateKeyMetadata("[privateKey here]");
    var result = await OpenPGP.getPublicKeyMetadata("[publicKey here]");
}

```


#### Convert methods

```dart

void main() async {
    var result = await OpenPGP.convertPrivateKeyToPublicKey("[privateKey here]");
}

```

### Sync methods

#### Generate methods
```dart

void main() {
    var keyOptions = KeyOptions()..rsaBits = 2048;
    var keyPair = OpenPGPSync.generate(
            options: Options()
              ..name = 'test'
              ..email = 'test@test.com'
              ..passphrase = passphrase
              ..keyOptions = keyOptions);
}
```

#### Encrypt methods

```dart

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = OpenPGPSync.encrypt("text","[publicKey here]");
    var result = OpenPGPSync.encryptSymmetric("text","[passphrase here]");
    var result = OpenPGPSync.encryptBytes(bytesSample,"[publicKey here]");
    var result = OpenPGPSync.encryptSymmetricBytes(bytesSample,"[passphrase here]");

}

```

#### Decrypt methods

```dart

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = OpenPGPSync.decrypt("text encrypted","[privateKey here]","[passphrase here]");
    var result = OpenPGPSync.decryptSymmetric("text encrypted","[passphrase here]");
    var result = OpenPGPSync.decryptBytes(bytesSample,"[privateKey here]","[passphrase here]");
    var result = OpenPGPSync.decryptSymmetricBytes(bytesSample,"[passphrase here]");

}
```

#### Sign methods

```dart

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = OpenPGPSync.sign("text","[privateKey here]","[passphrase here]");
    var result = OpenPGPSync.signBytesToString(bytesSample,"[privateKey here]","[passphrase here]");
    
    // sign including data
    var result = OpenPGPSync.signData("text","[privateKey here]","[passphrase here]");
    var result = OpenPGPSync.signDataBytesToString(bytesSample,"[privateKey here]","[passphrase here]");

}

```

#### Verify methods

```dart

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = OpenPGPSync.verify("text signed","text","[publicKey here]");
    var result = OpenPGPSync.verifyBytes("text signed", bytesSample,"[publicKey here]");
    
    // verify signed with data
    var result = OpenPGPSync.verifyData("text signed","[publicKey here]");
    var result = OpenPGPSync.verifyDataBytes(bytesSample,"[publicKey here]");

}

```

#### Encode methods

```dart

void main() async {
    var bytesSample = Uint8List.fromList('data'.codeUnits);
    
    var result = OpenPGPSync.armorEncode("PGP MESSAGE", bytesSample);
}

```
#### Decode methods

```dart

void main() async {    
    var result = OpenPGPSync.armorDecode("message here");
}

```


#### Metadata methods

```dart

void main() async {
    var result = OpenPGPSync.getPrivateKeyMetadata("[privateKey here]");
    var result = OpenPGPSync.getPublicKeyMetadata("[publicKey here]");
}

```


#### Convert methods

```dart

void main() async {
    var result = OpenPGPSync.convertPrivateKeyToPublicKey("[privateKey here]");
}

```

## Setup

### Android

No additional setup required.

### iOS

No additional setup required.

### Web

Add to you `pubspec.yaml`.

```yaml
assets:
    - packages/openpgp/web/assets/worker.js
    - packages/openpgp/web/assets/wasm_exec.js
    - packages/openpgp/web/assets/openpgp.wasm
```

ref: https://github.com/jerson/flutter-openpgp/blob/master/example/pubspec.yaml

### MacOS

No additional setup required.

### Linux

No additional setup required.

### Windows

No additional setup required.

### Swift Package Manager (iOS & macOS)

This plugin ships both CocoaPods podspecs and Swift Package Manager packages, so it
works whether or not your app uses SPM. Swift Package Manager support requires
**Flutter 3.41.0 or higher**.

#### For app developers

No changes are required for the plugin. If you want your app to resolve native
dependencies through SPM instead of CocoaPods, enable it once:

```bash
flutter config --enable-swift-package-manager
```

When SPM is enabled, Flutter consumes this plugin via its `Package.swift` files; when
it is disabled, the existing CocoaPods podspecs are used. Both paths embed the same
prebuilt Go bridge, so encryption, signing and post-quantum operations behave
identically.

#### For plugin contributors

The Swift packages live next to the podspecs and share a single copy of the plugin
source:

```
ios/
  openpgp.podspec
  openpgp/
    Package.swift
    Sources/openpgp/OpenpgpPlugin.swift
    OpenPGPBridge.xcframework          # prebuilt static bridge (fetched by make upgrade)
macos/
  openpgp.podspec
  libopenpgp_bridge.dylib              # prebuilt dynamic bridge (fetched by make upgrade)
  openpgp/
    Package.swift
    Sources/openpgp/OpenpgpPlugin.swift
    OpenPGPBridge.xcframework          # generated from the dylib for SPM (see below)
```

The xcframework must sit *inside* each `openpgp/` package directory (not in the
platform root): Flutter copies the SwiftPM package into an ephemeral `.packages/`
location at build time, so the `binaryTarget` path has to be package-relative.

- **iOS** links the prebuilt static `OpenPGPBridge.xcframework` as a SwiftPM
  `binaryTarget`. Because the Go entry point `OpenPGPBridgeCall` is resolved at
  runtime via `DynamicLibrary.process()`, `OpenpgpPlugin.keepBridgeSymbols()` holds a
  reachable reference to it so the linker does not strip it (the SPM equivalent of the
  podspec's `-force_load`).
- **macOS** ships a dynamic `libopenpgp_bridge.dylib`. SwiftPM cannot embed a loose
  dylib, so it is wrapped into `macos/openpgp/OpenPGPBridge.xcframework` by
  `scripts/build_macos_xcframework.sh`. This step needs Xcode and therefore only runs
  on macOS; `make upgrade` runs it automatically after downloading the dylib. The
  generated xcframework must be committed for SPM users on other platforms to resolve
  the package.

## Example

Inside example folder.

```bash
cd example && flutter run
```

check our web demo: [https://flutter-openpgp.jerson.dev/]

## Native Code

Native library is made in `Go` for faster performance. PQC support is provided by [ProtonMail/go-crypto](https://github.com/ProtonMail/go-crypto) (`v1.4.1-proton`) and [cloudflare/circl](https://github.com/cloudflare/circl) for the ML-DSA/ML-KEM primitives.

[https://github.com/jerson/openpgp-mobile]

## Upgrade Library

You need to run 
```bash
make upgrade
```

## Tests

You need to run 
```bash
make test
```
