import 'dart:developer';

import 'package:livraison_express/model/cart-model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  final String tableName = 'panier';
  final String idCol = "id";
  final String textCol = 'title';
  final String unitPriceCol = "prix_unitaire";
  final String priceCol = "price";
  final String totalPriceCol = "prix_total";
  final String qtyCol = "quantity";
  final String imgCol = "image";
  final String maxQtyCol = "quantiteMax";
  final String pIdCol = "id_produit";
  final String idCatCol = "id_categorie";
  final String uIdCol = "id_user";
  final String comCol = "complements";
  final String moduleCol = "module_slug";
  final String prepTimeCol = "temps_preparation";

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  // creating database table
  _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE $tableName ($idCol INTEGER,$textCol TEXT, $priceCol INTEGER , $unitPriceCol INTEGER , $totalPriceCol INTEGER ,$qtyCol INTEGER, $imgCol TEXT,
         $maxQtyCol INTEGER, $pIdCol INTEGER  PRIMARY KEY,$idCatCol INTEGER , $uIdCol INTEGER, $comCol TEXT, $moduleCol TEXT,  $prepTimeCol INTEGER)''');
  }

  Future<CartItem> insert(CartItem cart) async {
    var dbClient = await db;
    await dbClient.insert(tableName, cart.toJson());
    return cart;
  }

  Future<List<CartItem>> getCartList(String module) async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient
        .query(tableName, where: 'module_slug = ?', whereArgs: [module]);
    return queryResult.map((e) => CartItem.fromJson(e)).toList();
  }

  Future<int> delete(int id, String moduleSlug) async {
    var dbClient = await db;
    return await dbClient.delete(tableName,
        where: 'id_produit = ? and module_slug = ?',
        whereArgs: [id, moduleSlug]);
  }

  Future<int> updateQuantity(CartItem cart) async {
    var dbClient = await db;
    return await dbClient.update(tableName, cart.toJson(),
        where: 'id_produit = ? and module_slug = ?',
        whereArgs: [cart.productId, cart.moduleSlug]);
  }
  Future<CartItem> updateQuantity1(CartItem cart) async {
    var dbClient = await db;
     await dbClient.update(tableName, cart.toJson(),
        where: 'id_produit = ? and module_slug = ?',
        whereArgs: [cart.productId, cart.moduleSlug]);
     return cart;
  }

  Future deleteAll(String moduleSlug) async {
    var dbClient = await db;
    dbClient.delete(
      tableName,
      where: 'module_slug = ?',
      whereArgs: [moduleSlug],
    );
  }

 Future<int> getTotal(String moduleSlug) async{
   var dbClient = await db;
   var queryResult = await dbClient.rawQuery("SELECT SUM(prix_total)  as total from panier where module_slug = ?",[moduleSlug]);
   String abc = queryResult[0]['total'].toString();
   int total = int.parse(abc);
   return total;
  }

  Future<int> getCartAmount(String slug) async{
    int amount = 0;
    await getCartList(slug).then((value){
      for (var element in value) {
        amount = amount + (element.quantity! * element.unitPrice!);
      }
    });
    return amount;
  }
}
