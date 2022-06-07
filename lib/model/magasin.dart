
import 'address.dart';

class Magasin {
  int? id;
  int? etablissementId;
  int? partenaireId;
  int? moduleId;
  dynamic? heureFermeture;
  String? tags;
  String? slug;
  String? image;
  Distancematrix? distancematrix;
  Adresse? adresse;
  Contact? contact;
  dynamic? adresses;
  List<dynamic>? produits;
  Etablissement? etablissement;
  List<dynamic>? gerants;
  List<dynamic>? availableInCities;
  int? isAvailable;
  String? nom;
  bool? isOpen;
  Horaires? horaires;
  String? mapStaticUrl;
  List<dynamic>? extra;

  Magasin({this.id, this.etablissementId, this.partenaireId, this.moduleId, this.heureFermeture, this.tags, this.slug, this.image, this.distancematrix, this.adresse, this.contact, this.adresses, this.produits, this.etablissement, this.gerants, this.availableInCities, this.isAvailable, this.nom, this.isOpen, this.horaires, this.mapStaticUrl, this.extra});

  Magasin.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.etablissementId = json["etablissement_id"];
    this.partenaireId = json["partenaire_id"];
    this.moduleId = json["module_id"];
    this.heureFermeture = json["heure_fermeture"];
    this.tags = json["tags"];
    this.slug = json["slug"];
    this.image = json["image"];
    this.distancematrix = json["distancematrix"] == null ? null : Distancematrix.fromJson(json["distancematrix"]);
    this.adresse = json["adresse"] == null ? null : Adresse.fromJson(json["adresse"]);
    this.contact = json["contact"] == null ? null : Contact.fromJson(json["contact"]);
    this.adresses = json["adresses"];
    this.produits = json["produits"] ?? [];
    this.etablissement = json["etablissement"] == null ? null : Etablissement.fromJson(json["etablissement"]);
    this.gerants = json["gerants"] ?? [];
    this.availableInCities = json["available_in_cities"] ?? [];
    this.isAvailable = json["is_available"];
    this.nom = json["nom"];
    this.isOpen = json["is_open"];
    this.horaires = json["horaires"] == null ? null : Horaires.fromJson(json["horaires"]);
    this.mapStaticUrl = json["map_static_url"];
    this.extra = json["extra"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["etablissement_id"] = this.etablissementId;
    data["partenaire_id"] = this.partenaireId;
    data["module_id"] = this.moduleId;
    data["heure_fermeture"] = this.heureFermeture;
    data["tags"] = this.tags;
    data["slug"] = this.slug;
    data["image"] = this.image;
    if(this.distancematrix != null)
      data["distancematrix"] = this.distancematrix?.toJson();
    if(this.adresse != null)
      data["adresse"] = this.adresse?.toJson();
    if(this.contact != null)
      data["contact"] = this.contact?.toJson();
    data["adresses"] = this.adresses;
    if(this.produits != null)
      data["produits"] = this.produits;
    if(this.etablissement != null)
      data["etablissement"] = this.etablissement?.toJson();
    if(this.gerants != null)
      data["gerants"] = this.gerants;
    if(this.availableInCities != null)
      data["available_in_cities"] = this.availableInCities;
    data["is_available"] = this.isAvailable;
    data["nom"] = this.nom;
    data["is_open"] = this.isOpen;
    if(this.horaires != null)
      data["horaires"] = this.horaires?.toJson();
    data["map_static_url"] = this.mapStaticUrl;
    if(this.extra != null)
      data["extra"] = this.extra;
    return data;
  }
}

class Horaires {
  List<Items>? items;
  Today? today;
  Tomorrow? tomorrow;
  int? dayOfWeek;
  int? tomorrowDayOfWeek;
  String? readme;

  Horaires({this.items, this.today, this.tomorrow, this.dayOfWeek, this.tomorrowDayOfWeek, this.readme});

