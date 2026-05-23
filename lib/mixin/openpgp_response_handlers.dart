import 'dart:typed_data';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp/model/bridge_model_generated.dart' as model;

mixin OpenPGPResponseHandlers {
  static Never _missingOutput(String type) =>
      throw OpenPGPException('Malformed $type response: output is null');

  static Uint8List bytesResponse(Uint8List data) {
    final response = model.BytesResponse(data);
    if (response.error != null && response.error != '') {
      throw OpenPGPException(response.error!);
    }
    final out = response.output;
    if (out == null) _missingOutput('bytes');
    return Uint8List.fromList(out);
  }

  static String stringResponse(Uint8List data) {
    final response = model.StringResponse(data);
    if (response.error != null && response.error != '') {
      throw OpenPGPException(response.error!);
    }
    return response.output ?? '';
  }

  static bool boolResponse(Uint8List data) {
    final response = model.BoolResponse(data);
    if (response.error != null && response.error != '') {
      throw OpenPGPException(response.error!);
    }
    return response.output;
  }

  static PublicKeyMetadata publicKeyMetadataResponse(Uint8List data) {
    final response = model.PublicKeyMetadataResponse(data);
    if (response.error != null && response.error != '') {
      throw OpenPGPException(response.error!);
    }
    final metadata = response.output;
    if (metadata == null) _missingOutput('PublicKeyMetadata');
    return PublicKeyMetadata(
      metadata.algorithm ?? '',
      metadata.keyId ?? '',
      metadata.keyIdShort ?? '',
      metadata.creationTime ?? '',
      metadata.fingerprint ?? '',
      metadata.keyIdNumeric ?? '',
      metadata.isSubKey,
      metadata.canSign,
      metadata.canEncrypt,
      _identities(metadata.identities),
    );
  }

  static PrivateKeyMetadata privateKeyMetadataResponse(Uint8List data) {
    final response = model.PrivateKeyMetadataResponse(data);
    if (response.error != null && response.error != '') {
      throw OpenPGPException(response.error!);
    }
    final metadata = response.output;
    if (metadata == null) _missingOutput('PrivateKeyMetadata');
    return PrivateKeyMetadata(
      metadata.keyId ?? '',
      metadata.keyIdShort ?? '',
      metadata.creationTime ?? '',
      metadata.fingerprint ?? '',
      metadata.keyIdNumeric ?? '',
      metadata.isSubKey,
      metadata.encrypted,
      metadata.canSign,
      _identities(metadata.identities),
    );
  }

  static ArmorMetadata armorDecodeResponse(Uint8List data) {
    final response = model.ArmorDecodeResponse(data);
    if (response.error != null && response.error != '') {
      throw OpenPGPException(response.error!);
    }
    final metadata = response.output;
    if (metadata == null) _missingOutput('ArmorMetadata');
    return ArmorMetadata(
      metadata.type ?? '',
      Uint8List.fromList(metadata.body ?? []),
    );
  }

  static List<Identity> _identities(List<model.Identity>? identities) {
    if (identities == null) return const [];
    return identities
        .map((e) => Identity(e.id ?? '', e.name ?? '', e.comment ?? '', e.email ?? ''))
        .toList();
  }

  static KeyPair keyPairResponse(Uint8List data) {
    final response = model.KeyPairResponse(data);
    if (response.error != null && response.error != '') {
      throw OpenPGPException(response.error!);
    }
    final keyPair = response.output;
    if (keyPair == null) _missingOutput('KeyPair');
    return KeyPair(keyPair.publicKey ?? '', keyPair.privateKey ?? '');
  }
}
