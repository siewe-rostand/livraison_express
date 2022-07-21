
import 'address-favorite.dart';
import 'address.dart';
import 'client.dart';
import 'distance_matrix.dart';

class Magasin {
  int? id;
  int? etablissementId;
  int? partenaireId;
  int? moduleId;
  dynamic? heureFermeture;
  String? tags;
  String? slug;
  String? image;
  DistanceMatrix? distancematrix;
  Adresse? adresse;
  AddressFavorite? adresseFavorite;
  Client? contact;
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
    id = json["id"];
    etablissementId = json["etablissement_id"];
    partenaireId = json["partenaire_id"];
    moduleId = json["module_id"];
    heureFermeture = json["heure_fermeture"];
    tags = json["tags"];
    slug = json["slug"];
    image = json["image"];
    distancematrix = json["distancematrix"] == null ? null : DistanceMatrix.fromJson(json["distancematrix"]);
    adresse = json["adresse"] == null ? null : Adresse.fromJson(json["adresse"]);
    adresseFavorite = json["adresse"] == null ? null : AddressFavorite.fromJson(json["adresse"]);
    contact = json["contact"] == null ? null : Client.fromJson(json["contact"]);
    adresses = json["adresses"];
    produits = json["produits"] ?? [];
    etablissement = json["etablissement"] == null ? null : Etablissement.fromJson(json["etablissement"]);
    gerants = json["gerants"] ?? [];
    availableInCities = json["available_in_cities"] ?? [];
    isAvailable = json["is_available"];
    nom = json["nom"];
    isOpen = json["is_open"];
    horaires = json["horaires"] == null ? null : Horaires.fromJson(json["horaires"]);
    mapStaticUrl = json["map_static_url"];
    extra = json["extra"] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["etablissement_id"] = etablissementId;
    data["partenaire_id"] = partenaireId;
    data["module_id"] = moduleId;
    data["heure_fermeture"] = heureFermeture;
    data["tags"] = tags;
    data["slug"] = slug;
    data["image"] = image;
    if(distancematrix != null) {
      data["distancematrix"] = distancematrix?.toJson();
    }
    if(adresse != null) {
      data["adresse"] = adresse?.toJson();
    }
    if(contact != null) {
      data["contact"] = contact?.toJson();
    }
    data["adresses"] = adresses;
    if(produits != null) {
      data["produits"] = produits;
    }
    if(etablissement != null) {
      data["etablissement"] = etablissement?.toJson();
    }
    if(gerants != null) {
      data["gerants"] = gerants;
    }
    if(availableInCities != null) {
      data["available_in_cities"] = availableInCities;
    }
    data["is_available"] = isAvailable;
    data["nom"] = nom;
    data["is_open"] = isOpen;
    if(horaires != null) {
      data["horaires"] = horaires?.toJson();
    }
    data["map_static_url"] = mapStaticUrl;
    if(extra != null) {
      data["extra"] = extra;
    }
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
    items = json["items"]==null ? null : (json["items"] as List).map((e)=>Items.fromJson(e)).toList();
    today = json["today"] == null ? null : Today.fromJson(json["today"]);
    tomorrow = json["tomorrow"] == null ? null : Tomorrow.fromJson(json["tomorrow"]);
    dayOfWeek = json["dayOfWeek"];
    tomorrowDayOfWeek = json["tomorrowDayOfWeek"];
    readme = json["readme"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(items != null) {
      data["items"] = items?.map((e)=>e.toJson()).toList();
    }
    if(today != null) {
      data["today"] = today?.toJson();
    }
    if(tomorrow != null) {
      data["tomorrow"] = tomorrow?.toJson();
    }
    data["dayOfWeek"] = dayOfWeek;
    data["tomorrowDayOfWeek"] = tomorrowDayOfWeek;
    data["readme"] = readme;
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
    data["opened"] = opened;
    data["enabled"] = enabled;
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
    enabled = json["enabled"];
    opened = json["opened"];
    openedAt = json["opened_at"];
    closedAt = json["closed_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["enabled"] = enabled;
    data["opened"] = opened;
    data["opened_at"] = openedAt;
    data["closed_at"] = closedAt;
    return data;
  }
}

class Today {
  List<DayItem>? items;
  bool? opened;
  bool? enabled;

  Today({this.items, this.opened, this.enabled});

  Today.fromJson(Map<String, dynamic> json) {
    items = json["items"]==null ? null : (json["items"] as List).map((e)=>DayItem.fromJson(e)).toList();
    opened = json["opened"];
    enabled = json["enabled"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(items != null) {
      data["items"] = items?.map((e)=>e.toJson()).toList();
    }
    data["opened"] = opened;
    data["enabled"] = enabled;
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
    enabled = json["enabled"];
    opened = json["opened"];
    openedAt = json["opened_at"];
    closedAt = json["closed_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["enabled"] = enabled;
    data["opened"] = opened;
    data["opened_at"] = openedAt;
    data["closed_at"] = closedAt;
    return data;
  }
}

class Items {
  List<Items1>? items;
  bool? opened;
  bool? enabled;

  Items({this.items, this.opened, this.enabled});

  Items.fromJson(Map<String, dynamic> json) {
    items = json["items"]==null ? null : (json["items"] as List).map((e)=>Items1.fromJson(e)).toList();
    opened = json["opened"];
    enabled = json["enabled"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(items != null) {
      data["items"] = items?.map((e)=>e.toJson()).toList();
    }
    data["opened"] = opened;
    data["enabled"] = enabled;
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
    enabled = json["enabled"];
    opened = json["opened"];
    openedAt = json["opened_at"];
    closedAt = json["closed_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["enabled"] = enabled;
    data["opened"] = opened;
    data["opened_at"] = openedAt;
    data["closed_at"] = closedAt;
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
    id = json["id"];
    nom = json["nom"];
    isActive = json["is_active"];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["nom"] = nom;
    data["is_active"] = isActive;
    data["image"] = image;
    return data;
  }
}

