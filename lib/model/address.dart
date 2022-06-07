import 'package:json_annotation/json_annotation.dart';
import 'package:livraison_express/constant/some-constant.dart';

part 'address.g.dart';

class Address{
   int? id;
   int? villeId;
   String? titre;
   String? quarter;
   String? description;
   String? nom;
   String? address;
   String? latitude;
   String? longitude;
   String? latLng;
   String? ville;
   String? pays;
   int? providerId;
  String? providerName;
   String? creationDate;
   String? modificationDate;
   bool? isFavorite;

  Address({
    this.id,this.villeId,
    this.providerName,
    this.longitude,
    this.latitude,
    this.description,
    this.providerId,
    this.quarter,
    this.address,
    this.creationDate,
    this.isFavorite,
    this.latLng,
    this.modificationDate,
    this.nom,
    this.pays,
    this.titre,
    this.ville
});

   Address.fromJson(Map<String, dynamic> json) {
     id = json["id"];
     villeId = json["ville_id"];
     latitude = json["latitude"];
     longitude = json["longitude"];
     nom = json["nom"];
     description = json["description"];
     quarter = json["quartier"];
     isFavorite = json["est_favorite"];
     creationDate = json["date_creation"];
     modificationDate = json["date_modification"];
     providerId = json["provider_id"];
     providerName = json["provider_name"];
     latLng = json["lat_lng"];
   }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = <String, dynamic>{};
     data["id"] = this.id;
     data["ville_id"] = this.villeId;
     data["latitude"] = this.latitude;
     data["longitude"] = this.longitude;
     data["nom"] = this.nom;
     data["description"] = this.description;
     data["quartier"] = this.quarter;
     data["est_favorite"] = this.isFavorite;
     data["provider_id"] = this.providerId;
     data["provider_name"] = this.providerName;
     data["lat_lng"] = this.latLng;
     return data;
   }
}
@JsonSerializable(includeIfNull: false)
class Addresses{
  final int? id;
  @JsonKey(name:MagasinConstant.ville_id)
  final int? villeId;
  final String? titre;
  final String? quarter;
  final String? description;
  final String? nom;
  final String? address;
  final String? latitude;
  final String? longitude;
  @JsonKey(name: AddressConstant.longitudeLatitude)
  final String? latLng;
  final String? ville;
  final String? pays;
  @JsonKey(ignore: true)
  final String? providerId;
  @JsonKey(ignore: true)
  final String? providerName;
  final String? creationDate;
  final String? modificationDate;
  final bool? isFavorite;

  Addresses({
    this.id,this.villeId,
    this.providerName,
    this.longitude,
    this.latitude,
    this.description,
    this.providerId,
    this.quarter,
    this.address,
    this.creationDate,
    this.isFavorite,
    this.latLng,
    this.modificationDate,
    this.nom,
    this.pays,
    this.titre,
    this.ville
  });

  factory Addresses.fromJson(Map<String,dynamic> json) =>_$AddressesFromJson(json);
  Map<String, dynamic> toJson()=>_$AddressesToJson(this);
}

class Adresse {
  int? id;
  int? clientId;
  int? villeId;
  String? creatorId;
  String? updaterId;
  String? latitude;
  String? longitude;
  String? nom;
  dynamic? surnom;
  String? description;
  dynamic? photoId;
  dynamic? photoUrl;
  String? quartier;
  dynamic? quartierId;
  bool? estFavorite;
  String? createdAt;
  String? updatedAt;
  dynamic? deletedAt;
  int? providerId;
  String? providerName;
  String? mapStaticUrl;
  bool? updateAllowed;
  String? latLng;

  Adresse({this.id, this.clientId, this.villeId, this.creatorId, this.updaterId, this.latitude, this.longitude, this.nom, this.surnom, this.description, this.photoId, this.photoUrl, this.quartier, this.quartierId, this.estFavorite, this.createdAt, this.updatedAt, this.deletedAt, this.providerId, this.providerName, this.mapStaticUrl, this.updateAllowed, this.latLng});

  Adresse.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    clientId = json["client_id"];
    villeId = json["ville_id"];
    creatorId = json["creator_id"];
    updaterId = json["updater_id"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    nom = json["nom"];
    surnom = json["surnom"];
    description = json["description"];
    photoId = json["photo_id"];
    photoUrl = json["photo_url"];
    quartier = json["quartier"];
    quartierId = json["quartier_id"];
    estFavorite = json["est_favorite"];
    createdAt = json["date_creation"];
    updatedAt = json["date_modification"];
    deletedAt = json["deleted_at"];
    providerId = json["provider_id"];
    providerName = json["provider_name"];
    mapStaticUrl = json["map_static_url"];
    updateAllowed = json["update_allowed"];
    latLng = json["lat_lng"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["client_id"] = this.clientId;
    data["ville_id"] = this.villeId;
    data["creator_id"] = this.creatorId;
    data["updater_id"] = this.updaterId;
    data["latitude"] = this.latitude;
    data["longitude"] = this.longitude;
    data["nom"] = this.nom;
    data["surnom"] = this.surnom;
    data["description"] = this.description;
    data["photo_id"] = this.photoId;
    data["photo_url"] = this.photoUrl;
    data["quartier"] = this.quartier;
    data["quartier_id"] = this.quartierId;
    data["est_favorite"] = this.estFavorite;
    data["created_at"] = this.createdAt;
    data["updated_at"] = this.updatedAt;
    data["deleted_at"] = this.deletedAt;
    data["provider_id"] = this.providerId;
    data["provider_name"] = this.providerName;
    data["map_static_url"] = this.mapStaticUrl;
    data["update_allowed"] = this.updateAllowed;
    data["lat_lng"] = this.latLng;
    return data;
  }
}