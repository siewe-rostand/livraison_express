
import 'package:livraison_express/model/shop.dart';

import 'extra.dart';

class Modules {
  int? id;
  String? libelle;
  String? slug;
  int? displayRank;
  dynamic? information;
  String? heureOuverture;
  String? heureFermeture;
  dynamic? baseDeliveryMeters;
  dynamic? baseDeliveryAmountPerStep;
  int? baseDeliveryMetersAsStepUnit;
  dynamic? freeShippingCartAmount;
  int? isOpen;
  int? isActive;
  int? isAvailable;
  bool? isActiveInCity;
  String? image;
  List<Shops>? shops;
  String? moduleColor;
  List<String>? availableInCities;
  dynamic? baseDeliveryAmount;
  String? createdAt;
  String? updatedAt;
  dynamic? deletedAt;
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