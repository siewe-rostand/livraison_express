
import 'package:livraison_express/model/address.dart';

class Command {
  Infos? infos;
  Client? client;
  Sender? sender;
  Receiver? receiver;
  Magasin? magasin;
  Orders? orders;
  List<dynamic>? attachments;
  Paiement? paiement;
  Extra? extra;

  Command({this.infos, this.client, this.sender, this.receiver, this.magasin, this.orders, this.attachments, this.paiement, this.extra});

  Command.fromJson(Map<String, dynamic> json) {
    infos = json["infos"] == null ? null : Infos.fromJson(json["infos"]);
    client = json["client"] == null ? null : Client.fromJson(json["client"]);
    sender = json["sender"] == null ? null : Sender.fromJson(json["sender"]);
    receiver = json["receiver"] == null ? null : Receiver.fromJson(json["receiver"]);
    magasin = json["magasin"] == null ? null : Magasin.fromJson(json["magasin"]);
    orders = json["orders"] == null ? null : Orders.fromJson(json["orders"]);
    attachments = json["attachments"] ?? [];
    paiement = json["paiement"] == null ? null : Paiement.fromJson(json["paiement"]);
    extra = json["extra"] == null ? null : Extra.fromJson(json["extra"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(infos != null) {
      data["infos"] = infos?.toJson();
    }
    if(client != null) {
      data["client"] = client?.toJson();
    }
    if(sender != null) {
      data["sender"] = sender?.toJson();
    }
    if(receiver != null) {
      data["receiver"] = receiver?.toJson();
    }
    if(magasin != null) {
      data["magasin"] = magasin?.toJson();
    }
    if(orders != null) {
      data["orders"] = orders?.toJson();
    }
    if(attachments != null) {
      data["attachments"] = attachments;
    }
    if(paiement != null) {
      data["paiement"] = paiement?.toJson();
    }
    if(extra != null) {
      data["extra"] = extra?.toJson();
    }
    return data;
  }
}

class Extra {
  MapStaticUrls? mapStaticUrls;
  String? factureDownload;
  String? factureLink;
  String? commandesAchats;
  String? produits;
  String? factureAchatsDownload;
  String? factureAchatsLink;

  Extra({this.mapStaticUrls, this.factureDownload, this.factureLink, this.commandesAchats, this.produits, this.factureAchatsDownload, this.factureAchatsLink});

  Extra.fromJson(Map<String, dynamic> json) {
    mapStaticUrls = json["map_static_urls"] == null ? null : MapStaticUrls.fromJson(json["map_static_urls"]);
    factureDownload = json["facture_download"];
    factureLink = json["facture_link"];
    commandesAchats = json["commandes_achats"];
    produits = json["produits"];
    factureAchatsDownload = json["facture_achats_download"];
    factureAchatsLink = json["facture_achats_link"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(mapStaticUrls != null) {
      data["map_static_urls"] = mapStaticUrls?.toJson();
    }
    data["facture_download"] = factureDownload;
    data["facture_link"] = factureLink;
    data["commandes_achats"] = commandesAchats;
    data["produits"] = produits;
    data["facture_achats_download"] = factureAchatsDownload;
    data["facture_achats_link"] = factureAchatsLink;
    return data;
  }
}

class MapStaticUrls {
  String? chargement;
  String? livraison;

  MapStaticUrls({this.chargement, this.livraison});

  MapStaticUrls.fromJson(Map<String, dynamic> json) {
    chargement = json["chargement"];
    livraison = json["livraison"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["chargement"] = chargement;
    data["livraison"] = livraison;
    return data;
  }
}

class Paiement {
  int? idPaiment;
  int? idPaiement;
  String? modePaiment;
  String? modePaiement;
  dynamic? msisdnPaiement;
  dynamic? datePaiement;
  dynamic? datePaiment;
  int? montantTotal;
  int? montantRecuperation;
  dynamic? operateurPaiement;
  dynamic? statut;
  dynamic? message;
  Cashier? cashier;

  Paiement({this.idPaiment, this.idPaiement, this.modePaiment, this.modePaiement, this.msisdnPaiement, this.datePaiement, this.datePaiment, this.montantTotal, this.montantRecuperation, this.operateurPaiement, this.statut, this.message, this.cashier});

  Paiement.fromJson(Map<String, dynamic> json) {
    idPaiment = json["id_paiment"];
    idPaiement = json["id_paiement"];
    modePaiment = json["mode_paiment"];
    modePaiement = json["mode_paiement"];
    msisdnPaiement = json["msisdn_paiement"];
    datePaiement = json["date_paiement"];
    datePaiment = json["date_paiment"];
    montantTotal = json["montant_total"];
    montantRecuperation = json["montant_recuperation"];
    operateurPaiement = json["operateur_paiement"];
    statut = json["statut"];
    message = json["message"];
    cashier = json["cashier"] == null ? null : Cashier.fromJson(json["cashier"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id_paiment"] = idPaiment;
    data["id_paiement"] = idPaiement;
    data["mode_paiment"] = modePaiment;
    data["mode_paiement"] = modePaiement;
    data["msisdn_paiement"] = msisdnPaiement;
    data["date_paiement"] = datePaiement;
    data["date_paiment"] = datePaiment;
    data["montant_total"] = montantTotal;
    data["montant_recuperation"] = montantRecuperation;
    data["operateur_paiement"] = operateurPaiement;
    data["statut"] = statut;
    data["message"] = message;
    if(cashier != null) {
      data["cashier"] = cashier?.toJson();
    }
    return data;
  }
}

class Cashier {
  dynamic? id;
  String? name;
  dynamic? agent;
  dynamic? comments;

  Cashier({this.id, this.name, this.agent, this.comments});

  Cashier.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    agent = json["agent"];
    comments = json["comments"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["agent"] = agent;
    data["comments"] = comments;
    return data;
  }
}

class Orders {
  int? idLivraison;
  int? idAchat;
  int? moduleId;
  String? module;
  int? magasinId;
  String? magasin;
  int? montantLivraison;
  int? montantRecuperation;
  int? montantExpedition;
  int? montantAchat;
  int? montantTotal;
  dynamic? codePromo;
  String? commentaire;
  String? type;
  String? gratuitePour;
  String? commentaireClient;
  String? description;
  bool? listeArticles;

  Orders({this.idLivraison, this.idAchat, this.moduleId, this.module, this.magasinId, this.magasin, this.montantLivraison, this.montantRecuperation, this.montantExpedition, this.montantAchat, this.montantTotal, this.codePromo, this.commentaire, this.type, this.gratuitePour, this.commentaireClient, this.description, this.listeArticles});

  Orders.fromJson(Map<String, dynamic> json) {
    idLivraison = json["id_livraison"];
    idAchat = json["id_achat"];
    moduleId = json["module_id"];
    module = json["module"];
    magasinId = json["magasin_id"];
    magasin = json["magasin"];
    montantLivraison = json["montant_livraison"];
    montantRecuperation = json["montant_recuperation"];
    montantExpedition = json["montant_expedition"];
    montantAchat = json["montant_achat"];
    montantTotal = json["montant_total"];
    codePromo = json["code_promo"];
    commentaire = json["commentaire"];
    type = json["type"];
    gratuitePour = json["gratuite_pour"];
    commentaireClient = json["commentaire_client"];
    description = json["description"];
    listeArticles = json["liste_articles"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id_livraison"] = idLivraison;
    data["id_achat"] = idAchat;
    data["module_id"] = moduleId;
    data["module"] = module;
    data["magasin_id"] = magasinId;
    data["magasin"] = magasin;
    data["montant_livraison"] = montantLivraison;
    data["montant_recuperation"] = montantRecuperation;
    data["montant_expedition"] = montantExpedition;
    data["montant_achat"] = montantAchat;
    data["montant_total"] = montantTotal;
    data["code_promo"] = codePromo;
    data["commentaire"] = commentaire;
    data["type"] = type;
    data["gratuite_pour"] = gratuitePour;
    data["commentaire_client"] = commentaireClient;
    data["description"] = description;
    data["liste_articles"] = listeArticles;
    return data;
  }
}

class Magasin {
  int? id;
  String? nom;
  int? partenaireId;
  String? image;
  String? description;
  dynamic? nbreCoursesDistribuable;
  dynamic? cautionIncrementationCoursesDistribuable;

  Magasin({this.id, this.nom, this.partenaireId, this.image, this.description, this.nbreCoursesDistribuable, this.cautionIncrementationCoursesDistribuable});

  Magasin.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    nom = json["nom"];
    partenaireId = json["partenaire_id"];
    image = json["image"];
    description = json["description"];
    nbreCoursesDistribuable = json["nbre_courses_distribuable"];
    cautionIncrementationCoursesDistribuable = json["caution_incrementation_courses_distribuable"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["nom"] = nom;
    data["partenaire_id"] = partenaireId;
    data["image"] = image;
    data["description"] = description;
    data["nbre_courses_distribuable"] = nbreCoursesDistribuable;
    data["caution_incrementation_courses_distribuable"] = cautionIncrementationCoursesDistribuable;
    return data;
  }
}

class Receiver {
  int? id;
  String? providerId;
  String? providerName;
  String? fullname;
  String? username;
  String? email;
  String? telephone;
  dynamic? telephoneAlt;
  dynamic? noteInterne;
  String? dateCreation;
  String? dateModification;
  dynamic? dateSuppression;
  dynamic? nbreCoursesDistribuable;
  dynamic? cautionIncrementationCoursesDistribuable;
  List<Adresses1>? adresses;

  Receiver({this.id, this.providerId, this.providerName, this.fullname, this.username, this.email, this.telephone, this.telephoneAlt, this.noteInterne, this.dateCreation, this.dateModification, this.dateSuppression, this.nbreCoursesDistribuable, this.cautionIncrementationCoursesDistribuable, this.adresses});

  Receiver.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    providerId = json["provider_id"];
    providerName = json["provider_name"];
    fullname = json["fullname"];
    username = json["username"];
    email = json["email"];
    telephone = json["telephone"];
    telephoneAlt = json["telephone_alt"];
    noteInterne = json["note_interne"];
    dateCreation = json["date_creation"];
    dateModification = json["date_modification"];
    dateSuppression = json["date_suppression"];
    nbreCoursesDistribuable = json["nbre_courses_distribuable"];
    cautionIncrementationCoursesDistribuable = json["caution_incrementation_courses_distribuable"];
    adresses = json["adresses"]==null ? null : (json["adresses"] as List).map((e)=>Adresses1.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["provider_id"] = providerId;
    data["provider_name"] = providerName;
    data["fullname"] = fullname;
    data["username"] = username;
    data["email"] = email;
    data["telephone"] = telephone;
    data["telephone_alt"] = telephoneAlt;
    data["note_interne"] = noteInterne;
    data["date_creation"] = dateCreation;
    data["date_modification"] = dateModification;
    data["date_suppression"] = dateSuppression;
    data["nbre_courses_distribuable"] = nbreCoursesDistribuable;
    data["caution_incrementation_courses_distribuable"] = cautionIncrementationCoursesDistribuable;
    if(adresses != null) {
      data["adresses"] = adresses?.map((e)=>e.toJson()).toList();
    }
    return data;
  }
}

class Adresses1 {
  int? id;
  int? providerId;
  String? providerName;
  String? titre;
  String? adresse;
  String? quartier;
  dynamic? quartierId;
  String? zone;
  int? zoneId;
  String? ville;
  dynamic? villeId;
  dynamic? pays;
  bool? estFavorite;
  String? description;
  String? latitude;
  String? longitude;
  String? latitudeLongitude;
  String? dateCreation;
  String? dateModification;
  dynamic? dateSuppression;

  Adresses1({this.id, this.providerId, this.providerName, this.titre, this.adresse, this.quartier, this.quartierId, this.zone, this.zoneId, this.ville, this.villeId, this.pays, this.estFavorite, this.description, this.latitude, this.longitude, this.latitudeLongitude, this.dateCreation, this.dateModification, this.dateSuppression});

  Adresses1.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    providerId = json["provider_id"];
    providerName = json["provider_name"];
    titre = json["titre"];
    adresse = json["adresse"];
    quartier = json["quartier"];
    quartierId = json["quartier_id"];
    zone = json["zone"];
    zoneId = json["zone_id"];
    ville = json["ville"];
    villeId = json["ville_id"];
    pays = json["pays"];
    estFavorite = json["est_favorite"];
    description = json["description"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    latitudeLongitude = json["latitude_longitude"];
    dateCreation = json["date_creation"];
    dateModification = json["date_modification"];
    dateSuppression = json["date_suppression"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["provider_id"] = providerId;
    data["provider_name"] = providerName;
    data["titre"] = titre;
    data["adresse"] = adresse;
    data["quartier"] = quartier;
    data["quartier_id"] = quartierId;
    data["zone"] = zone;
    data["zone_id"] = zoneId;
    data["ville"] = ville;
    data["ville_id"] = villeId;
    data["pays"] = pays;
    data["est_favorite"] = estFavorite;
    data["description"] = description;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["latitude_longitude"] = latitudeLongitude;
    data["date_creation"] = dateCreation;
    data["date_modification"] = dateModification;
    data["date_suppression"] = dateSuppression;
    return data;
  }
}

class Sender {
  int? id;
  String? providerId;
  String? providerName;
  String? fullname;
  String? username;
  String? email;
  String? telephone;
  String? telephoneAlt;
  dynamic? noteInterne;
  String? dateCreation;
  String? dateModification;
  dynamic? dateSuppression;
  dynamic? nbreCoursesDistribuable;
  dynamic? cautionIncrementationCoursesDistribuable;
  List<Address>? adresses;

  Sender({this.id, this.providerId, this.providerName, this.fullname, this.username, this.email, this.telephone, this.telephoneAlt, this.noteInterne, this.dateCreation, this.dateModification, this.dateSuppression, this.nbreCoursesDistribuable, this.cautionIncrementationCoursesDistribuable, this.adresses});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    providerId = json["provider_id"];
    providerName = json["provider_name"];
    fullname = json["fullname"];
    username = json["username"];
    email = json["email"];
    telephone = json["telephone"];
    telephoneAlt = json["telephone_alt"];
    noteInterne = json["note_interne"];
    dateCreation = json["date_creation"];
    dateModification = json["date_modification"];
    dateSuppression = json["date_suppression"];
    nbreCoursesDistribuable = json["nbre_courses_distribuable"];
    cautionIncrementationCoursesDistribuable = json["caution_incrementation_courses_distribuable"];
    adresses = json["adresses"]==null ? null : (json["adresses"] as List).map((e)=>Address.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["provider_id"] = providerId;
    data["provider_name"] = providerName;
    data["fullname"] = fullname;
    data["username"] = username;
    data["email"] = email;
    data["telephone"] = telephone;
    data["telephone_alt"] = telephoneAlt;
    data["note_interne"] = noteInterne;
    data["date_creation"] = dateCreation;
    data["date_modification"] = dateModification;
    data["date_suppression"] = dateSuppression;
    data["nbre_courses_distribuable"] = nbreCoursesDistribuable;
    data["caution_incrementation_courses_distribuable"] = cautionIncrementationCoursesDistribuable;
    if(adresses != null) {
      data["adresses"] = adresses?.map((e)=>e.toJson()).toList();
    }
    return data;
  }
}

class Adresses {
  int? id;
  int? providerId;
  String? providerName;
  dynamic? titre;
  String? adresse;
  String? quartier;
  dynamic? quartierId;
  String? zone;
  int? zoneId;
  String? ville;
  int? villeId;
  dynamic? pays;
  bool? estFavorite;
  String? description;
  String? latitude;
  String? longitude;
  String? latitudeLongitude;
  String? dateCreation;
  String? dateModification;
  dynamic? dateSuppression;

  Adresses({this.id, this.providerId, this.providerName, this.titre, this.adresse, this.quartier, this.quartierId, this.zone, this.zoneId, this.ville, this.villeId, this.pays, this.estFavorite, this.description, this.latitude, this.longitude, this.latitudeLongitude, this.dateCreation, this.dateModification, this.dateSuppression});

  Adresses.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    providerId = json["provider_id"];
    providerName = json["provider_name"];
    titre = json["titre"];
    adresse = json["adresse"];
    quartier = json["quartier"];
    quartierId = json["quartier_id"];
    zone = json["zone"];
    zoneId = json["zone_id"];
    ville = json["ville"];
    villeId = json["ville_id"];
    pays = json["pays"];
    estFavorite = json["est_favorite"];
    description = json["description"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    latitudeLongitude = json["latitude_longitude"];
    dateCreation = json["date_creation"];
    dateModification = json["date_modification"];
    dateSuppression = json["date_suppression"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["provider_id"] = providerId;
    data["provider_name"] = providerName;
    data["titre"] = titre;
    data["adresse"] = adresse;
    data["quartier"] = quartier;
    data["quartier_id"] = quartierId;
    data["zone"] = zone;
    data["zone_id"] = zoneId;
    data["ville"] = ville;
    data["ville_id"] = villeId;
    data["pays"] = pays;
    data["est_favorite"] = estFavorite;
    data["description"] = description;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["latitude_longitude"] = latitudeLongitude;
    data["date_creation"] = dateCreation;
    data["date_modification"] = dateModification;
    data["date_suppression"] = dateSuppression;
    return data;
  }
}

class Client {
  int? id;
  String? providerId;
  String? providerName;
  String? fullname;
  String? username;
  String? email;
  String? telephone;
  String? telephoneAlt;
  dynamic? noteInterne;
  String? dateCreation;
  String? dateModification;
  dynamic? dateSuppression;
  dynamic? nbreCoursesDistribuable;
  dynamic? cautionIncrementationCoursesDistribuable;
  List<dynamic>? adresses;

  Client({this.id, this.providerId, this.providerName, this.fullname, this.username, this.email, this.telephone, this.telephoneAlt, this.noteInterne, this.dateCreation, this.dateModification, this.dateSuppression, this.nbreCoursesDistribuable, this.cautionIncrementationCoursesDistribuable, this.adresses});

  Client.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    providerId = json["provider_id"];
    providerName = json["provider_name"];
    fullname = json["fullname"];
    username = json["username"];
    email = json["email"];
    telephone = json["telephone"];
    telephoneAlt = json["telephone_alt"];
    noteInterne = json["note_interne"];
    dateCreation = json["date_creation"];
    dateModification = json["date_modification"];
    dateSuppression = json["date_suppression"];
    nbreCoursesDistribuable = json["nbre_courses_distribuable"];
    cautionIncrementationCoursesDistribuable = json["caution_incrementation_courses_distribuable"];
    adresses = json["adresses"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["provider_id"] = providerId;
    data["provider_name"] = providerName;
    data["fullname"] = fullname;
    data["username"] = username;
    data["email"] = email;
    data["telephone"] = telephone;
    data["telephone_alt"] = telephoneAlt;
    data["note_interne"] = noteInterne;
    data["date_creation"] = dateCreation;
    data["date_modification"] = dateModification;
    data["date_suppression"] = dateSuppression;
    data["nbre_courses_distribuable"] = nbreCoursesDistribuable;
    data["caution_incrementation_courses_distribuable"] = cautionIncrementationCoursesDistribuable;
    if(adresses != null) {
      data["adresses"] = adresses;
    }
    return data;
  }
}

class Infos {
  int? id;
  String? ref;
  String? dateChargement;
  String? dateLivraison;
  String? heureLivraison;
  String? jourLivraison;
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
  List<dynamic>? coursiersIds;
  dynamic? coursierName;
  dynamic? demarrerCoursier;
  dynamic? chargerCoursier;
  dynamic? terminerCoursier;
  dynamic? terminerClient;
  dynamic? dateAcceptation;
  String? dateCreation;
  String? dateModification;
  dynamic? dateSuppression;

  Infos({this.id, this.ref, this.dateChargement, this.dateLivraison, this.heureLivraison, this.jourLivraison, this.origin, this.originWebsite, this.platform, this.contenu, this.distance, this.distanceText, this.duration, this.durationText, this.statut, this.statutHuman, this.badge, this.isExternal, this.isUrgent, this.isTerminerClient, this.isTerminerCoursier, this.isDemarrerCoursier, this.coursiersIds, this.coursierName, this.demarrerCoursier, this.chargerCoursier, this.terminerCoursier, this.terminerClient, this.dateAcceptation, this.dateCreation, this.dateModification, this.dateSuppression});

  Infos.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    ref = json["ref"];
    dateChargement = json["date_chargement"];
    dateLivraison = json["date_livraison"];
    heureLivraison = json["heure_livraison"];
    jourLivraison = json["jour_livraison"];
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
    coursiersIds = json["coursiers_ids"] ?? [];
    coursierName = json["coursier_name"];
    demarrerCoursier = json["demarrer_coursier"];
    chargerCoursier = json["charger_coursier"];
    terminerCoursier = json["terminer_coursier"];
    terminerClient = json["terminer_client"];
    dateAcceptation = json["date_acceptation"];
    dateCreation = json["date_creation"];
    dateModification = json["date_modification"];
    dateSuppression = json["date_suppression"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["ref"] = ref;
    data["date_chargement"] = dateChargement;
    data["date_livraison"] = dateLivraison;
    data["heure_livraison"] = heureLivraison;
    data["jour_livraison"] = jourLivraison;
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
    if(coursiersIds != null) {
      data["coursiers_ids"] = coursiersIds;
    }
    data["coursier_name"] = coursierName;
    data["demarrer_coursier"] = demarrerCoursier;
    data["charger_coursier"] = chargerCoursier;
    data["terminer_coursier"] = terminerCoursier;
    data["terminer_client"] = terminerClient;
    data["date_acceptation"] = dateAcceptation;
    data["date_creation"] = dateCreation;
    data["date_modification"] = dateModification;
    data["date_suppression"] = dateSuppression;
    return data;
  }
}