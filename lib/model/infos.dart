
class Infos {
  int? id;
  int? status;
  String? ref;
  String? dateChargement;
  String? dateLivraison;
  String? heureLivraison;
  String? jourLivraison;
  String? villeLivraison;
  String? origin;
  String? originWebsite;
  String? platform;
  String? contenu;
  int? distance;
  String? distanceText;
  int? duration;
  String? durationText;
  int? statut;
  String? statutHuman;
  String? badge;
  bool? isExternal;
  bool? isUrgent;
  bool? isTerminerClient;
  bool? isTerminerCoursier;
  bool? isDemarrerCoursier;
  String? dateCreation;
  String? dateModification;

  Infos(
      {this.id,
        this.ref,
        this.dateChargement,
        this.dateLivraison,
        this.heureLivraison,
        this.jourLivraison,
        this.origin,
        this.originWebsite,
        this.platform,
        this.contenu,
        this.distance,
        this.distanceText,
        this.duration,
        this.durationText,
        this.statut,
        this.statutHuman,
        this.badge,
        this.isExternal,
        this.isUrgent,
        this.isTerminerClient,
        this.isTerminerCoursier,
        this.isDemarrerCoursier,
        this.dateCreation,
        this.dateModification,
        this.status,
        this.villeLivraison
      });

  Infos.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    status = json["status"];
    ref = json["ref"];
    dateChargement = json["date_chargement"];
    dateLivraison = json["date_livraison"];
    heureLivraison = json["heure_livraison"];
    jourLivraison = json["jour_livraison"];
    villeLivraison = json["ville_livraison"];
    origin = json["origin"];
    originWebsite = json["origin_website"];
    platform = json["platform"];
    contenu = json["contenu"];
    distance = json["distance"];
    distanceText = json["distance_text"];
    duration = json["duration"];
    durationText = json["duration_text"];
    statut = json["statut"];
    statutHuman = json["statut_human"];
    badge = json["badge"];
    isExternal = json["is_external"];
    isUrgent = json["is_urgent"];
    isTerminerClient = json["is_terminer_client"];
    isTerminerCoursier = json["is_terminer_coursier"];
    isDemarrerCoursier = json["is_demarrer_coursier"];
    dateCreation = json["date_creation"];
    dateModification = json["date_modification"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["ref"] = ref;
    data["status"] = status;
    data["date_chargement"] = dateChargement;
    data["date_livraison"] = dateLivraison;
    data["heure_livraison"] = heureLivraison;
    data["jour_livraison"] = jourLivraison;
    data["ville_livraison"] = villeLivraison;
    data["origin"] = origin;
    data["origin_website"] = originWebsite;
    data["platform"] = platform;
    data["contenu"] = contenu;
    data["distance"] = distance;
    data["distance_text"] = distanceText;
    data["duration"] = duration;
    data["duration_text"] = durationText;
    data["statut"] = statut;
    data["statut_human"] = statutHuman;
    data["badge"] = badge;
    data["is_external"] = isExternal;
    data["is_urgent"] = isUrgent;
    data["is_terminer_client"] = isTerminerClient;
    data["is_terminer_coursier"] = isTerminerCoursier;
    data["is_demarrer_coursier"] = isDemarrerCoursier;
    data["date_creation"] = dateCreation;
    data["date_modification"] = dateModification;
    return data;
  }
}