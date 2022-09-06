import 'package:flutter/material.dart';
import 'package:livraison_express/model/cart-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../model/product.dart';
import '../../data/local_db/db-helper.dart';

class CartProvider extends ChangeNotifier{

  DBHelper db = DBHelper() ;
  int _counter = 0 ;
  int _quantity = 1;
  int get quantity => _quantity;
  int get counter => _counter;

  double _totalPrice = 0.0 ;
  double get totalPrice => _totalPrice;

  late Future<List<CartItem>> _cart ;
  Future<List<CartItem>> get cart => _cart ;

  Future<List<CartItem>> getData () async {
    _cart = db.getCartList();
    return _cart ;
  }
  late Product _active;

  void _setPrefItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance() ;
    prefs.setInt('cart_item', _counter);
    prefs.setInt('item_quantity', _quantity);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }
  void _getPrefItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance() ;
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    _quantity = prefs.getInt('item_quantity') ?? 1;
    notifyListeners();
  }
  void _clearPrefAllItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance() ;
    prefs.clear();
    notifyListeners();
  }
  void _clearPrefItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance() ;
    prefs.remove('cart_item');
    prefs.remove('total_price');
    db.deleteAlls();
    notifyListeners();
  }
  void addTotalPrice (double productPrice){
    _totalPrice = _totalPrice +productPrice ;
    _setPrefItems();
    notifyListeners();
  }
  void removeTotalPrice (double productPrice){
    _totalPrice = _totalPrice  - productPrice ;
    _setPrefItems();
    notifyListeners();
  }

  double getTotalPrice (){
    _getPrefItems();
    return  _totalPrice ;
  }

  void addCounter (){
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  showCartDialog(BuildContext context,String title,String message,String non,String oui,String slug){
    showDialog(
        context: context,
        builder: (BuildContext builderContext){
          return AlertDialog(
            content: Text(message),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Text(title),
              ],
            ),
            actions: [
              TextButton(
                child:  Text(non),
                onPressed: (){
                  Navigator.of(builderContext).pop();
                },
              ),
              TextButton(
                child:  Text(oui),
                onPressed: (){
                  clear(slug);
                  Navigator.of(builderContext).pop();
                },
              )
            ],
          );
        }
    );
    notifyListeners();
  }

  void removerCounter (){
    _counter--;
    _setPrefItems();
    notifyListeners();
  }

  int getCounter (){
    _getPrefItems();
    return  _counter ;

  }

  setActiveProduct(Product product) {
    _active = product;
  }

  void clear(String slug){
    db.deleteAll();
    _clearPrefItems();
  }

  void clears(){
    db.deleteAlls();
    _clearPrefItems();
  }

}
class Cart with ChangeNotifier {
  List<CartItem> _products= [];
  Map<String, CartModel> _items = {};
  var total = 0.0;

  List<Product> get products {
    return [...products];
  }
  Map<String, dynamic> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  get itemsO async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getInt('count');
    return _items.length;
  }

  void decrement(String id){
    for(int i=0; i<_items.length;i++){
      if(id == _items.values.toList()[i].id){

        _items.values.toList()[i].quantity -= 1;
      }if(_items.values.toList()[i].quantity < 1){
        removeItem(id);
      }
    }
    notifyListeners();
    totalAmount;
  }

  void incrementQty(String id){
    _items.forEach((key, cartItem) {
      if(id == cartItem.id){
        cartItem.quantity += 1;
      }
    });
    notifyListeners();
    totalAmount;
  }
  double get totalAmount {
    total = 0.0;
    if(items.isEmpty){
      total = 0.0;
    }
    // var n=_items.entries.toList();
    // for(var i=0; i<n.length;i++){
    //   total += n[i].value.product.unitPrice * n[i].value.quantity;
    // }
    _items.forEach((key, cartItem) {
      total += cartItem.product.unitPrice * cartItem.quantity;
    });
    return total;
  }

  add(Product product){

    var ca= CartItem(id: product.id,title: product.name,quantity: 1,price: product.unitPrice,image: product.image, quantity1: ValueNotifier(1));
    _products.add(ca);
    var a=jsonEncode(_products.map((player) => player.toJson()).toList());
    Map<String, dynamic> v =jsonDecode(a);
    var cf = CartItem.fromJson(v);
    print(cf);
  }
  void addItem(Product product, String productId) {
    if (_items.containsKey(productId)) {
      print('hiii');
      _items.update(
        productId,
            (existingValue) => CartModel(
          id: existingValue.id,
          product: product,
          quantity: existingValue.quantity + 1,
        ),
      );
    } else {
      print('koooo');
      _items.putIfAbsent(
        productId,
            () => CartModel(
          id: DateTime.now().toString(),
          product: product,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    if(_items.containsKey(id)) {
      _items.remove(id);
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      print('jjj');
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
            (existingCartItem) => CartModel(
          id: existingCartItem.id,
          product: existingCartItem.product,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear()async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    _items = {};
    notifyListeners();
  }
}

class CartProvider1 with ChangeNotifier {
  DBHelper1 dbHelper = DBHelper1();
  int _counter = 0;
  int _quantity = 1;
  int get counter => _counter;
  int get quantity => _quantity;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  List<CartItem1> cart = [];

  Future<List<CartItem1>> getData() async {
    cart = await dbHelper.getCartList();
    notifyListeners();
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
    _getPrefsItems();
    return _counter;
  }

  void addQuantity(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart[index].quantity!.value = cart[index].quantity!.value + 1;
    _setPrefsItems();
    notifyListeners();
  }

  void deleteQuantity(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    final currentQuantity = cart[index].quantity!.value;
    if (currentQuantity <= 1) {
      currentQuantity == 1;
    } else {
      cart[index].quantity!.value = currentQuantity - 1;
    }
    _setPrefsItems();
    notifyListeners();
  }

  void removeItem(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart.removeAt(index);
    _setPrefsItems();
    notifyListeners();
  }

  int getQuantity(int quantity) {
    _getPrefsItems();
    return _quantity;
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefsItems();
    return _totalPrice;
  }
}



