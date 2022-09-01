class AddressFavorite {
  int? id;
  int? clientId;
  int? villeId;
  String? latitude;
  String? longitude;
  String? nom;
  String? surnom;
  String? description;
  String? quartier;
  bool? estFavorite;
  String? createdAt;
  String? updatedAt;
  dynamic? deletedAt;
  int? providerId;
  String? providerName;

  AddressFavorite(
      {this.id,
      this.clientId,
      this.villeId,
      this.latitude,
      this.longitude,
      this.nom,
      this.surnom,
      this.description,
      this.quartier,
      this.estFavorite,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.providerId,
      this.providerName,
      });

  AddressFavorite.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    clientId = json["client_id"];
    villeId = json["ville_id"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    nom = json["nom"];
    surnom = json["surnom"];
    description = json["description"];
    quartier = json["quartier"];
    estFavorite = json["est_favorite"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    deletedAt = json["deleted_at"];
    providerId = json["provider_id"];
    providerName = json["provider_name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["client_id"] = clientId;
    data["ville_id"] = villeId;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["nom"] = nom;
    data["surnom"] = surnom;
    data["description"] = description;
    data["quartier"] = quartier;
    data["est_favorite"] = estFavorite;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["deleted_at"] = deletedAt;
    data["provider_id"] = providerId;
    data["provider_name"] = providerName;
    return data;
  }
}
