## 3.9.0
- Updates binaries
- Add XCFramework for ios 

## 3.8.3
- Migrate to package:web

## 3.8.2

- Updated Isolate spawn logic to close gracefully

## 3.8.1

- Updated binaries to v1.10.3
- Fix scenario when decrypt+verify using keys generated in a different tool

## 3.8.0

- Updated binaries to v1.10.1
- Add decrypt+verify and encrypt+sign using signed entity

## 3.7.3

- Add android Namespace

## 3.7.2

- Updated binaries to v1.9.4
- Fixed issue with invalid generated keys


## 3.7.1

- Updated binaries to v1.9.2
- Fixed issue with bad armor encode
- Add ArmorDecode method
  
## 3.7.0

- Add SignData methods for compatibility with other platform implementations
- Updated binaries to v1.9.0


## 3.6.1

- Fixed macOS podspec issue when signing apps 
- Updated binaries to v1.8.2

## 3.6.0

- Updated binaries to v1.8.1
  
## 3.5.4

- Added support to linux ARM64 devices

## 3.5.3

- Removed Hover support

## 3.5.2

- Added unit test support macos, linux and windows

## 3.5.1

- Fixed linux DynamicLibrary detection

## 3.5.0

- Updated binaries to v1.6.0 to support ECC Key generation, see KeyOptions: Algorithm and Curve
  
## 3.4.3

- Updated binaries to v1.5.5 to support mixed go libraries (openpgp and fast-rsa)

## 3.4.2

- Added Identities(email, name, comment) to Metadata Private and Public
- Updated binaries to 1.5.4

## 3.4.1

- Updated binaries to 1.5.2
  
## 3.4.0

- Updated ffi to 2.0 and min sdk version to 2.17.0

## 3.3.0

- Added new methods: armorEncode, convertPrivateKeyToPublicKey, getPrivateKeyMetadata, getPublicKeyMetadata

## 3.2.8

- Added fallback option when instantiateStreaming is not available

## 3.2.7

- Updated binaries to 1.3.4

## 3.2.6

- Updated binaries to 1.3.3

## 3.2.5

- Updated binaries to 1.3.2
 
## 3.2.4

- Updated binaries to 1.3.1
  
## 3.2.3

- Added false_secrets to pubspec

## 3.2.2

- Updated hover deps
  
## 3.2.1
- Updated binaries to 1.3.0 using flatbuffers 2.0

## 3.2.0

- Updated example and android requirements

## 3.1.1

- Updated BUILD_BUNDLE_DIR for linux, using relative dir

## 3.1.0

- Updated core library for openpgp

## 3.0.1

- Fixed path import with spaces in cocoapods for ios
## 3.0.0

- First version with flatbuffers, smaller binaries, please take a look
## 2.0.1

- Support import .so for older android versions, thanks to @BobanLW

## 2.0.0-nullsafety.0

- bump version to stable null_safety

## 1.2.0-nullsafety.5

- macOS now use dylib instead of .a 

## 1.2.0-nullsafety.4

- Updated FFI to latest and removed deprecated methods

## 1.2.0-nullsafety.3

- Format only

## 1.2.0-nullsafety.2

- Using stable version

## 1.2.0-nullsafety.1

- First version with initial support working

## 1.1.5

- macOS now use dylib instead of .a 

## 1.1.4

- Added OpenPGPException to `openpgp.dart`

## 1.1.3

- Added OpenPGPException

## 1.1.2

- Tests CI and github actions for drive

## 1.1.1

- Fixed web messenger

## 1.1.0

- Added wasm + web worker support

## 1.0.0

- just creating this version to replace old version

## 1.0.0-rc2

- Added more options for encrypt and decrypt, including FileHints in order to encrypt files as binary
- Fixed error in generate method that was returning invalid publicKey, sorry for that :/
- Fixed typo on Cipher was Cypher before

## 1.0.0-rc1

- Replaced GoMobile with binding for mostly platforms, now should be more easier add new methods and support platforms
- Platforms supported right now: macOS, iOS, Android, Hover, Windows and Linux
- Platforms partial supported: Web (need web workers)

## 0.9.9

- Updated onAttachedToEngine now using getBinaryMessenger

## 0.9.8

- Added integration tests

## 0.9.7

- bytes method for macos, web and hover

## 0.9.6

- fixed definition in dart

## 0.9.4

- more bytes methods to android and ios

## 0.9.3

- encrypt and decrypt bytes support, thanks @delaosa 

## 0.9.2

- Multikeys support for android and ios

## 0.9.1

- Fixed web support

## 0.9.0

- macOS support

## 0.8.5

- Linux support

## 0.8.2

- Better implementation registerWith for android, thanks to @irasekh3

## 0.8.1

- Implemented registerWith for android

## 0.8.0

- Web support

## 0.7.0

- Single instance for ios

## 0.6.0

- Now run on background on ios

## 0.5.0

- Now run on background on android

## 0.4.0

- Updated binary packages

## 0.3.0

- Fixed ios include

## 0.2.0

- Updated description

## 0.1.0

- Fixed ios support

## 0.0.1

- Initial release
