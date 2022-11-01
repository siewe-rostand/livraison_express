
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
  final String imgCol = "image";
  final String maxQtyCol = "quantiteMax";
  final String pIdCol = "id_produit";
  final String idCatCol = "id_categorie";
  final String uIdCol = "id_user";
  final String comCol = "complements";
  final String moduleCol = "module_slug";
  final String prepTimeCol = "temps_preparation";
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
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
         $maxQtyCol INTEGER, $pIdCol INTEGER UNIQUE,$idCatCol INTEGER , $uIdCol INTEGER, $comCol TEXT, $moduleCol TEXT,  $prepTimeCol INTEGER)''');
  }
// inserting data into the table
  Future<CartItem1> insert(CartItem1 cart) async {
    var dbClient = await database;
    cart.id= await dbClient.insert(tableName, cart.toMap());
    return cart;
  }
// getting all the items in the list from the database
  Future<List<CartItem1>> getCartList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
    await dbClient.query(tableName);
    return queryResult.map((result) => CartItem1.fromMap(result)).toList();
  }
  Future<int> updateQuantity(CartItem1 cart) async {
    var dbClient = await database;
    return await dbClient.update(tableName, cart.toMap(),
        where: "id_produit = ?", whereArgs: [cart.productId]);
  }

// deleting an item from the cart screen
  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
  Future deleteAll() async {
    var dbClient = await database;
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
  final String imgCol = "image";
  final String maxQtyCol = "quantiteMax";
  final String pIdCol = "id_produit";
  final String idCatCol = "id_categorie";
  final String uIdCol = "id_user";
  final String comCol = "complements";
  final String moduleCol = "module_slug";
  final String prepTimeCol = "temps_preparation";

  static Database? _db ;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase()async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory() ;
    String path = join(documentDirectory.path , 'cart.db');
    var db = await openDatabase(path , version: 1 , onCreate: _onCreate,);
    return db ;
  }

  // creating database table
  _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE $tableName ($idCol INTEGER PRIMARY KEY ,$textCol TEXT, $priceCol INTEGER , $unitPriceCol INTEGER , $totalPriceCol INTEGER ,$qtyCol INTEGER, $imgCol TEXT,
         $maxQtyCol INTEGER, $pIdCol INTEGER UNIQUE,$idCatCol INTEGER , $uIdCol INTEGER, $comCol TEXT, $moduleCol TEXT,  $prepTimeCol INTEGER)''');
  }

  Future<CartItem1> insert(CartItem1 cart)async{
    print(cart.toMap());
    var dbClient = await db ;
    await dbClient.insert(tableName, cart.toMap());
    return cart ;
  }

  Future<List<CartItem1>> getCartList()async{
    var dbClient = await db ;
    final List<Map<String , Object?>> queryResult =  await dbClient.query(tableName);
    return queryResult.map((e) => CartItem1.fromMap(e)).toList();

  }

  Future<int> delete(int id)async{
    var dbClient = await db ;
    return await dbClient.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id]
    );
  }

  Future<int> updateQuantity(CartItem1 cart)async{
    var dbClient = await db ;
    return await dbClient.update(
        tableName,
        cart.toMap(),
        where: 'id = ?',
        whereArgs: [cart.id]
    );
  }
  Future deleteAll() async {
    var dbClient =  await db;
    dbClient.delete(tableName);
  }
}