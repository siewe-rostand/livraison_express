class Info{
  int? id;
  int? status;
  String? ref;
  String? origin;
  String? platform;
  String? dateChargement;
  String? dateLivraison;
  String? heureLivraison;
  String? jourLivraison;
  String? villeLivraison;
  String? statusHuman;
  String? type;
  String? distance;
  String? distanceText;
  int? duration;
  String? durationText;
  String? contenue;
  String? dateCreation;

  Info({this.id,this.origin,this.status,this.ref,this.contenue,this.dateChargement,this.dateCreation,
  this.dateLivraison,this.distance,this.distanceText,this.duration,this.durationText,this.heureLivraison,
  this.jourLivraison,this.platform,this.statusHuman,this.type,this.villeLivraison});

  Info.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    status = json["status"];
    origin = json["origin"];
    platform = json["platform"];
    dateChargement = json["date_chargement"];
    dateLivraison = json["date_livraison"];
    heureLivraison = json["heure_livraison"];
    jourLivraison = json["jour_livraison"];
    villeLivraison = json["ville_livraison"] ;
    statusHuman = json["status_human"] ;
    type = json["type"];
    distance = json["distance"];
    distanceText = json["distance_text"] ?? [];
    duration = json["duration"];
    durationText = json["duration_text"] ?? [];
    contenue = json["contenu"] ?? [];
    dateCreation = json["date_creation"];
    ref = json["order_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["order_id"] = ref;
    data["status"] = status;
    data["type"] = type;
    data["status_human"] = statusHuman;
    data["origin"] = origin;
    data["platform"] = platform;
    data["date_chargement"] = dateChargement;
    data["date_livraison"] = dateLivraison;
    data["heure_livraison"] = heureLivraison;
    data["jour_livraison"] = jourLivraison;
    data["ville_livraison"] = villeLivraison;
    data["distance"] = distance;
    data["distance_text"] = distanceText;
    data["duration"] = duration;
    data["duration_text"] = durationText;
    data["contenu"] = contenue;
    data["date_creation"] = dateCreation;
    return data;
  }
}