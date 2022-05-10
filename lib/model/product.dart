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
  final int? id;
  int? magasinId;
  int? categoryId;
  int? unitPrice;
  int? totalPrice;
  int? quantityAvailable;
  int? preparationTime;
  String? name;
  String? image;
  String? detail;
  List<Attributes>? attributes;

  Products(
      {this.id,
      this.name,
      this.image,
      this.totalPrice,
      this.unitPrice,
      this.detail,
      this.attributes,
      this.categoryId,
      this.magasinId,
      this.preparationTime,
      this.quantityAvailable});

  static Map<String, dynamic>toMap(Products products)=>{
  ProductConstant.id :products.id,
    ProductConstant.name:products.name,
    ProductConstant.magasinId:products.magasinId,
    ProductConstant.categoryId:products.categoryId,
    ProductConstant.unitPrice:products.unitPrice,
    ProductConstant.quantity:products.quantityAvailable,
    ProductConstant.preparationTime:products.preparationTime,
    ProductConstant.image:products.image,
    ProductConstant.description:products.detail,
    ProductConstant.complement:products.attributes
  };

  factory Products.fromJson(Map<String,dynamic> json){
    var list = json[ProductConstant.complement] as List;
    print(list.runtimeType);
    List<Attributes> attributes = list.map((i) => Attributes.fromJson(i)).toList();
    return Products(
      id: json[ProductConstant.id],
      magasinId: json[ProductConstant.magasinId],
      categoryId: json[ProductConstant.categoryId],
      unitPrice: json[ProductConstant.unitPrice],
      quantityAvailable: json[ProductConstant.quantity],
      preparationTime: json[ProductConstant.preparationTime],
      name: json[ProductConstant.name],
      image: json[ProductConstant.image],
      detail: json[ProductConstant.description],
      attributes: attributes
    );
  }


}
