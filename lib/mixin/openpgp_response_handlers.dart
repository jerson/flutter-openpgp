import 'dart:typed_data';

import 'package:openpgp/openpgp.dart';
import 'package:openpgp/model/bridge_model_generated.dart' as model;

mixin OpenPGPResponseHandlers {
  static Uint8List bytesResponse(Uint8List data) {
    var response = model.BytesResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    return Uint8List.fromList(response.output!);
  }

  static String stringResponse(Uint8List data) {
    var response = model.StringResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    return response.output!;
  }

  static bool boolResponse(Uint8List data) {
    var response = model.BoolResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    return response.output;
  }

  static PublicKeyMetadata publicKeyMetadataResponse(Uint8List data) {
    var response = model.PublicKeyMetadataResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    var metadata = response.output!;
    return PublicKeyMetadata(
      metadata.algorithm!,
      metadata.keyId!,
      metadata.keyIdShort!,
      metadata.creationTime!,
      metadata.fingerprint!,
      metadata.keyIdNumeric!,
      metadata.isSubKey,
      metadata.canSign,
      metadata.canEncrypt,
      _identities(metadata.identities),
    );
  }

  static PrivateKeyMetadata privateKeyMetadataResponse(Uint8List data) {
    var response = model.PrivateKeyMetadataResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    var metadata = response.output!;
    return PrivateKeyMetadata(
      metadata.keyId!,
      metadata.keyIdShort!,
      metadata.creationTime!,
      metadata.fingerprint!,
      metadata.keyIdNumeric!,
      metadata.isSubKey,
      metadata.encrypted,
      metadata.canSign,
      _identities(metadata.identities),
    );
  }

  static ArmorMetadata armorDecodeResponse(Uint8List data) {
    var response = model.ArmorDecodeResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    var metadata = response.output!;
    return ArmorMetadata(
      metadata.type!,
      Uint8List.fromList(metadata.body!),
    );
  }

  static List<Identity> _identities(List<model.Identity>? identities) {
    List<Identity> list = [];
    if (identities == null) {
      return list;
    }

    for (var element in identities) {
      list.add(Identity(
        element.id!,
        element.name!,
        element.comment!,
        element.email!,
      ));
    }

    return list;
  }

  static KeyPair keyPairResponse(Uint8List data) {
    var response = model.KeyPairResponse(data);
    if (response.error != null && response.error != "") {
      throw OpenPGPException(response.error!);
    }
    var keyPair = response.output!;
    return KeyPair(keyPair.publicKey!, keyPair.privateKey!);
  }
}
