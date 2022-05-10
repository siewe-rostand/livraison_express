import 'package:flutter/cupertino.dart';
import 'package:livraison_express/model/product.dart';

class CartModel{
   final String id;
  final Product product;
    int quantity;

  CartModel({
    required this.id, required this.product,  required this.quantity});

   static Map<String, dynamic> toMap(CartModel cartModel) => {
     'id': cartModel.id,
     'product': cartModel.product,
     'quantity': cartModel.quantity,
   };

   factory CartModel.fromJson(Map<String, dynamic> json) {
     return CartModel(
       id: json['id'],
       product: Product.fromJson(json['product']) ,
       quantity: json['quantity'],
     );
   }
   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = <String, dynamic>{};

     data['product'] = product.toJson();
     data['quantity'] = quantity;

     return data;
   }
}
class CartItem{
  final int id;
  final String title;
  final int quantity;
  final int price;
  final String image;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.image,
  });
   Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'quantity': quantity,
    'price': price,
     'image': image,
  };

  CartItem.fromMap(Map<dynamic , dynamic>  res)
      : id = res['id'],
        title = res["title"],
        quantity = res["quantity"],
        price = res["price"],
        image = res["image"];

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      title: json['title'] ,
      price: json['price'] ,
      image: json['image'],
      quantity: json['quantity'],
    );
  }
  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = <String, dynamic>{};

    data['title'] = title;
    data['quantity'] = quantity;
    data['price'] = price;
    data['image'] = image;

    return data;
  }
}