import 'package:livraison_express/model/client.dart';

import 'address-favorite.dart';
import 'day.dart';
import 'horaire.dart';

class Modules {
  int? id;
  String? libelle;
  String? slug;
  int? displayRank;
  Null? information;
  String? heureOuverture;
  String? heureFermeture;
  Null? baseDeliveryMeters;
  Null? baseDeliveryAmountPerStep;
  int? baseDeliveryMetersAsStepUnit;
  Null? freeShippingCartAmount;
  int? isOpen;
  int? isActive;
  int? isAvailable;
  bool? isActiveInCity;
  String? image;
  List<Shops>? shops;
  String? moduleColor;
  List<String>? availableInCities;
  Null? baseDeliveryAmount;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  Extra? extra;

  Modules(
      {this.id,
        this.libelle,
        this.slug,
        this.displayRank,
        this.information,
        this.heureOuverture,
        this.heureFermeture,
        this.baseDeliveryMeters,
        this.baseDeliveryAmountPerStep,
        this.baseDeliveryMetersAsStepUnit,
        this.freeShippingCartAmount,
        this.isOpen,
        this.isActive,
        this.isAvailable,
        this.isActiveInCity,
        this.image,
        this.shops,
        this.moduleColor,
        this.availableInCities,
        this.baseDeliveryAmount,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.extra});

  Modules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    slug = json['slug'];
    displayRank = json['display_rank'];
    information = json['information'];
    heureOuverture = json['heure_ouverture'];
    heureFermeture = json['heure_fermeture'];
    baseDeliveryMeters = json['base_delivery_meters'];
    baseDeliveryAmountPerStep = json['base_delivery_amount_per_step'];
    baseDeliveryMetersAsStepUnit = json['base_delivery_meters_as_step_unit'];
    freeShippingCartAmount = json['free_shipping_cart_amount'];
    isOpen = json['is_open'];
    isActive = json['is_active'];
    isAvailable = json['is_available'];
    isActiveInCity = json['is_active_in_city'];
    image = json['image'];
    if (json['shops'] != null) {
      shops = <Shops>[];
      json['shops'].forEach((v) {
        shops!.add(Shops.fromJson(v));
      });
    }
    moduleColor = json['module_color'];
    availableInCities = json['available_in_cities'].cast<String>();
    baseDeliveryAmount = json['base_delivery_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    extra = json['extra'] != null ? Extra.fromJson(json['extra']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['slug'] = slug;
    data['display_rank'] = displayRank;
    data['information'] = information;
    data['heure_ouverture'] = heureOuverture;
    data['heure_fermeture'] = heureFermeture;
    data['base_delivery_meters'] = baseDeliveryMeters;
    data['base_delivery_amount_per_step'] = baseDeliveryAmountPerStep;
    data['base_delivery_meters_as_step_unit'] =
        baseDeliveryMetersAsStepUnit;
    data['free_shipping_cart_amount'] = freeShippingCartAmount;
    data['is_open'] = isOpen;
    data['is_active'] = isActive;
    data['is_available'] = isAvailable;
    data['is_active_in_city'] = isActiveInCity;
    data['image'] = image;
    if (shops != null) {
      data['shops'] = shops!.map((v) => v.toJson()).toList();
    }
    data['module_color'] = moduleColor;
    data['available_in_cities'] = availableInCities;
    data['base_delivery_amount'] = baseDeliveryAmount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (extra != null) {
      data['extra'] = extra!.toJson();
    }
    return data;
  }
}
class Shops {
  int? id;
  String? creatorId;
  String? updaterId;
  int? etablissementId;
  int? partenaireId;
  int? moduleId;
  String? nom;
  String? slug;
  Client? contact;
  Null? cautionIncrementationCoursesDistribuable;
  int? displayRank;
  String? description;
  int? contactId;
  int? villeId;
  int? adresseId;
  String? image;
  int? isMaster;
  Horaires? horaires;
  String? tags;
  int? isActive;
  int? isAvailable;
  int? baseDeliveryMeters;
  int? baseDeliveryAmount;
  int? baseDeliveryMetersAsStepUnit;
  int? baseDeliveryAmountPerStep;
  Null? freeShippingCartAmount;
  int? shippingPreparationTime;
  int? shippingDurationMaxAcceptMinutes;
  int? shippingDistanceMaxAcceptMeters;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  Adresse? adresse;
  AddressFavorite? adresseFavorite;
  Client? client;

