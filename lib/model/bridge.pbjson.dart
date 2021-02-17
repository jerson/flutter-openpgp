///
//  Generated code. Do not modify.
//  source: bridge.proto
//

// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const Hash$json = const {
  '1': 'Hash',
  '2': const [
    const {'1': 'HASH_UNSPECIFIED', '2': 0},
    const {'1': 'HASH_SHA256', '2': 1},
    const {'1': 'HASH_SHA224', '2': 2},
    const {'1': 'HASH_SHA384', '2': 3},
    const {'1': 'HASH_SHA512', '2': 4},
  ],
};

const Compression$json = const {
  '1': 'Compression',
  '2': const [
    const {'1': 'COMPRESSION_UNSPECIFIED', '2': 0},
    const {'1': 'COMPRESSION_NONE', '2': 1},
    const {'1': 'COMPRESSION_ZLIB', '2': 2},
    const {'1': 'COMPRESSION_ZIP', '2': 3},
  ],
};

const Cipher$json = const {
  '1': 'Cipher',
  '2': const [
    const {'1': 'CIPHER_UNSPECIFIED', '2': 0},
    const {'1': 'CIPHER_AES128', '2': 1},
    const {'1': 'CIPHER_AES192', '2': 2},
    const {'1': 'CIPHER_AES256', '2': 3},
  ],
};

const EncryptRequest$json = const {
  '1': 'EncryptRequest',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'publicKey', '3': 3, '4': 1, '5': 9, '10': 'publicKey'},
    const {
      '1': 'options',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.model.KeyOptions',
      '10': 'options'
    },
    const {
      '1': 'signed',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.model.Entity',
      '10': 'signed'
    },
    const {
      '1': 'fileHints',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.model.FileHints',
      '10': 'fileHints'
    },
  ],
};

const EncryptBytesRequest$json = const {
  '1': 'EncryptBytesRequest',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 12, '10': 'message'},
    const {'1': 'publicKey', '3': 3, '4': 1, '5': 9, '10': 'publicKey'},
    const {
      '1': 'options',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.model.KeyOptions',
      '10': 'options'
    },
    const {
      '1': 'signed',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.model.Entity',
      '10': 'signed'
    },
    const {
      '1': 'fileHints',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.model.FileHints',
      '10': 'fileHints'
    },
  ],
};

const DecryptRequest$json = const {
  '1': 'DecryptRequest',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'privateKey', '3': 3, '4': 1, '5': 9, '10': 'privateKey'},
    const {'1': 'passphrase', '3': 5, '4': 1, '5': 9, '10': 'passphrase'},
    const {
      '1': 'options',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.model.KeyOptions',
      '10': 'options'
    },
  ],
};

const DecryptBytesRequest$json = const {
  '1': 'DecryptBytesRequest',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 12, '10': 'message'},
    const {'1': 'privateKey', '3': 3, '4': 1, '5': 9, '10': 'privateKey'},
    const {'1': 'passphrase', '3': 5, '4': 1, '5': 9, '10': 'passphrase'},
    const {
      '1': 'options',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.model.KeyOptions',
      '10': 'options'
    },
  ],
};

const SignRequest$json = const {
  '1': 'SignRequest',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'publicKey', '3': 3, '4': 1, '5': 9, '10': 'publicKey'},
    const {'1': 'privateKey', '3': 5, '4': 1, '5': 9, '10': 'privateKey'},
    const {'1': 'passphrase', '3': 7, '4': 1, '5': 9, '10': 'passphrase'},
    const {
      '1': 'options',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.model.KeyOptions',
      '10': 'options'
    },
  ],
};

const SignBytesRequest$json = const {
  '1': 'SignBytesRequest',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 12, '10': 'message'},
    const {'1': 'publicKey', '3': 3, '4': 1, '5': 9, '10': 'publicKey'},
    const {'1': 'privateKey', '3': 5, '4': 1, '5': 9, '10': 'privateKey'},
    const {'1': 'passphrase', '3': 7, '4': 1, '5': 9, '10': 'passphrase'},
    const {
      '1': 'options',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.model.KeyOptions',
      '10': 'options'
    },
  ],
};

const VerifyRequest$json = const {
  '1': 'VerifyRequest',
  '2': const [
    const {'1': 'signature', '3': 1, '4': 1, '5': 9, '10': 'signature'},
    const {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'publicKey', '3': 5, '4': 1, '5': 9, '10': 'publicKey'},
  ],
};

const VerifyBytesRequest$json = const {
  '1': 'VerifyBytesRequest',
  '2': const [
    const {'1': 'signature', '3': 1, '4': 1, '5': 9, '10': 'signature'},
    const {'1': 'message', '3': 3, '4': 1, '5': 12, '10': 'message'},
    const {'1': 'publicKey', '3': 5, '4': 1, '5': 9, '10': 'publicKey'},
  ],
};

const EncryptSymmetricRequest$json = const {
  '1': 'EncryptSymmetricRequest',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'passphrase', '3': 3, '4': 1, '5': 9, '10': 'passphrase'},
    const {
      '1': 'options',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.model.KeyOptions',
      '10': 'options'
    },
    const {
      '1': 'fileHints',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.model.FileHints',
      '10': 'fileHints'
    },
  ],
};

const EncryptSymmetricBytesRequest$json = const {
  '1': 'EncryptSymmetricBytesRequest',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 12, '10': 'message'},
    const {'1': 'passphrase', '3': 3, '4': 1, '5': 9, '10': 'passphrase'},
    const {
      '1': 'options',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.model.KeyOptions',
      '10': 'options'
    },
    const {
      '1': 'fileHints',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.model.FileHints',
      '10': 'fileHints'
    },
  ],
};

