

class Address{
   int? id;
   int? villeId;
   int? clientId;
   String? titre;
   String? quarter;
   String? description;
   String? nom;
   String? surnom;
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
   String? updatedAt;
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
    this.ville,
    this.clientId,
    this.surnom,
    this.updatedAt
});

   Address.fromJson(Map<String, dynamic> json) {
     id = json["id"];
     villeId = json["ville_id"];
     clientId = json["client_id"];
     latitude = json["latitude"];
     longitude = json["longitude"];
     nom = json["nom"];
     titre = json["titre"];
     surnom = json["surnom"];
     address = json["adresse"];
     description = json["description"];
     quarter = json["quartier"];
     isFavorite = json["est_favorite"];
     creationDate = json["date_creation"];
     modificationDate = json["date_modification"];
     updatedAt = json["updated_at"];
     providerId = json["provider_id"];
     providerName = json["provider_name"];
     latLng = json["lat_lng"];
   }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = <String, dynamic>{};
     data["id"] = id;
     data["ville_id"] = villeId;
     data["client_id"] = clientId;
     data["latitude"] = latitude;
     data["longitude"] = longitude;
     data["nom"] = nom;
     data["titre"] = titre;
     data["surnom"] = surnom;
     data["adresse"] = address;
     data["description"] = description;
     data["quartier"] = quarter;
     data["est_favorite"] = isFavorite;
     data["provider_id"] = providerId;
     data["provider_name"] = providerName;
     data["lat_lng"] = latLng;
     data["updated_at"] = updatedAt;
     return data;
   }
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
    data["id"] = id;
    data["client_id"] = clientId;
    data["ville_id"] = villeId;
    data["creator_id"] = creatorId;
    data["updater_id"] = updaterId;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["nom"] = nom;
    data["surnom"] = surnom;
    data["description"] = description;
    data["photo_id"] = photoId;
    data["photo_url"] = photoUrl;
    data["quartier"] = quartier;
    data["quartier_id"] = quartierId;
    data["est_favorite"] = estFavorite;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["deleted_at"] = deletedAt;
    data["provider_id"] = providerId;
    data["provider_name"] = providerName;
    data["map_static_url"] = mapStaticUrl;
    data["update_allowed"] = updateAllowed;
    data["lat_lng"] = latLng;
    return data;
  }
}