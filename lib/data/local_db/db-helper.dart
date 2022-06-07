import 'package:livraison_express/model/cart-model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper{
  final String tableName ='cart';
  final String idCol = "id";
  final String textCol = 'title';
   final String libelleCol = "libelle";
   final String unitPriceCol = "prix_unitaire";
   final String priceCol = "price";
   final String totalPriceCol = "prix_total";
   final String qtyCol = "quantity";
   final String qteCol = "quantite";
   final String imgCol = "image";
   final String maxQtyCol = "quantiteMax";
   final String pIdCol = "id_produit";
   final String idCatCol = "id_categorie";
   final String uIdCol = "id_user";
   final String comCol = "complements";
   final String moduleCol = "module_slug";
   final String prepTimeCol = "temps_preparation";
  Database? _db ;

  Future<Database> get db async {
    return _db ??= await initDatabase();
  }


  initDatabase()async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory() ;
    String path = join(documentDirectory.path , 'carts.db');
    var db = await openDatabase(path , version: 1 , onCreate: _onCreate,);
    return db ;
  }

  _onCreate (Database db , int version )async{
    await db
        .execute('''CREATE TABLE $tableName ($idCol INTEGER PRIMARY KEY ,$textCol TEXT,$qtyCol INTEGER, $priceCol INTEGER , $imgCol TEXT )''');
  }

  Future<CartItem> insert(CartItem cartItem)async{
    print("Cart items ${cartItem.toMap()}");
    var dbClient = await db ;
    // await dbClient.insert(tableName, cartItem.toMap());
    var batch=dbClient.batch();
    batch.insert(tableName, cartItem.toMap());
    await batch.commit(noResult: true);
    return cartItem ;
  }
  Future<List<CartItem>> getCartList()async{
    var dbClient = await db ;
    var batch=dbClient.batch();
    final List<Map<String , Object?>> queryResult =  await dbClient.query(tableName);
    return queryResult.map((e) => CartItem.fromMap(e)).toList();

  }

  Future<int> delete(int id)async{
    var dbClient = await db ;
    return await dbClient.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id]
    );
  }

  Future<int> updateQuantity(CartItem cart)async{
    var dbClient = await db ;
    return await dbClient.update(
        tableName,
        cart.toMap(),
        where: 'id = ?',
        whereArgs: [cart.id]
    );
  }
  Future deleteAll()async{
    var dbClient =await db;
    dbClient.delete(tableName);
  }
}