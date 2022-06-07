import 'package:livraison_express/model/attributes.dart';

class Article{
  int? id;
  int? magasinId;
  int? categoryId;
  int? subCategoryId;
  int? unitPrice;
  int? totalPrice;
  int? subTotalAmount;
  int? quantity;
  String? libelle;
  String? description;
  String? taille;
  List<Attributes>? attributes;
  Article({
    this.id,this.description,this.libelle,this.categoryId,this.totalPrice,this.subCategoryId,this.attributes,
    this.unitPrice,this.quantity,this.magasinId,this.subTotalAmount,this.taille
});

  Article.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    magasinId = json['magasin_id'];
    categoryId = json['categorie_id'];
    subCategoryId = json['souscategorie_id'];
    libelle = json['libelle'];
    description = json['description'];
    taille = json['taille'];
    quantity = json['quantite'];
    unitPrice = json['prix_unitaire'];
    subTotalAmount = json['montant_soustotal'];
    if (json['attributs'] != null) {
      attributes = <Attributes>[];
      json['attributs'].forEach((v) {
        attributes!.add(Attributes.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['magasin_id'] = magasinId;
    data['categorie_id'] = categoryId;
    data['souscategorie_id'] = subCategoryId;
    data['libelle'] = libelle;
    data['description'] = description;
    data['taille'] = taille;
    data['quantite'] = quantity;
    data['prix_unitaire'] = unitPrice;
    data['montant_soustotal'] = subTotalAmount;
    if (attributes != null) {
      data['attributs'] = attributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}