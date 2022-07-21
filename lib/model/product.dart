import 'package:flutter/cupertino.dart';
import 'package:livraison_express/constant/some-constant.dart';

import 'attributes.dart';

class Product {
  final int id;
  final String name;
  final int unitPrice;
  final String image;
  int? quantity;

  Product({
    required this.name,
    required this.unitPrice,
    required this.image,
    this.quantity,
    required this.id,
  });

  static Map<String, dynamic> toMap(Product products) => {
        'id': products.id,
        'name': products.name,
        'image': products.image,
        'quantity': products.quantity,
        'unitPrice': products.unitPrice,
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      unitPrice: json['unitPrice'],
      image: json['image'],
      quantity: json['quantity'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['quantity'] = quantity;
    data['unitPrice'] = unitPrice;
    data['image'] = image;

    return data;
  }
  //  Map<String, dynamic> toJson() => {
  //   'id': id,
  //   'name': name,
  //   'image': image,
  //   'quantity': quantity,
  //   'unitPrice': unitPrice,
  // };
}
class Products {
  int? id;
  int? magasinId;
  int? possessionId;
  int? possessionCategorieId;
  int? categorieId;
  String? libelle;
  String? detail;
  String? slug;
  int? prixUnitaire;
  int? quantiteDispo;
  Null? disponibiliteGeneral;
  String? brandName;
  String? brandLogo;
  String? tags;
  int? type;
  String? image;
  String? typeHuman;
  List<Null>? images;
  bool? isActive;
  Null? isAvailable;
  int? tempsPreparation;
  Null? maxOption;
  List<Null>? horaires;
  List<Attributes>? attributes;
  List<Null>? availableInCities;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  List<Null>? extra;

  Products(
      {this.id,
        this.magasinId,
        this.possessionId,
        this.possessionCategorieId,
        this.categorieId,
        this.libelle,
        this.detail,
        this.slug,
        this.prixUnitaire,
        this.quantiteDispo,
        this.disponibiliteGeneral,
        this.brandName,
        this.brandLogo,
        this.tags,
        this.type,
        this.image,
        this.typeHuman,
        this.images,
        this.isActive,
        this.isAvailable,
        this.tempsPreparation,
        this.maxOption,
        this.horaires,
        this.attributes,
        this.availableInCities,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.extra});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    magasinId = json['magasin_id'];
    possessionId = json['possession_id'];
    possessionCategorieId = json['possession_categorie_id'];
    categorieId = json['categorie_id'];
    libelle = json['libelle'];
    detail = json['detail'];
    slug = json['slug'];
    prixUnitaire = json['prix_unitaire'];
    quantiteDispo = json['quantite_dispo'];
    disponibiliteGeneral = json['disponibilite_general'];
    brandName = json['brand_name'];
    tags = json['tags'];
    type = json['type'];
    image = json['image'];
    typeHuman = json['type_human'];
    isActive = json['is_active'];
    isAvailable = json['is_available'];
    tempsPreparation = json['temps_preparation'];
    maxOption = json['max_option'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    attributes=json["attributes"]==null ? null : (json["attributes"] as List).map((e)=>Attributes.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['magasin_id'] = magasinId;
    data['possession_id'] = possessionId;
    data['possession_categorie_id'] = possessionCategorieId;
    data['categorie_id'] = categorieId;
    data['libelle'] = libelle;
    data['detail'] = detail;
    data['slug'] = slug;
    data['prix_unitaire'] = prixUnitaire;
    data['quantite_dispo'] = quantiteDispo;
    data['disponibilite_general'] = disponibiliteGeneral;
    data['brand_name'] = brandName;
    data['brand_logo'] = brandLogo;
    data['tags'] = tags;
    data['type'] = type;
    data['image'] = image;
    data['type_human'] = typeHuman;
    data['is_active'] = isActive;
    data['is_available'] = isAvailable;
    data['temps_preparation'] = tempsPreparation;
    data['max_option'] = maxOption;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if(attributes != null) {
        data["attributes"] = attributes?.map((e)=>e.toJson()).toList();
    }
    return data;
  }
}

class Payload {
  Payload({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<Products> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  String? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    currentPage: json["current_page"],
    data: List<Products>.from(json["data"].map((x) => Products.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}
