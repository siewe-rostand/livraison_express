
import 'package:livraison_express/model/client.dart';

import 'address-favorite.dart';
import 'address.dart';
import 'horaire.dart';

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
  dynamic? cautionIncrementationCoursesDistribuable;
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
  dynamic? freeShippingCartAmount;
  int? shippingPreparationTime;
  int? shippingDurationMaxAcceptMinutes;
  int? shippingDistanceMaxAcceptMeters;
  String? createdAt;
  String? updatedAt;
  dynamic? deletedAt;
  Adresse? adresse;
  Adresse? adresseFavorite;
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
    adresseFavorite = json["adresse"] == null ? null : Adresse.fromJson(json["adresse"]);
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
