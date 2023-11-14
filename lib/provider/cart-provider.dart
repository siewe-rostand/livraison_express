
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/cart-model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local_db/db-helper.dart';


class CartProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  int _counter = 0;
  int _quantity = 1;
  int _totalAmount = 0;
  int get counter => _counter;
  int get quantity => _quantity;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;
  int get totalAmount => _totalAmount;

  List<CartItem> cart = [];

  Future<List<CartItem>> getData(String moduleSlug) async {
    cart = await dbHelper.getCartList(moduleSlug);
    return cart;
  }

  void _setPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_items', _counter);
    prefs.setInt('item_quantity', _quantity);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_items') ?? 0;
    _quantity = prefs.getInt('item_quantity') ?? 1;
    _totalPrice = prefs.getDouble('total_price') ?? 0;
  }

  void clears(){
    dbHelper.deleteAll(UserHelper.module.slug!);
    notifyListeners();
  }

  void addCounter() {
    _counter++;
    _setPrefsItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPrefsItems();
    notifyListeners();
  }

  int getCounter() {
    int count = cart.length;
    return count;
  }

 Future<CartItem> updateQuantity(CartItem cartItem) async{
  var cart =  await dbHelper.updateQuantity1(cartItem);
    notifyListeners();
    return cart;
  }


}