  Horaires.fromJson(Map<String, dynamic> json) {
    this.items = json["items"]==null ? null : (json["items"] as List).map((e)=>Items.fromJson(e)).toList();
    this.today = json["today"] == null ? null : Today.fromJson(json["today"]);
    this.tomorrow = json["tomorrow"] == null ? null : Tomorrow.fromJson(json["tomorrow"]);
    this.dayOfWeek = json["dayOfWeek"];
    this.tomorrowDayOfWeek = json["tomorrowDayOfWeek"];
    this.readme = json["readme"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.items != null)
      data["items"] = this.items?.map((e)=>e.toJson()).toList();
    if(this.today != null)
      data["today"] = this.today?.toJson();
    if(this.tomorrow != null)
      data["tomorrow"] = this.tomorrow?.toJson();
    data["dayOfWeek"] = this.dayOfWeek;
    data["tomorrowDayOfWeek"] = this.tomorrowDayOfWeek;
    data["readme"] = this.readme;
    return data;
  }
}

class Tomorrow {
  List<DayItem>? items;
  bool? opened;
  bool? enabled;

  Tomorrow({this.items, this.opened, this.enabled});

  Tomorrow.fromJson(Map<String, dynamic> json) {
    items = json["items"]==null ? null : (json["items"] as List).map((e)=>DayItem.fromJson(e)).toList();
    opened = json["opened"];
    enabled = json["enabled"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(items != null) {
      data["items"] = items?.map((e)=>e.toJson()).toList();
    }
    data["opened"] = this.opened;
    data["enabled"] = this.enabled;
    return data;
  }
}

class Items3 {
  bool? enabled;
  bool? opened;
  String? openedAt;
  String? closedAt;

  Items3({this.enabled, this.opened, this.openedAt, this.closedAt});

  Items3.fromJson(Map<String, dynamic> json) {
    this.enabled = json["enabled"];
    this.opened = json["opened"];
    this.openedAt = json["opened_at"];
    this.closedAt = json["closed_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["enabled"] = this.enabled;
    data["opened"] = this.opened;
    data["opened_at"] = this.openedAt;
    data["closed_at"] = this.closedAt;
    return data;
  }
}

class Today {
  List<DayItem>? items;
  bool? opened;
  bool? enabled;

  Today({this.items, this.opened, this.enabled});

  Today.fromJson(Map<String, dynamic> json) {
    this.items = json["items"]==null ? null : (json["items"] as List).map((e)=>DayItem.fromJson(e)).toList();
    this.opened = json["opened"];
    this.enabled = json["enabled"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.items != null)
      data["items"] = this.items?.map((e)=>e.toJson()).toList();
    data["opened"] = this.opened;
    data["enabled"] = this.enabled;
    return data;
  }
}

class DayItem {
  bool? enabled;
  bool? opened;
  String? openedAt;
  String? closedAt;

  DayItem({this.enabled, this.opened, this.openedAt, this.closedAt});

  DayItem.fromJson(Map<String, dynamic> json) {
    this.enabled = json["enabled"];
    this.opened = json["opened"];
    this.openedAt = json["opened_at"];
    this.closedAt = json["closed_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["enabled"] = this.enabled;
    data["opened"] = this.opened;
    data["opened_at"] = this.openedAt;
    data["closed_at"] = this.closedAt;
    return data;
  }
}

class Items {
  List<Items1>? items;
  bool? opened;
  bool? enabled;

  Items({this.items, this.opened, this.enabled});

  Items.fromJson(Map<String, dynamic> json) {
    this.items = json["items"]==null ? null : (json["items"] as List).map((e)=>Items1.fromJson(e)).toList();
    this.opened = json["opened"];
    this.enabled = json["enabled"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.items != null)
      data["items"] = this.items?.map((e)=>e.toJson()).toList();
    data["opened"] = this.opened;
    data["enabled"] = this.enabled;
    return data;
  }
}

class Items1 {
  bool? enabled;
  bool? opened;
  String? openedAt;
  String? closedAt;

  Items1({this.enabled, this.opened, this.openedAt, this.closedAt});

