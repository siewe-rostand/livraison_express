
import 'package:livraison_express/model/cart-model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  final String tableName = 'carts';
  final String idCol = "id";
  final String textCol = 'title';
  final String unitPriceCol = "prix_unitaire";
  final String priceCol = "price";
  final String totalPriceCol = "prix_total";
  final String qtyCol = "quantity";
  final String qty1Col = "quantity1";
  final String imgCol = "image";
  final String maxQtyCol = "quantiteMax";
  final String pIdCol = "id_produit";
  final String idCatCol = "id_categorie";
  final String uIdCol = "id_user";
  final String comCol = "complements";
  final String moduleCol = "module_slug";
  final String prepTimeCol = "temps_preparation";
  Database? _db;

  Future<Database> get db async {
    return _db ??= await initDatabase();
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

  _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS  $tableName ($idCol INTEGER PRIMARY KEY ,$textCol TEXT, $priceCol INTEGER , $unitPriceCol INTEGER , $totalPriceCol INTEGER ,$qtyCol INTEGER, $imgCol TEXT,
         $maxQtyCol INTEGER, $pIdCol INTEGER,$idCatCol INTEGER , $uIdCol INTEGER, $comCol TEXT, $moduleCol TEXT,  $prepTimeCol INTEGER)''');
  }

  Future<CartItem> insert(CartItem cartItem) async {
    print("Cart items ${cartItem.toMap()}");
    var dbClient = await db;
    cartItem.id=await dbClient.insert(tableName, cartItem.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    // var batch = dbClient.batch();
    // batch.insert(tableName, cartItem.toMap());
    // await batch.commit(noResult: true);
    return cartItem;
  }

  Future<List<CartItem>> getCartList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient.query(tableName);
    return queryResult.map((e) => CartItem.fromMap(e)).toList();
  }
  Future<List<CartItem>> getItems(String slug) async{
    Database myDatabase = await db;
    List<Map<String, dynamic>> result =
    await myDatabase.query(tableName, where: '$moduleCol = ?', whereArgs: [slug]);
    List<CartItem> carts = [];
    for (var element in result) {
      carts.add(CartItem.fromMap(element));
    }
    return carts;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateQuantity(CartItem cart) async {
    var dbClient = await db;
    return await dbClient
        .update(tableName, cart.toMap(), where: 'id = ?', whereArgs: [cart.id]);
  }
  Future<int?> getCartAmount() async{
    int? amount = 0;
    await getCartList().then((value){
      value.forEach((element) {
        var tp =element.totalPrice;
        amount = amount! + (element.quantity! * tp!);
      });
    });
    return amount;
  }

  Future deleteAll() async {
    var dbClient = await db;
    dbClient.delete(tableName);
  }
  Future deleteAlls() async {
    var dbClient = await db;
    dbClient.delete(tableName);
  }
}


class DBHelper1 {
  final String tableName = 'carts';
  final String idCol = "id";
  final String textCol = 'title';
  final String unitPriceCol = "prix_unitaire";
  final String priceCol = "price";
  final String totalPriceCol = "prix_total";
  final String qtyCol = "quantity";
  final String qty1Col = "quantity1";
  final String imgCol = "image";
  final String maxQtyCol = "quantiteMax";
  final String pIdCol = "id_produit";
  final String idCatCol = "id_categorie";
  final String uIdCol = "id_user";
  final String comCol = "complements";
  final String moduleCol = "module_slug";
  final String prepTimeCol = "temps_preparation";
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'panier.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
// creating database table
  _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE $tableName ($idCol INTEGER PRIMARY KEY ,$textCol TEXT, $priceCol INTEGER , $unitPriceCol INTEGER , $totalPriceCol INTEGER ,$qtyCol INTEGER, $imgCol TEXT,
         $maxQtyCol INTEGER, $pIdCol INTEGER,$idCatCol INTEGER , $uIdCol INTEGER, $comCol TEXT, $moduleCol TEXT,  $prepTimeCol INTEGER)''');
  }
// inserting data into the table
  Future<CartItem1> insert(CartItem1 cart) async {
    var dbClient = await database;
    await dbClient!.insert('carts', cart.toMap());
    return cart;
  }
// getting all the items in the list from the database
  Future<List<CartItem1>> getCartList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
    await dbClient!.query('carts');
    return queryResult.map((result) => CartItem1.fromMap(result)).toList();
  }
  Future<int> updateQuantity(CartItem1 cart) async {
    var dbClient = await database;
    return await dbClient!.update('carts', cart.toMap(),
        where: "productId = ?", whereArgs: [cart.productId]);
  }

// deleting an item from the cart screen
  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('carts', where: 'id = ?', whereArgs: [id]);
  }
}
