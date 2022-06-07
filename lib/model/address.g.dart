// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Addresses _$AddressesFromJson(Map<String, dynamic> json) => Addresses(
      id: json['id'] as int?,
      villeId: json['ville_id'] as int?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
      description: json['description'] as String?,
      quarter: json['quarter'] as String?,
      address: json['address'] as String?,
      creationDate: json['creationDate'] as String?,
      isFavorite: json['isFavorite'] as bool?,
      latLng: json['longitude_latitude'] as String?,
      modificationDate: json['modificationDate'] as String?,
      nom: json['nom'] as String?,
      pays: json['pays'] as String?,
      titre: json['titre'] as String?,
      ville: json['ville'] as String?,
    );

Map<String, dynamic> _$AddressesToJson(Addresses instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('ville_id', instance.villeId);
  writeNotNull('titre', instance.titre);
  writeNotNull('quarter', instance.quarter);
  writeNotNull('description', instance.description);
  writeNotNull('nom', instance.nom);
  writeNotNull('address', instance.address);
  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  writeNotNull('longitude_latitude', instance.latLng);
  writeNotNull('ville', instance.ville);
  writeNotNull('pays', instance.pays);
  writeNotNull('creationDate', instance.creationDate);
  writeNotNull('modificationDate', instance.modificationDate);
  writeNotNull('isFavorite', instance.isFavorite);
  return val;
}