  Shops(
      {this.id,
        this.creatorId,
        this.updaterId,
        this.etablissementId,
        this.partenaireId,
        this.moduleId,
        this.nom,
        this.slug,
        this.cautionIncrementationCoursesDistribuable,
        this.displayRank,
        this.description,
        this.contactId,
        this.villeId,
        this.adresseId,
        this.image,
        this.isMaster,
        this.horaires,
        this.tags,
        this.isActive,
        this.isAvailable,
        this.baseDeliveryMeters,
        this.baseDeliveryAmount,
        this.baseDeliveryMetersAsStepUnit,
        this.baseDeliveryAmountPerStep,
        this.freeShippingCartAmount,
        this.shippingPreparationTime,
        this.shippingDurationMaxAcceptMinutes,
        this.shippingDistanceMaxAcceptMeters,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.adresse,
        this.client,
      this.contact});

  Shops.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorId = json['creator_id'];
    updaterId = json['updater_id'];
    etablissementId = json['etablissement_id'];
    partenaireId = json['partenaire_id'];
    moduleId = json['module_id'];
    nom = json['nom'];
    slug = json['slug'];
    cautionIncrementationCoursesDistribuable =
    json['caution_incrementation_courses_distribuable'];
    displayRank = json['display_rank'];
    description = json['description'];
    contactId = json['contact_id'];
    villeId = json['ville_id'];
    adresseId = json['adresse_id'];
    image = json['image'];
    isMaster = json['is_master'];
    horaires = json['horaires'] != null
        ? Horaires.fromJson(json['horaires'])
        : null;
    tags = json['tags'];
    isActive = json['is_active'];
    isAvailable = json['is_available'];
    baseDeliveryMeters = json['base_delivery_meters'];
    baseDeliveryAmount = json['base_delivery_amount'];
    baseDeliveryMetersAsStepUnit = json['base_delivery_meters_as_step_unit'];
    baseDeliveryAmountPerStep = json['base_delivery_amount_per_step'];
    freeShippingCartAmount = json['free_shipping_cart_amount'];
    shippingPreparationTime = json['shipping_preparation_time'];
    shippingDurationMaxAcceptMinutes =
    json['shipping_duration_max_accept_minutes'];
    shippingDistanceMaxAcceptMeters =
    json['shipping_distance_max_accept_meters'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    adresse =
    json['adresse'] != null ? Adresse.fromJson(json['adresse']) : null;
    adresseFavorite = json["adresse"] == null ? null : AddressFavorite.fromJson(json["adresse"]);
    client =
    json['contact'] != null ? Client.fromJson(json['contact']) : null;
    contact = json["contact"] == null ? null : Client.fromJson(json["contact"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['creator_id'] = creatorId;
    data['updater_id'] = updaterId;
    data['etablissement_id'] = etablissementId;
    data['partenaire_id'] = partenaireId;
    data['module_id'] = moduleId;
    data['nom'] = nom;
    data['slug'] = slug;
    data['caution_incrementation_courses_distribuable'] =
        cautionIncrementationCoursesDistribuable;
    data['display_rank'] = displayRank;
    data['description'] = description;
    data['contact_id'] = contactId;
    data['ville_id'] = villeId;
    data['adresse_id'] = adresseId;
    data['image'] = image;
    data['is_master'] = isMaster;
    if (horaires != null) {
      data['horaires'] = horaires!.toJson();
    }
    data['tags'] = tags;
    data['is_active'] = isActive;
    data['is_available'] = isAvailable;
    data['base_delivery_meters'] = baseDeliveryMeters;
    data['base_delivery_amount'] = baseDeliveryAmount;
    data['base_delivery_meters_as_step_unit'] =
        baseDeliveryMetersAsStepUnit;
    data['base_delivery_amount_per_step'] = baseDeliveryAmountPerStep;
    data['free_shipping_cart_amount'] = freeShippingCartAmount;
    data['shipping_preparation_time'] = shippingPreparationTime;
    data['shipping_duration_max_accept_minutes'] =
        shippingDurationMaxAcceptMinutes;
    data['shipping_distance_max_accept_meters'] =
        shippingDistanceMaxAcceptMeters;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (adresse != null) {
      data['adresse'] = adresse!.toJson();
    }
    if (client != null) {
      data['contact'] = client!.toJson();
    }
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
  String? surnom;
  String? description;
  Null? photoId;
  Null? photoUrl;
  String? quartier;
  int? quartierId;
  bool? estFavorite;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  int? providerId;
  String? providerName;
  String? mapStaticUrl;
  bool? updateAllowed;
  String? latLng;

  Adresse(
      {this.id,
        this.clientId,
        this.villeId,
        this.creatorId,
        this.updaterId,
        this.latitude,
        this.longitude,
        this.nom,
        this.surnom,
        this.description,
        this.photoId,
        this.photoUrl,
        this.quartier,
        this.quartierId,
        this.estFavorite,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.providerId,
        this.providerName,
        this.mapStaticUrl,
        this.updateAllowed,
        this.latLng});

  Adresse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    villeId = json['ville_id'];
    creatorId = json['creator_id'];
    updaterId = json['updater_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    nom = json['nom'];
    surnom = json['surnom'];
    description = json['description'];
    photoId = json['photo_id'];
    photoUrl = json['photo_url'];
    quartier = json['quartier'];
    quartierId = json['quartier_id'];
    estFavorite = json['est_favorite'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    providerId = json['provider_id'];
    providerName = json['provider_name'];
    mapStaticUrl = json['map_static_url'];
    updateAllowed = json['update_allowed'];
    latLng = json['lat_lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['client_id'] = clientId;
    data['ville_id'] = villeId;
    data['creator_id'] = creatorId;
    data['updater_id'] = updaterId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['nom'] = nom;
    data['surnom'] = surnom;
    data['description'] = description;
    data['photo_id'] = photoId;
    data['photo_url'] = photoUrl;
    data['quartier'] = quartier;
    data['quartier_id'] = quartierId;
    data['est_favorite'] = estFavorite;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['provider_id'] = providerId;
    data['provider_name'] = providerName;
    data['map_static_url'] = mapStaticUrl;
    data['update_allowed'] = updateAllowed;
    data['lat_lng'] = latLng;
    return data;
  }
}

class Extra {
  Routes? routes;

  Extra({this.routes});

  Extra.fromJson(Map<String, dynamic> json) {
    routes =
    json['routes'] != null ? Routes.fromJson(json['routes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (routes != null) {
      data['routes'] = routes!.toJson();
    }
    return data;
  }
}

class Routes {
  String? apiModulesMagasins;
  String? apiModulesCategories;
  String? apiModulesBySlugMagasins;
  String? apiModulesBySlugCategories;

  Routes(
      {this.apiModulesMagasins,
        this.apiModulesCategories,
        this.apiModulesBySlugMagasins,
        this.apiModulesBySlugCategories});

  Routes.fromJson(Map<String, dynamic> json) {
    apiModulesMagasins = json['api.modules.magasins'];
    apiModulesCategories = json['api.modules.categories'];
    apiModulesBySlugMagasins = json['api.modules.bySlug.magasins'];
    apiModulesBySlugCategories = json['api.modules.bySlug.categories'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['api.modules.magasins'] = apiModulesMagasins;
    data['api.modules.categories'] = apiModulesCategories;
    data['api.modules.bySlug.magasins'] = apiModulesBySlugMagasins;
    data['api.modules.bySlug.categories'] = apiModulesBySlugCategories;
    return data;
  }
}