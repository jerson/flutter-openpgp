///
//  Generated code. Do not modify.
//  source: bridge.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'bridge.pbenum.dart';

export 'bridge.pbenum.dart';

class EncryptRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('EncryptRequest',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOS(1, 'message')
    ..aOS(3, 'publicKey', protoName: 'publicKey')
    ..hasRequiredFields = false;

  EncryptRequest._() : super();
  factory EncryptRequest() => create();
  factory EncryptRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory EncryptRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  EncryptRequest clone() => EncryptRequest()..mergeFromMessage(this);
  EncryptRequest copyWith(void Function(EncryptRequest) updates) =>
      super.copyWith((message) => updates(message as EncryptRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EncryptRequest create() => EncryptRequest._();
  EncryptRequest createEmptyInstance() => create();
  static $pb.PbList<EncryptRequest> createRepeated() =>
      $pb.PbList<EncryptRequest>();
  @$core.pragma('dart2js:noInline')
  static EncryptRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EncryptRequest>(create);
  static EncryptRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get publicKey => $_getSZ(1);
  @$pb.TagNumber(3)
  set publicKey($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(3)
  void clearPublicKey() => clearField(3);
}

class EncryptBytesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('EncryptBytesRequest',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'message', $pb.PbFieldType.OY)
    ..aOS(3, 'publicKey', protoName: 'publicKey')
    ..hasRequiredFields = false;

  EncryptBytesRequest._() : super();
  factory EncryptBytesRequest() => create();
  factory EncryptBytesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory EncryptBytesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  EncryptBytesRequest clone() => EncryptBytesRequest()..mergeFromMessage(this);
  EncryptBytesRequest copyWith(void Function(EncryptBytesRequest) updates) =>
      super.copyWith((message) => updates(message as EncryptBytesRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EncryptBytesRequest create() => EncryptBytesRequest._();
  EncryptBytesRequest createEmptyInstance() => create();
  static $pb.PbList<EncryptBytesRequest> createRepeated() =>
      $pb.PbList<EncryptBytesRequest>();
  @$core.pragma('dart2js:noInline')
  static EncryptBytesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EncryptBytesRequest>(create);
  static EncryptBytesRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get message => $_getN(0);
  @$pb.TagNumber(1)
  set message($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get publicKey => $_getSZ(1);
  @$pb.TagNumber(3)
  set publicKey($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(3)
  void clearPublicKey() => clearField(3);
}

class DecryptRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DecryptRequest',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOS(1, 'message')
    ..aOS(3, 'privateKey', protoName: 'privateKey')
    ..aOS(5, 'passphrase')
    ..hasRequiredFields = false;

  DecryptRequest._() : super();
  factory DecryptRequest() => create();
  factory DecryptRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DecryptRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  DecryptRequest clone() => DecryptRequest()..mergeFromMessage(this);
  DecryptRequest copyWith(void Function(DecryptRequest) updates) =>
      super.copyWith((message) => updates(message as DecryptRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DecryptRequest create() => DecryptRequest._();
  DecryptRequest createEmptyInstance() => create();
  static $pb.PbList<DecryptRequest> createRepeated() =>
      $pb.PbList<DecryptRequest>();
  @$core.pragma('dart2js:noInline')
  static DecryptRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecryptRequest>(create);
  static DecryptRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get privateKey => $_getSZ(1);
  @$pb.TagNumber(3)
  set privateKey($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPrivateKey() => $_has(1);
  @$pb.TagNumber(3)
  void clearPrivateKey() => clearField(3);

  @$pb.TagNumber(5)
  $core.String get passphrase => $_getSZ(2);
  @$pb.TagNumber(5)
  set passphrase($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPassphrase() => $_has(2);
  @$pb.TagNumber(5)
  void clearPassphrase() => clearField(5);
}

class DecryptBytesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DecryptBytesRequest',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'message', $pb.PbFieldType.OY)
    ..aOS(3, 'privateKey', protoName: 'privateKey')
    ..aOS(5, 'passphrase')
    ..hasRequiredFields = false;

  DecryptBytesRequest._() : super();
  factory DecryptBytesRequest() => create();
  factory DecryptBytesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DecryptBytesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  DecryptBytesRequest clone() => DecryptBytesRequest()..mergeFromMessage(this);
  DecryptBytesRequest copyWith(void Function(DecryptBytesRequest) updates) =>
      super.copyWith((message) => updates(message as DecryptBytesRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DecryptBytesRequest create() => DecryptBytesRequest._();
  DecryptBytesRequest createEmptyInstance() => create();
  static $pb.PbList<DecryptBytesRequest> createRepeated() =>
      $pb.PbList<DecryptBytesRequest>();
  @$core.pragma('dart2js:noInline')
  static DecryptBytesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecryptBytesRequest>(create);
  static DecryptBytesRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get message => $_getN(0);
  @$pb.TagNumber(1)
  set message($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get privateKey => $_getSZ(1);
  @$pb.TagNumber(3)
  set privateKey($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPrivateKey() => $_has(1);
  @$pb.TagNumber(3)
  void clearPrivateKey() => clearField(3);

  @$pb.TagNumber(5)
  $core.String get passphrase => $_getSZ(2);
  @$pb.TagNumber(5)
  set passphrase($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPassphrase() => $_has(2);
  @$pb.TagNumber(5)
  void clearPassphrase() => clearField(5);
}

class SignRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SignRequest',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOS(1, 'message')
    ..aOS(3, 'publicKey', protoName: 'publicKey')
    ..aOS(5, 'privateKey', protoName: 'privateKey')
    ..aOS(7, 'passphrase')
    ..hasRequiredFields = false;

  SignRequest._() : super();
  factory SignRequest() => create();
  factory SignRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SignRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  SignRequest clone() => SignRequest()..mergeFromMessage(this);
  SignRequest copyWith(void Function(SignRequest) updates) =>
      super.copyWith((message) => updates(message as SignRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SignRequest create() => SignRequest._();
  SignRequest createEmptyInstance() => create();
  static $pb.PbList<SignRequest> createRepeated() => $pb.PbList<SignRequest>();
  @$core.pragma('dart2js:noInline')
  static SignRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignRequest>(create);
  static SignRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get publicKey => $_getSZ(1);
  @$pb.TagNumber(3)
  set publicKey($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(3)
  void clearPublicKey() => clearField(3);

  @$pb.TagNumber(5)
  $core.String get privateKey => $_getSZ(2);
  @$pb.TagNumber(5)
  set privateKey($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPrivateKey() => $_has(2);
  @$pb.TagNumber(5)
  void clearPrivateKey() => clearField(5);

  @$pb.TagNumber(7)
  $core.String get passphrase => $_getSZ(3);
  @$pb.TagNumber(7)
  set passphrase($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasPassphrase() => $_has(3);
  @$pb.TagNumber(7)
  void clearPassphrase() => clearField(7);
}

class SignBytesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SignBytesRequest',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'message', $pb.PbFieldType.OY)
    ..aOS(3, 'publicKey', protoName: 'publicKey')
    ..aOS(5, 'privateKey', protoName: 'privateKey')
    ..aOS(7, 'passphrase')
    ..hasRequiredFields = false;

  SignBytesRequest._() : super();
  factory SignBytesRequest() => create();
  factory SignBytesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SignBytesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  SignBytesRequest clone() => SignBytesRequest()..mergeFromMessage(this);
  SignBytesRequest copyWith(void Function(SignBytesRequest) updates) =>
      super.copyWith((message) => updates(message as SignBytesRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SignBytesRequest create() => SignBytesRequest._();
  SignBytesRequest createEmptyInstance() => create();
  static $pb.PbList<SignBytesRequest> createRepeated() =>
      $pb.PbList<SignBytesRequest>();
  @$core.pragma('dart2js:noInline')
  static SignBytesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignBytesRequest>(create);
  static SignBytesRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get message => $_getN(0);
  @$pb.TagNumber(1)
  set message($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get publicKey => $_getSZ(1);
  @$pb.TagNumber(3)
  set publicKey($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(3)
  void clearPublicKey() => clearField(3);

  @$pb.TagNumber(5)
  $core.String get privateKey => $_getSZ(2);
  @$pb.TagNumber(5)
  set privateKey($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPrivateKey() => $_has(2);
  @$pb.TagNumber(5)
  void clearPrivateKey() => clearField(5);

  @$pb.TagNumber(7)
  $core.String get passphrase => $_getSZ(3);
  @$pb.TagNumber(7)
  set passphrase($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasPassphrase() => $_has(3);
  @$pb.TagNumber(7)
  void clearPassphrase() => clearField(7);
}

class VerifyRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('VerifyRequest',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOS(1, 'signature')
    ..aOS(3, 'message')
    ..aOS(5, 'publicKey', protoName: 'publicKey')
    ..hasRequiredFields = false;

  VerifyRequest._() : super();
  factory VerifyRequest() => create();
  factory VerifyRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory VerifyRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  VerifyRequest clone() => VerifyRequest()..mergeFromMessage(this);
  VerifyRequest copyWith(void Function(VerifyRequest) updates) =>
      super.copyWith((message) => updates(message as VerifyRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VerifyRequest create() => VerifyRequest._();
  VerifyRequest createEmptyInstance() => create();
  static $pb.PbList<VerifyRequest> createRepeated() =>
      $pb.PbList<VerifyRequest>();
  @$core.pragma('dart2js:noInline')
  static VerifyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyRequest>(create);
  static VerifyRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get signature => $_getSZ(0);
  @$pb.TagNumber(1)
  set signature($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSignature() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignature() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(3)
  set message($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(3)
  void clearMessage() => clearField(3);

  @$pb.TagNumber(5)
  $core.String get publicKey => $_getSZ(2);
  @$pb.TagNumber(5)
  set publicKey($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPublicKey() => $_has(2);
  @$pb.TagNumber(5)
  void clearPublicKey() => clearField(5);
}

class VerifyBytesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('VerifyBytesRequest',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOS(1, 'signature')
    ..a<$core.List<$core.int>>(3, 'message', $pb.PbFieldType.OY)
    ..aOS(5, 'publicKey', protoName: 'publicKey')
    ..hasRequiredFields = false;

  VerifyBytesRequest._() : super();
  factory VerifyBytesRequest() => create();
  factory VerifyBytesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory VerifyBytesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  VerifyBytesRequest clone() => VerifyBytesRequest()..mergeFromMessage(this);
  VerifyBytesRequest copyWith(void Function(VerifyBytesRequest) updates) =>
      super.copyWith((message) => updates(message as VerifyBytesRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VerifyBytesRequest create() => VerifyBytesRequest._();
  VerifyBytesRequest createEmptyInstance() => create();
  static $pb.PbList<VerifyBytesRequest> createRepeated() =>
      $pb.PbList<VerifyBytesRequest>();
  @$core.pragma('dart2js:noInline')
  static VerifyBytesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyBytesRequest>(create);
  static VerifyBytesRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get signature => $_getSZ(0);
  @$pb.TagNumber(1)
  set signature($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSignature() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignature() => clearField(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get message => $_getN(1);
  @$pb.TagNumber(3)
  set message($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(3)
  void clearMessage() => clearField(3);

  @$pb.TagNumber(5)
  $core.String get publicKey => $_getSZ(2);
  @$pb.TagNumber(5)
  set publicKey($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasPublicKey() => $_has(2);
  @$pb.TagNumber(5)
  void clearPublicKey() => clearField(5);
}

class EncryptSymmetricRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('EncryptSymmetricRequest',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOS(1, 'message')
    ..aOS(3, 'passphrase')
    ..aOM<KeyOptions>(5, 'options', subBuilder: KeyOptions.create)
    ..hasRequiredFields = false;

  EncryptSymmetricRequest._() : super();
  factory EncryptSymmetricRequest() => create();
  factory EncryptSymmetricRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory EncryptSymmetricRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  EncryptSymmetricRequest clone() =>
      EncryptSymmetricRequest()..mergeFromMessage(this);
  EncryptSymmetricRequest copyWith(
          void Function(EncryptSymmetricRequest) updates) =>
      super.copyWith((message) => updates(message as EncryptSymmetricRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EncryptSymmetricRequest create() => EncryptSymmetricRequest._();
  EncryptSymmetricRequest createEmptyInstance() => create();
  static $pb.PbList<EncryptSymmetricRequest> createRepeated() =>
      $pb.PbList<EncryptSymmetricRequest>();
  @$core.pragma('dart2js:noInline')
  static EncryptSymmetricRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EncryptSymmetricRequest>(create);
  static EncryptSymmetricRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get passphrase => $_getSZ(1);
  @$pb.TagNumber(3)
  set passphrase($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPassphrase() => $_has(1);
  @$pb.TagNumber(3)
  void clearPassphrase() => clearField(3);

  @$pb.TagNumber(5)
  KeyOptions get options => $_getN(2);
  @$pb.TagNumber(5)
  set options(KeyOptions v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasOptions() => $_has(2);
  @$pb.TagNumber(5)
  void clearOptions() => clearField(5);
  @$pb.TagNumber(5)
  KeyOptions ensureOptions() => $_ensure(2);
}

class EncryptSymmetricBytesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      'EncryptSymmetricBytesRequest',
      package: const $pb.PackageName('model'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'message', $pb.PbFieldType.OY)
    ..aOS(3, 'passphrase')
    ..aOM<KeyOptions>(5, 'options', subBuilder: KeyOptions.create)
    ..hasRequiredFields = false;

  EncryptSymmetricBytesRequest._() : super();
  factory EncryptSymmetricBytesRequest() => create();
  factory EncryptSymmetricBytesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory EncryptSymmetricBytesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  EncryptSymmetricBytesRequest clone() =>
      EncryptSymmetricBytesRequest()..mergeFromMessage(this);
  EncryptSymmetricBytesRequest copyWith(
          void Function(EncryptSymmetricBytesRequest) updates) =>
      super.copyWith(
          (message) => updates(message as EncryptSymmetricBytesRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EncryptSymmetricBytesRequest create() =>
      EncryptSymmetricBytesRequest._();
  EncryptSymmetricBytesRequest createEmptyInstance() => create();
  static $pb.PbList<EncryptSymmetricBytesRequest> createRepeated() =>
      $pb.PbList<EncryptSymmetricBytesRequest>();
  @$core.pragma('dart2js:noInline')
  static EncryptSymmetricBytesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EncryptSymmetricBytesRequest>(create);
  static EncryptSymmetricBytesRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get message => $_getN(0);
  @$pb.TagNumber(1)
  set message($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get passphrase => $_getSZ(1);
  @$pb.TagNumber(3)
  set passphrase($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPassphrase() => $_has(1);
  @$pb.TagNumber(3)
  void clearPassphrase() => clearField(3);

  @$pb.TagNumber(5)
  KeyOptions get options => $_getN(2);
  @$pb.TagNumber(5)
  set options(KeyOptions v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasOptions() => $_has(2);
  @$pb.TagNumber(5)
  void clearOptions() => clearField(5);
  @$pb.TagNumber(5)
  KeyOptions ensureOptions() => $_ensure(2);
}

class DecryptSymmetricRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DecryptSymmetricRequest',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOS(1, 'message')
    ..aOS(3, 'passphrase')
    ..aOM<KeyOptions>(5, 'options', subBuilder: KeyOptions.create)
    ..hasRequiredFields = false;

  DecryptSymmetricRequest._() : super();
  factory DecryptSymmetricRequest() => create();
  factory DecryptSymmetricRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DecryptSymmetricRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  DecryptSymmetricRequest clone() =>
      DecryptSymmetricRequest()..mergeFromMessage(this);
  DecryptSymmetricRequest copyWith(
          void Function(DecryptSymmetricRequest) updates) =>
      super.copyWith((message) => updates(message as DecryptSymmetricRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DecryptSymmetricRequest create() => DecryptSymmetricRequest._();
  DecryptSymmetricRequest createEmptyInstance() => create();
  static $pb.PbList<DecryptSymmetricRequest> createRepeated() =>
      $pb.PbList<DecryptSymmetricRequest>();
  @$core.pragma('dart2js:noInline')
  static DecryptSymmetricRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecryptSymmetricRequest>(create);
  static DecryptSymmetricRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get passphrase => $_getSZ(1);
  @$pb.TagNumber(3)
  set passphrase($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPassphrase() => $_has(1);
  @$pb.TagNumber(3)
  void clearPassphrase() => clearField(3);

  @$pb.TagNumber(5)
  KeyOptions get options => $_getN(2);
  @$pb.TagNumber(5)
  set options(KeyOptions v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasOptions() => $_has(2);
  @$pb.TagNumber(5)
  void clearOptions() => clearField(5);
  @$pb.TagNumber(5)
  KeyOptions ensureOptions() => $_ensure(2);
}

class DecryptSymmetricBytesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      'DecryptSymmetricBytesRequest',
      package: const $pb.PackageName('model'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'message', $pb.PbFieldType.OY)
    ..aOS(3, 'passphrase')
    ..aOM<KeyOptions>(5, 'options', subBuilder: KeyOptions.create)
    ..hasRequiredFields = false;

  DecryptSymmetricBytesRequest._() : super();
  factory DecryptSymmetricBytesRequest() => create();
  factory DecryptSymmetricBytesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DecryptSymmetricBytesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  DecryptSymmetricBytesRequest clone() =>
      DecryptSymmetricBytesRequest()..mergeFromMessage(this);
  DecryptSymmetricBytesRequest copyWith(
          void Function(DecryptSymmetricBytesRequest) updates) =>
      super.copyWith(
          (message) => updates(message as DecryptSymmetricBytesRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DecryptSymmetricBytesRequest create() =>
      DecryptSymmetricBytesRequest._();
  DecryptSymmetricBytesRequest createEmptyInstance() => create();
  static $pb.PbList<DecryptSymmetricBytesRequest> createRepeated() =>
      $pb.PbList<DecryptSymmetricBytesRequest>();
  @$core.pragma('dart2js:noInline')
  static DecryptSymmetricBytesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecryptSymmetricBytesRequest>(create);
  static DecryptSymmetricBytesRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get message => $_getN(0);
  @$pb.TagNumber(1)
  set message($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get passphrase => $_getSZ(1);
  @$pb.TagNumber(3)
  set passphrase($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPassphrase() => $_has(1);
  @$pb.TagNumber(3)
  void clearPassphrase() => clearField(3);

  @$pb.TagNumber(5)
  KeyOptions get options => $_getN(2);
  @$pb.TagNumber(5)
  set options(KeyOptions v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasOptions() => $_has(2);
  @$pb.TagNumber(5)
  void clearOptions() => clearField(5);
  @$pb.TagNumber(5)
  KeyOptions ensureOptions() => $_ensure(2);
}

class GenerateRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GenerateRequest',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOM<Options>(5, 'options', subBuilder: Options.create)
    ..hasRequiredFields = false;

  GenerateRequest._() : super();
  factory GenerateRequest() => create();
  factory GenerateRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GenerateRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  GenerateRequest clone() => GenerateRequest()..mergeFromMessage(this);
  GenerateRequest copyWith(void Function(GenerateRequest) updates) =>
      super.copyWith((message) => updates(message as GenerateRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GenerateRequest create() => GenerateRequest._();
  GenerateRequest createEmptyInstance() => create();
  static $pb.PbList<GenerateRequest> createRepeated() =>
      $pb.PbList<GenerateRequest>();
  @$core.pragma('dart2js:noInline')
  static GenerateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenerateRequest>(create);
  static GenerateRequest _defaultInstance;

  @$pb.TagNumber(5)
  Options get options => $_getN(0);
  @$pb.TagNumber(5)
  set options(Options v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasOptions() => $_has(0);
  @$pb.TagNumber(5)
  void clearOptions() => clearField(5);
  @$pb.TagNumber(5)
  Options ensureOptions() => $_ensure(0);
}

class KeyOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('KeyOptions',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..e<Hash>(1, 'hash', $pb.PbFieldType.OE,
        defaultOrMaker: Hash.HASH_UNSPECIFIED,
        valueOf: Hash.valueOf,
        enumValues: Hash.values)
    ..e<Cypher>(3, 'cipher', $pb.PbFieldType.OE,
        defaultOrMaker: Cypher.CYPHER_UNSPECIFIED,
        valueOf: Cypher.valueOf,
        enumValues: Cypher.values)
    ..e<Compression>(5, 'compression', $pb.PbFieldType.OE,
        defaultOrMaker: Compression.COMPRESSION_UNSPECIFIED,
        valueOf: Compression.valueOf,
        enumValues: Compression.values)
    ..a<$core.int>(7, 'compressionLevel', $pb.PbFieldType.O3,
        protoName: 'compressionLevel')
    ..a<$core.int>(9, 'rsaBits', $pb.PbFieldType.O3, protoName: 'rsaBits')
    ..hasRequiredFields = false;

  KeyOptions._() : super();
  factory KeyOptions() => create();
  factory KeyOptions.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory KeyOptions.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  KeyOptions clone() => KeyOptions()..mergeFromMessage(this);
  KeyOptions copyWith(void Function(KeyOptions) updates) =>
      super.copyWith((message) => updates(message as KeyOptions));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static KeyOptions create() => KeyOptions._();
  KeyOptions createEmptyInstance() => create();
  static $pb.PbList<KeyOptions> createRepeated() => $pb.PbList<KeyOptions>();
  @$core.pragma('dart2js:noInline')
  static KeyOptions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeyOptions>(create);
  static KeyOptions _defaultInstance;

  @$pb.TagNumber(1)
  Hash get hash => $_getN(0);
  @$pb.TagNumber(1)
  set hash(Hash v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => clearField(1);

  @$pb.TagNumber(3)
  Cypher get cipher => $_getN(1);
  @$pb.TagNumber(3)
  set cipher(Cypher v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCipher() => $_has(1);
  @$pb.TagNumber(3)
  void clearCipher() => clearField(3);

  @$pb.TagNumber(5)
  Compression get compression => $_getN(2);
  @$pb.TagNumber(5)
  set compression(Compression v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasCompression() => $_has(2);
  @$pb.TagNumber(5)
  void clearCompression() => clearField(5);

  @$pb.TagNumber(7)
  $core.int get compressionLevel => $_getIZ(3);
  @$pb.TagNumber(7)
  set compressionLevel($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasCompressionLevel() => $_has(3);
  @$pb.TagNumber(7)
  void clearCompressionLevel() => clearField(7);

  @$pb.TagNumber(9)
  $core.int get rsaBits => $_getIZ(4);
  @$pb.TagNumber(9)
  set rsaBits($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasRsaBits() => $_has(4);
  @$pb.TagNumber(9)
  void clearRsaBits() => clearField(9);
}

class Options extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Options',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOS(1, 'name')
    ..aOS(3, 'comment')
    ..aOS(5, 'email')
    ..aOS(7, 'passphrase')
    ..aOM<KeyOptions>(9, 'keyOptions',
        protoName: 'keyOptions', subBuilder: KeyOptions.create)
    ..hasRequiredFields = false;

  Options._() : super();
  factory Options() => create();
  factory Options.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Options.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Options clone() => Options()..mergeFromMessage(this);
  Options copyWith(void Function(Options) updates) =>
      super.copyWith((message) => updates(message as Options));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Options create() => Options._();
  Options createEmptyInstance() => create();
  static $pb.PbList<Options> createRepeated() => $pb.PbList<Options>();
  @$core.pragma('dart2js:noInline')
  static Options getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Options>(create);
  static Options _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get comment => $_getSZ(1);
  @$pb.TagNumber(3)
  set comment($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasComment() => $_has(1);
  @$pb.TagNumber(3)
  void clearComment() => clearField(3);

  @$pb.TagNumber(5)
  $core.String get email => $_getSZ(2);
  @$pb.TagNumber(5)
  set email($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasEmail() => $_has(2);
  @$pb.TagNumber(5)
  void clearEmail() => clearField(5);

  @$pb.TagNumber(7)
  $core.String get passphrase => $_getSZ(3);
  @$pb.TagNumber(7)
  set passphrase($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasPassphrase() => $_has(3);
  @$pb.TagNumber(7)
  void clearPassphrase() => clearField(7);

  @$pb.TagNumber(9)
  KeyOptions get keyOptions => $_getN(4);
  @$pb.TagNumber(9)
  set keyOptions(KeyOptions v) {
    setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasKeyOptions() => $_has(4);
  @$pb.TagNumber(9)
  void clearKeyOptions() => clearField(9);
  @$pb.TagNumber(9)
  KeyOptions ensureKeyOptions() => $_ensure(4);
}

class StringResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('StringResponse',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOS(1, 'output')
    ..aOS(3, 'error')
    ..hasRequiredFields = false;

  StringResponse._() : super();
  factory StringResponse() => create();
  factory StringResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory StringResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  StringResponse clone() => StringResponse()..mergeFromMessage(this);
  StringResponse copyWith(void Function(StringResponse) updates) =>
      super.copyWith((message) => updates(message as StringResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StringResponse create() => StringResponse._();
  StringResponse createEmptyInstance() => create();
  static $pb.PbList<StringResponse> createRepeated() =>
      $pb.PbList<StringResponse>();
  @$core.pragma('dart2js:noInline')
  static StringResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StringResponse>(create);
  static StringResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get output => $_getSZ(0);
  @$pb.TagNumber(1)
  set output($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOutput() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutput() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(3)
  set error($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(3)
  void clearError() => clearField(3);
}

class BytesResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('BytesResponse',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'output', $pb.PbFieldType.OY)
    ..aOS(3, 'error')
    ..hasRequiredFields = false;

  BytesResponse._() : super();
  factory BytesResponse() => create();
  factory BytesResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BytesResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  BytesResponse clone() => BytesResponse()..mergeFromMessage(this);
  BytesResponse copyWith(void Function(BytesResponse) updates) =>
      super.copyWith((message) => updates(message as BytesResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BytesResponse create() => BytesResponse._();
  BytesResponse createEmptyInstance() => create();
  static $pb.PbList<BytesResponse> createRepeated() =>
      $pb.PbList<BytesResponse>();
  @$core.pragma('dart2js:noInline')
  static BytesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BytesResponse>(create);
  static BytesResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get output => $_getN(0);
  @$pb.TagNumber(1)
  set output($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOutput() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutput() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(3)
  set error($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(3)
  void clearError() => clearField(3);
}

class BoolResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('BoolResponse',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOB(1, 'output')
    ..aOS(3, 'error')
    ..hasRequiredFields = false;

  BoolResponse._() : super();
  factory BoolResponse() => create();
  factory BoolResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BoolResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  BoolResponse clone() => BoolResponse()..mergeFromMessage(this);
  BoolResponse copyWith(void Function(BoolResponse) updates) =>
      super.copyWith((message) => updates(message as BoolResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BoolResponse create() => BoolResponse._();
  BoolResponse createEmptyInstance() => create();
  static $pb.PbList<BoolResponse> createRepeated() =>
      $pb.PbList<BoolResponse>();
  @$core.pragma('dart2js:noInline')
  static BoolResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BoolResponse>(create);
  static BoolResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get output => $_getBF(0);
  @$pb.TagNumber(1)
  set output($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOutput() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutput() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(3)
  set error($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(3)
  void clearError() => clearField(3);
}

class KeyPairResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('KeyPairResponse',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOM<KeyPair>(1, 'output', subBuilder: KeyPair.create)
    ..aOS(3, 'error')
    ..hasRequiredFields = false;

  KeyPairResponse._() : super();
  factory KeyPairResponse() => create();
  factory KeyPairResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory KeyPairResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  KeyPairResponse clone() => KeyPairResponse()..mergeFromMessage(this);
  KeyPairResponse copyWith(void Function(KeyPairResponse) updates) =>
      super.copyWith((message) => updates(message as KeyPairResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static KeyPairResponse create() => KeyPairResponse._();
  KeyPairResponse createEmptyInstance() => create();
  static $pb.PbList<KeyPairResponse> createRepeated() =>
      $pb.PbList<KeyPairResponse>();
  @$core.pragma('dart2js:noInline')
  static KeyPairResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeyPairResponse>(create);
  static KeyPairResponse _defaultInstance;

  @$pb.TagNumber(1)
  KeyPair get output => $_getN(0);
  @$pb.TagNumber(1)
  set output(KeyPair v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOutput() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutput() => clearField(1);
  @$pb.TagNumber(1)
  KeyPair ensureOutput() => $_ensure(0);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(3)
  set error($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(3)
  void clearError() => clearField(3);
}

class KeyPair extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('KeyPair',
      package: const $pb.PackageName('model'), createEmptyInstance: create)
    ..aOS(1, 'publicKey', protoName: 'publicKey')
    ..aOS(3, 'privateKey', protoName: 'privateKey')
    ..hasRequiredFields = false;

  KeyPair._() : super();
  factory KeyPair() => create();
  factory KeyPair.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory KeyPair.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  KeyPair clone() => KeyPair()..mergeFromMessage(this);
  KeyPair copyWith(void Function(KeyPair) updates) =>
      super.copyWith((message) => updates(message as KeyPair));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static KeyPair create() => KeyPair._();
  KeyPair createEmptyInstance() => create();
  static $pb.PbList<KeyPair> createRepeated() => $pb.PbList<KeyPair>();
  @$core.pragma('dart2js:noInline')
  static KeyPair getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KeyPair>(create);
  static KeyPair _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publicKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set publicKey($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get privateKey => $_getSZ(1);
  @$pb.TagNumber(3)
  set privateKey($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPrivateKey() => $_has(1);
  @$pb.TagNumber(3)
  void clearPrivateKey() => clearField(3);
}