  Items1.fromJson(Map<String, dynamic> json) {
    this.enabled = json["enabled"];
    this.opened = json["opened"];
    this.openedAt = json["opened_at"];
    this.closedAt = json["closed_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["enabled"] = this.enabled;
    data["opened"] = this.opened;
    data["opened_at"] = this.openedAt;
    data["closed_at"] = this.closedAt;
    return data;
  }
}

class Etablissement {
  int? id;
  String? nom;
  int? isActive;
  dynamic? image;

  Etablissement({this.id, this.nom, this.isActive, this.image});

  Etablissement.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.nom = json["nom"];
    this.isActive = json["is_active"];
    this.image = json["image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["nom"] = this.nom;
    data["is_active"] = this.isActive;
    data["image"] = this.image;
    return data;
  }
}

class Contact {
  int? id;
  String? holderId;
  String? creatorId;
  String? updaterId;
  dynamic? adresseFavoriteId;
  String? uuid;
  String? username;
  dynamic? avatar;
  String? fullname;
  dynamic? firstname;
  dynamic? lastname;
  String? email;
  String? emailVerifiedAt;
  dynamic? phoneVerifiedAt;
  String? telephone;
  dynamic? telephoneAlt;
  String? genre;
  String? providerId;
  String? providerName;
  dynamic? langue;
  dynamic? description;
  dynamic? modules;
  dynamic? token;
  dynamic? fcmToken;
  dynamic? nbreCoursesDistribuable;
  dynamic? cautionIncrementationCoursesDistribuable;
  int? statut;
  bool? isGuest;
  int? type;
  String? createdAt;
  String? updatedAt;
  dynamic? deletedAt;
  dynamic? lastLoginAt;
  dynamic? lastLoginIp;
  dynamic? stripeId;
  dynamic? cardBrand;
  dynamic? cardLastFour;
  dynamic? trialEndsAt;

  Contact({this.id, this.holderId, this.creatorId, this.updaterId, this.adresseFavoriteId, this.uuid, this.username, this.avatar, this.fullname, this.firstname, this.lastname, this.email, this.emailVerifiedAt, this.phoneVerifiedAt, this.telephone, this.telephoneAlt, this.genre, this.providerId, this.providerName, this.langue, this.description, this.modules, this.token, this.fcmToken, this.nbreCoursesDistribuable, this.cautionIncrementationCoursesDistribuable, this.statut, this.isGuest, this.type, this.createdAt, this.updatedAt, this.deletedAt, this.lastLoginAt, this.lastLoginIp, this.stripeId, this.cardBrand, this.cardLastFour, this.trialEndsAt});

