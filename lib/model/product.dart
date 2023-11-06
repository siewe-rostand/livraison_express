

import 'package:livraison_express/model/image.dart';

import 'attributes.dart';

class Products {
  int? id;
  int? magasinId;
  int? totalPrice;
  int?quantity;
  int? possessionId;
  int? possessionCategorieId;
  int? categorieId;
  int? subCategoryId;
  String? libelle;
  String? detail;
  String? slug;
  int? prixUnitaire;
  dynamic subTotalAmount;
  int? quantiteDispo;
  String? brandName;
  String? brandLogo;
  String? tags;
  int? type;
  String? image;
  String? typeHuman;
  List<Image>? images;
  bool? isActive;
  int? tempsPreparation;
  List<Attributes>? attributes;
  String? createdAt;
  String? updatedAt;

  Products(
      {this.id,
        this.magasinId,
        this.possessionId,
        this.possessionCategorieId,
        this.categorieId,
        this.subCategoryId,
        this.libelle,
        this.detail,
        this.slug,
        this.prixUnitaire,
        this.quantiteDispo,
        this.brandName,
        this.brandLogo,
        this.tags,
        this.type,
        this.image,
        this.typeHuman,
        this.images,
        this.isActive,
        this.tempsPreparation,
        this.attributes,
        this.createdAt,
        this.updatedAt,
        this.totalPrice,
        this.subTotalAmount,
        this.quantity
      });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    magasinId = json['magasin_id'];
    totalPrice = json['prix_total'];
    quantity = json['quantite'];
    possessionId = json['possession_id'];
    possessionCategorieId = json['possession_categorie_id'];
    categorieId = json['categorie_id'];
    subCategoryId = json['souscategorie_id'];
    libelle = json['libelle'];
    detail = json['detail'];
    slug = json['slug'];
    prixUnitaire = json['prix_unitaire'];
    quantiteDispo = json['quantite_dispo'];
    brandName = json['brand_name'];
    tags = json['tags'];
    type = json['type'];
    image = json['image'];
    typeHuman = json['type_human'];
    isActive = json['is_active'];
    subTotalAmount = json['montant_soustotal'];
    tempsPreparation = json['temps_preparation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    attributes=json["attributes"]==null ? null : (json["attributes"] as List).map((e)=>Attributes.fromJson(e)).toList();
    images=json["images"]==null ? null : (json["images"] as List).map((e)=>Image.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['magasin_id'] = magasinId;
    data['prix_total'] = totalPrice;
    data['quantite'] = quantity;
    data['possession_id'] = possessionId;
    data['possession_categorie_id'] = possessionCategorieId;
    data['categorie_id'] = categorieId;
    data['souscategorie_id'] = subCategoryId;
    data['libelle'] = libelle;
    data['montant_soustotal'] = subTotalAmount;
    data['detail'] = detail;
    data['slug'] = slug;
    data['prix_unitaire'] = prixUnitaire;
    data['quantite_dispo'] = quantiteDispo;
    data['brand_name'] = brandName;
    data['brand_logo'] = brandLogo;
    data['tags'] = tags;
    data['type'] = type;
    data['image'] = image;
    data['type_human'] = typeHuman;
    data['is_active'] = isActive;
    data['temps_preparation'] = tempsPreparation;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if(attributes != null) {
        data["attributes"] = attributes?.map((e)=>e.toJson()).toList();
    }
    if(images != null) {
        data["images"] = images?.map((e)=>e.toJson()).toList();
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
