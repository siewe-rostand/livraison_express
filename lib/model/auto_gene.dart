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
  Null? nbreCoursesDistribuable;
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
  Contact? contact;

  Shops(
      {this.id,
        this.creatorId,
        this.updaterId,
        this.etablissementId,
        this.partenaireId,
        this.moduleId,
        this.nom,
        this.slug,
        this.nbreCoursesDistribuable,
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
    nbreCoursesDistribuable = json['nbre_courses_distribuable'];
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
    contact =
    json['contact'] != null ? Contact.fromJson(json['contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['creator_id'] = this.creatorId;
    data['updater_id'] = this.updaterId;
    data['etablissement_id'] = this.etablissementId;
    data['partenaire_id'] = this.partenaireId;
    data['module_id'] = this.moduleId;
    data['nom'] = this.nom;
    data['slug'] = this.slug;
    data['nbre_courses_distribuable'] = this.nbreCoursesDistribuable;
    data['caution_incrementation_courses_distribuable'] =
        this.cautionIncrementationCoursesDistribuable;
    data['display_rank'] = this.displayRank;
    data['description'] = this.description;
    data['contact_id'] = this.contactId;
    data['ville_id'] = this.villeId;
    data['adresse_id'] = this.adresseId;
    data['image'] = this.image;
    data['is_master'] = this.isMaster;
    if (this.horaires != null) {
      data['horaires'] = this.horaires!.toJson();
    }
    data['tags'] = this.tags;
    data['is_active'] = this.isActive;
    data['is_available'] = this.isAvailable;
    data['base_delivery_meters'] = this.baseDeliveryMeters;
    data['base_delivery_amount'] = this.baseDeliveryAmount;
    data['base_delivery_meters_as_step_unit'] =
        this.baseDeliveryMetersAsStepUnit;
    data['base_delivery_amount_per_step'] = this.baseDeliveryAmountPerStep;
    data['free_shipping_cart_amount'] = this.freeShippingCartAmount;
    data['shipping_preparation_time'] = this.shippingPreparationTime;
    data['shipping_duration_max_accept_minutes'] =
        this.shippingDurationMaxAcceptMinutes;
    data['shipping_distance_max_accept_meters'] =
        this.shippingDistanceMaxAcceptMeters;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.adresse != null) {
      data['adresse'] = this.adresse!.toJson();
    }
    if (this.contact != null) {
      data['contact'] = this.contact!.toJson();
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

class Contact {
  int? id;
  String? holderId;
  String? creatorId;
  String? updaterId;
  Null? adresseFavoriteId;
  String? uuid;
  String? username;
  String? avatar;
  String? fullname;
  String? firstname;
  String? lastname;
  String? email;
  String? emailVerifiedAt;
  String? phoneVerifiedAt;
  String? telephone;
  String? telephoneAlt;
  String? genre;
  String? providerId;
  String? providerName;
  Null? langue;
  String? description;
  String? modules;
  String? token;
  Null? fcmToken;
  Null? nbreCoursesDistribuable;
  Null? cautionIncrementationCoursesDistribuable;
  int? statut;
  bool? isGuest;
  int? type;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  Null? lastLoginAt;
  Null? lastLoginIp;
  Null? stripeId;
  Null? cardBrand;
  Null? cardLastFour;
  Null? trialEndsAt;

  Contact(
      {this.id,
        this.holderId,
        this.creatorId,
        this.updaterId,
        this.adresseFavoriteId,
        this.uuid,
        this.username,
        this.avatar,
        this.fullname,
        this.firstname,
        this.lastname,
        this.email,
        this.emailVerifiedAt,
        this.phoneVerifiedAt,
        this.telephone,
        this.telephoneAlt,
        this.genre,
        this.providerId,
        this.providerName,
        this.langue,
        this.description,
        this.modules,
        this.token,
        this.fcmToken,
        this.nbreCoursesDistribuable,
        this.cautionIncrementationCoursesDistribuable,
        this.statut,
        this.isGuest,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.lastLoginAt,
        this.lastLoginIp,
        this.stripeId,
        this.cardBrand,
        this.cardLastFour,
        this.trialEndsAt});

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    holderId = json['holder_id'];
    creatorId = json['creator_id'];
    updaterId = json['updater_id'];
    adresseFavoriteId = json['adresse_favorite_id'];
    uuid = json['uuid'];
    username = json['username'];
    avatar = json['avatar'];
    fullname = json['fullname'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    telephone = json['telephone'];
    telephoneAlt = json['telephone_alt'];
    genre = json['genre'];
    providerId = json['provider_id'];
    providerName = json['provider_name'];
    langue = json['langue'];
    description = json['description'];
    modules = json['modules'];
    token = json['token'];
    fcmToken = json['fcm_token'];
    nbreCoursesDistribuable = json['nbre_courses_distribuable'];
    cautionIncrementationCoursesDistribuable =
    json['caution_incrementation_courses_distribuable'];
    statut = json['statut'];
    isGuest = json['is_guest'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    lastLoginAt = json['last_login_at'];
    lastLoginIp = json['last_login_ip'];
    stripeId = json['stripe_id'];
    cardBrand = json['card_brand'];
    cardLastFour = json['card_last_four'];
    trialEndsAt = json['trial_ends_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['holder_id'] = holderId;
    data['creator_id'] = creatorId;
    data['updater_id'] = updaterId;
    data['adresse_favorite_id'] = adresseFavoriteId;
    data['uuid'] = uuid;
    data['username'] = username;
    data['avatar'] = avatar;
    data['fullname'] = fullname;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['phone_verified_at'] = phoneVerifiedAt;
    data['telephone'] = telephone;
    data['telephone_alt'] = telephoneAlt;
    data['genre'] = genre;
    data['provider_id'] = providerId;
    data['provider_name'] = providerName;
    data['langue'] = langue;
    data['description'] = description;
    data['modules'] = modules;
    data['token'] = token;
    data['fcm_token'] = fcmToken;
    data['nbre_courses_distribuable'] = nbreCoursesDistribuable;
    data['caution_incrementation_courses_distribuable'] =
        cautionIncrementationCoursesDistribuable;
    data['statut'] = statut;
    data['is_guest'] = isGuest;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['last_login_at'] = lastLoginAt;
    data['last_login_ip'] = lastLoginIp;
    data['stripe_id'] = stripeId;
    data['card_brand'] = cardBrand;
    data['card_last_four'] = cardLastFour;
    data['trial_ends_at'] = trialEndsAt;
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