const DecryptSymmetricRequest$json = const {
  '1': 'DecryptSymmetricRequest',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'passphrase', '3': 3, '4': 1, '5': 9, '10': 'passphrase'},
    const {
      '1': 'options',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.model.KeyOptions',
      '10': 'options'
    },
  ],
};

const DecryptSymmetricBytesRequest$json = const {
  '1': 'DecryptSymmetricBytesRequest',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 12, '10': 'message'},
    const {'1': 'passphrase', '3': 3, '4': 1, '5': 9, '10': 'passphrase'},
    const {
      '1': 'options',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.model.KeyOptions',
      '10': 'options'
    },
  ],
};

const GenerateRequest$json = const {
  '1': 'GenerateRequest',
  '2': const [
    const {
      '1': 'options',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.model.Options',
      '10': 'options'
    },
  ],
};

const KeyOptions$json = const {
  '1': 'KeyOptions',
  '2': const [
    const {
      '1': 'hash',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.model.Hash',
      '10': 'hash'
    },
    const {
      '1': 'cipher',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.model.Cipher',
      '10': 'cipher'
    },
    const {
      '1': 'compression',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.model.Compression',
      '10': 'compression'
    },
    const {
      '1': 'compressionLevel',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'compressionLevel'
    },
    const {'1': 'rsaBits', '3': 9, '4': 1, '5': 5, '10': 'rsaBits'},
  ],
};

const Options$json = const {
  '1': 'Options',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'comment', '3': 3, '4': 1, '5': 9, '10': 'comment'},
    const {'1': 'email', '3': 5, '4': 1, '5': 9, '10': 'email'},
    const {'1': 'passphrase', '3': 7, '4': 1, '5': 9, '10': 'passphrase'},
    const {
      '1': 'keyOptions',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.model.KeyOptions',
      '10': 'keyOptions'
    },
  ],
};

const FileHints$json = const {
  '1': 'FileHints',
  '2': const [
    const {'1': 'isBinary', '3': 1, '4': 1, '5': 8, '10': 'isBinary'},
    const {'1': 'fileName', '3': 3, '4': 1, '5': 9, '10': 'fileName'},
    const {'1': 'modTime', '3': 5, '4': 1, '5': 9, '10': 'modTime'},
  ],
};

const Entity$json = const {
  '1': 'Entity',
  '2': const [
    const {'1': 'publicKey', '3': 1, '4': 1, '5': 9, '10': 'publicKey'},
    const {'1': 'privateKey', '3': 3, '4': 1, '5': 9, '10': 'privateKey'},
    const {'1': 'passphrase', '3': 5, '4': 1, '5': 9, '10': 'passphrase'},
  ],
};

const StringResponse$json = const {
  '1': 'StringResponse',
  '2': const [
    const {'1': 'output', '3': 1, '4': 1, '5': 9, '10': 'output'},
    const {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

const BytesResponse$json = const {
  '1': 'BytesResponse',
  '2': const [
    const {'1': 'output', '3': 1, '4': 1, '5': 12, '10': 'output'},
    const {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

const BoolResponse$json = const {
  '1': 'BoolResponse',
  '2': const [
    const {'1': 'output', '3': 1, '4': 1, '5': 8, '10': 'output'},
    const {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

const KeyPairResponse$json = const {
  '1': 'KeyPairResponse',
  '2': const [
    const {
      '1': 'output',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.model.KeyPair',
      '10': 'output'
    },
    const {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

const KeyPair$json = const {
  '1': 'KeyPair',
  '2': const [
    const {'1': 'publicKey', '3': 1, '4': 1, '5': 9, '10': 'publicKey'},
    const {'1': 'privateKey', '3': 3, '4': 1, '5': 9, '10': 'privateKey'},
  ],
};

const PublicKeyMetadata$json = const {
  '1': 'PublicKeyMetadata',
  '2': const [
    const {'1': 'keyID', '3': 1, '4': 1, '5': 9, '10': 'keyID'},
    const {'1': 'keyIDShort', '3': 3, '4': 1, '5': 9, '10': 'keyIDShort'},
    const {'1': 'creationTime', '3': 5, '4': 1, '5': 9, '10': 'creationTime'},
    const {'1': 'fingerprint', '3': 7, '4': 1, '5': 9, '10': 'fingerprint'},
    const {'1': 'keyIDNumeric', '3': 9, '4': 1, '5': 9, '10': 'keyIDNumeric'},
    const {'1': 'isSubKey', '3': 11, '4': 1, '5': 8, '10': 'isSubKey'},
  ],
};

const PrivateKeyMetadata$json = const {
  '1': 'PrivateKeyMetadata',
  '2': const [
    const {'1': 'keyID', '3': 1, '4': 1, '5': 9, '10': 'keyID'},
    const {'1': 'keyIDShort', '3': 3, '4': 1, '5': 9, '10': 'keyIDShort'},
    const {'1': 'creationTime', '3': 5, '4': 1, '5': 9, '10': 'creationTime'},
    const {'1': 'fingerprint', '3': 7, '4': 1, '5': 9, '10': 'fingerprint'},
    const {'1': 'keyIDNumeric', '3': 9, '4': 1, '5': 9, '10': 'keyIDNumeric'},
    const {'1': 'isSubKey', '3': 11, '4': 1, '5': 8, '10': 'isSubKey'},
    const {'1': 'encrypted', '3': 13, '4': 1, '5': 8, '10': 'encrypted'},
  ],
};