  Contact.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.holderId = json["holder_id"];
    this.creatorId = json["creator_id"];
    this.updaterId = json["updater_id"];
    this.adresseFavoriteId = json["adresse_favorite_id"];
    this.uuid = json["uuid"];
    this.username = json["username"];
    this.avatar = json["avatar"];
    this.fullname = json["fullname"];
    this.firstname = json["firstname"];
    this.lastname = json["lastname"];
    this.email = json["email"];
    this.emailVerifiedAt = json["email_verified_at"];
    this.phoneVerifiedAt = json["phone_verified_at"];
    telephone = json["telephone"];
    telephoneAlt = json["telephone_alt"];
    this.genre = json["genre"];
    this.providerId = json["provider_id"];
    this.providerName = json["provider_name"];
    this.langue = json["langue"];
    this.description = json["description"];
    this.modules = json["modules"];
    this.token = json["token"];
    this.fcmToken = json["fcm_token"];
    this.nbreCoursesDistribuable = json["nbre_courses_distribuable"];
    this.cautionIncrementationCoursesDistribuable = json["caution_incrementation_courses_distribuable"];
    this.statut = json["statut"];
    this.isGuest = json["is_guest"];
    this.type = json["type"];
    this.createdAt = json["created_at"];
    this.updatedAt = json["updated_at"];
    this.deletedAt = json["deleted_at"];
    this.lastLoginAt = json["last_login_at"];
    this.lastLoginIp = json["last_login_ip"];
    this.stripeId = json["stripe_id"];
    this.cardBrand = json["card_brand"];
    this.cardLastFour = json["card_last_four"];
    this.trialEndsAt = json["trial_ends_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["holder_id"] = this.holderId;
    data["creator_id"] = this.creatorId;
    data["updater_id"] = this.updaterId;
    data["adresse_favorite_id"] = this.adresseFavoriteId;
    data["uuid"] = this.uuid;
    data["username"] = this.username;
    data["avatar"] = this.avatar;
    data["fullname"] = this.fullname;
    data["firstname"] = this.firstname;
    data["lastname"] = this.lastname;
    data["email"] = this.email;
    data["email_verified_at"] = this.emailVerifiedAt;
    data["phone_verified_at"] = this.phoneVerifiedAt;
    data["telephone"] = this.telephone;
    data["telephone_alt"] = this.telephoneAlt;
    data["genre"] = this.genre;
    data["provider_id"] = this.providerId;
    data["provider_name"] = this.providerName;
    data["langue"] = this.langue;
    data["description"] = this.description;
    data["modules"] = this.modules;
    data["token"] = this.token;
    data["fcm_token"] = this.fcmToken;
    data["nbre_courses_distribuable"] = this.nbreCoursesDistribuable;
    data["caution_incrementation_courses_distribuable"] = this.cautionIncrementationCoursesDistribuable;
    data["statut"] = this.statut;
    data["is_guest"] = this.isGuest;
    data["type"] = this.type;
    data["created_at"] = this.createdAt;
    data["updated_at"] = this.updatedAt;
    data["deleted_at"] = this.deletedAt;
    data["last_login_at"] = this.lastLoginAt;
    data["last_login_ip"] = this.lastLoginIp;
    data["stripe_id"] = this.stripeId;
    data["card_brand"] = this.cardBrand;
    data["card_last_four"] = this.cardLastFour;
    data["trial_ends_at"] = this.trialEndsAt;
    return data;
  }
}

class Distancematrix {
  String? destination;
  String? origin;
  Values? values;
  String? distanceText;
  int? distance;
  String? durationText;
  int? duration;
  String? status;

  Distancematrix({this.destination, this.origin, this.values, this.distanceText, this.distance, this.durationText, this.duration, this.status});

  Distancematrix.fromJson(Map<String, dynamic> json) {
    this.destination = json["destination"];
    this.origin = json["origin"];
    this.values = json["values"] == null ? null : Values.fromJson(json["values"]);
    this.distanceText = json["distance_text"];
    this.distance = json["distance"];
    this.durationText = json["duration_text"];
    this.duration = json["duration"];
    this.status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["destination"] = this.destination;
    data["origin"] = this.origin;
    if(this.values != null)
      data["values"] = this.values?.toJson();
    data["distance_text"] = this.distanceText;
    data["distance"] = this.distance;
    data["duration_text"] = this.durationText;
    data["duration"] = this.duration;
    data["status"] = this.status;
    return data;
  }
}

class Values {
  Distance? distance;
  Durations? duration;
  String? status;

  Values({this.distance, this.duration, this.status});

  Values.fromJson(Map<String, dynamic> json) {
    this.distance = json["distance"] == null ? null : Distance.fromJson(json["distance"]);
    this.duration = json["duration"] == null ? null : Durations.fromJson(json["duration"]);
    this.status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.distance != null)
      data["distance"] = this.distance?.toJson();
    if(this.duration != null)
      data["duration"] = this.duration?.toJson();
    data["status"] = this.status;
    return data;
  }
}

class Durations {
  String? text;
  int? value;

  Durations({this.text, this.value});

  Durations.fromJson(Map<String, dynamic> json) {
    this.text = json["text"];
    this.value = json["value"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["text"] = this.text;
    data["value"] = this.value;
    return data;
  }
}

class Distance {
  String? text;
  int? value;

  Distance({this.text, this.value});

  Distance.fromJson(Map<String, dynamic> json) {
    this.text = json["text"];
    this.value = json["value"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["text"] = this.text;
    data["value"] = this.value;
    return data;
  }
}