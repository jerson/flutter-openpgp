///
//  Generated code. Do not modify.
//  source: bridge.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class Hash extends $pb.ProtobufEnum {
  static const Hash HASH_UNSPECIFIED = Hash._(0, 'HASH_UNSPECIFIED');
  static const Hash HASH_SHA256 = Hash._(1, 'HASH_SHA256');
  static const Hash HASH_SHA224 = Hash._(2, 'HASH_SHA224');
  static const Hash HASH_SHA384 = Hash._(3, 'HASH_SHA384');
  static const Hash HASH_SHA512 = Hash._(4, 'HASH_SHA512');

  static const $core.List<Hash> values = <Hash>[
    HASH_UNSPECIFIED,
    HASH_SHA256,
    HASH_SHA224,
    HASH_SHA384,
    HASH_SHA512,
  ];

  static final $core.Map<$core.int, Hash> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static Hash valueOf($core.int value) => _byValue[value];

  const Hash._($core.int v, $core.String n) : super(v, n);
}

class Compression extends $pb.ProtobufEnum {
  static const Compression COMPRESSION_UNSPECIFIED =
      Compression._(0, 'COMPRESSION_UNSPECIFIED');
  static const Compression COMPRESSION_NONE =
      Compression._(1, 'COMPRESSION_NONE');
  static const Compression COMPRESSION_ZLIB =
      Compression._(2, 'COMPRESSION_ZLIB');
  static const Compression COMPRESSION_ZIP =
      Compression._(3, 'COMPRESSION_ZIP');

  static const $core.List<Compression> values = <Compression>[
    COMPRESSION_UNSPECIFIED,
    COMPRESSION_NONE,
    COMPRESSION_ZLIB,
    COMPRESSION_ZIP,
  ];

  static final $core.Map<$core.int, Compression> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static Compression valueOf($core.int value) => _byValue[value];

  const Compression._($core.int v, $core.String n) : super(v, n);
}

class Cipher extends $pb.ProtobufEnum {
  static const Cipher CIPHER_UNSPECIFIED = Cipher._(0, 'CIPHER_UNSPECIFIED');
  static const Cipher CIPHER_AES128 = Cipher._(1, 'CIPHER_AES128');
  static const Cipher CIPHER_AES192 = Cipher._(2, 'CIPHER_AES192');
  static const Cipher CIPHER_AES256 = Cipher._(3, 'CIPHER_AES256');

  static const $core.List<Cipher> values = <Cipher>[
    CIPHER_UNSPECIFIED,
    CIPHER_AES128,
    CIPHER_AES192,
    CIPHER_AES256,
  ];

  static final $core.Map<$core.int, Cipher> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static Cipher valueOf($core.int value) => _byValue[value];

  const Cipher._($core.int v, $core.String n) : super(v, n);
}
