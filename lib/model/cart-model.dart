
import 'package:flutter/cupertino.dart';
import 'package:livraison_express/model/product.dart';

class CartItem1 {
  int? id;
  String? title;
  ValueNotifier<int>? quantity;
  int? price;
  int? unitPrice;
  int? quantityMax;
  int? totalPrice;
  int? productId;
  int? categoryId;
  int? userId;
  String image;
  String? complement;
  int? preparationTime;
  String? moduleSlug;

  CartItem1(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price,
      required this.image,
      this.unitPrice,
      this.userId,
      this.categoryId,
      this.complement,
      this.preparationTime,
      this.productId,
      this.totalPrice,
      this.quantityMax,
      this.moduleSlug});
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'price': price,
        'prix_unitaire': unitPrice,
        'prix_total': totalPrice,
        'quantity': quantity?.value,
        'image': image,
        'quantiteMax': quantityMax,
        'id_produit': productId,
        'id_categorie': categoryId,
        'id_user': userId,
        'complements': complement,
        'module_slug': moduleSlug,
        'temps_preparation': preparationTime,
      };

  CartItem1.fromMap(Map<dynamic, dynamic> json)
      : id = json['id'],
        title = json["title"],
        price = json['prix_unitaire'],
        image = json['image'],
        quantity = ValueNotifier(json['quantity']),
        unitPrice = json['prix_unitaire'],
        totalPrice = json['prix_total'],
        quantityMax = json['quantiteMax'],
        productId = json['id_produit'],
        categoryId = json['id_categorie'],
        userId = json['id_user'],
        complement = json['complement'],
        preparationTime = json['time_preparation'],
        moduleSlug = json['module_slug'];

  factory CartItem1.fromJson(Map<String, dynamic> json) {
    return CartItem1(
      id: json['id'],
      title: json['libelle'],
      price: json['price'],
      image: json['image'],
      quantity: json['quantity'],
      unitPrice: json['prix_unitaire'],
      totalPrice: json['prix_total'],
      quantityMax: json['quantiteMax'],
      productId: json['id_produit'],
      categoryId: json['id_categorie'],
      userId: json['id_user'],
      complement: json['complement'],
      preparationTime: json['time_preparation'],
      moduleSlug: json['module_slug'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['libelle'] = title;
    data['quantity'] = quantity;
    data['price'] = price;
    data['prix_unitaire'] = unitPrice;
    data['image'] = image;

    return data;
  }
}

class CartItem {
  int? id;
  String? title;
  int? quantity;
  int? price;
  int? unitPrice;
  int? quantityMax;
  int? totalPrice;
  int? productId;
  int? categoryId;
  int? userId;
  String image;
  String? complement;
  int? preparationTime;
  String? moduleSlug;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price,
      required this.image,
      required this.productId,
      this.unitPrice,
      this.userId,
      this.categoryId,
      this.complement,
      this.preparationTime,
      this.totalPrice,
      this.quantityMax,
      this.moduleSlug});
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'price': price,
        'prix_unitaire': unitPrice,
        'prix_total': totalPrice,
        'quantity': quantity,
        'image': image,
        'quantiteMax': quantityMax,
        'id_produit': productId,
        'id_categorie': categoryId,
        'id_user': userId,
        'complements': complement,
        'module_slug': moduleSlug,
        'temps_preparation': preparationTime,
      };

  CartItem.fromMap(Map<dynamic, dynamic> json)
      : id = json['id'],
        title = json["title"],
        price = json['prix_unitaire'],
        image = json['image'],
        quantity = json['quantity'],
        unitPrice = json['prix_unitaire'],
        totalPrice = json['prix_total'],
        quantityMax = json['quantiteMax'],
        productId = json['id_produit'],
        categoryId = json['id_categorie'],
        userId = json['id_user'],
        complement = json['complement'],
        preparationTime = json['time_preparation'],
        moduleSlug = json['module_slug'];

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      title: json['libelle'],
      price: json['price'],
      image: json['image'],
      quantity: json['quantity'],
      unitPrice: json['prix_unitaire'],
      totalPrice: json['prix_total'],
      quantityMax: json['quantiteMax'],
      productId: json['id_produit'],
      categoryId: json['id_categorie'],
      userId: json['id_user'],
      complement: json['complement'],
      preparationTime: json['time_preparation'],
      moduleSlug: json['module_slug'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['libelle'] = title;
    data['quantity'] = quantity;
    data['price'] = price;
    data['prix_unitaire'] = unitPrice;
    data['image'] = image;

    return data;
  }
}
