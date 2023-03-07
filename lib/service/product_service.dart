import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:livraison_express/model/product.dart';

import 'auth_service.dart';

class ProductService {
  static Future<Map<String, dynamic>> getProducts(
      {required int categoryId, required int shopId, required int page}) async {
    List<Products> products = [];
    String error;
    int lastPage;
    String url = "$baseUrl/produits?page=$page";

    Response response = await post(
      Uri.parse(url),
      body: jsonEncode({"categorie_id": categoryId, "magasin_id": shopId}),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      encoding: Encoding.getByName('utf-8')
    );
    if (response.statusCode == 200) {
      List productList = jsonDecode(response.body)['data'] as List;
      lastPage = jsonDecode(response.body)['last_page'];
      products=productList.map<Products>((json) => Products.fromJson(json)).toList();
      // print('main ${stores[0]}');
      return {
        'products': products,
        'last_page': lastPage,
      };
    } else {
      print('errr ${response.body}');
      throw ('Une erreur est survenu.');
    }
  }
  static Future<Payload> getProducts1(
      {required int categoryId, required int shopId, required int page,bool? isLoading,String? perPage
        // required List<Products> products
      }) async {
    String url = "$baseUrl/produits?page=$page&per_page=$perPage";

    Response response = await post(
      Uri.parse(url),
      body: jsonEncode({"categorie_id": categoryId, "magasin_id": shopId}),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var rest = body['data'] as List;
      var rest1 = body['last_page'];
      perPage =body['per_page'];
      var count = body['count'];
      Payload payload =Payload.fromJson(body);
      if(page<=rest1){
        page++;
      }else{
        page=1;
      }
      print('last page $rest1');
      List<Products> categories=[];

      // categories =
      //     rest.map<Products>((json) => Products.fromJson(json)).toList();

      // print('main ${stores[0]}');
      // categories.insertAll(0, payload.data);
      return payload;
    } else {
      print('errr ${response.body}');
      throw Exception('unable post to obtain products');
    }
  }

  static Future<Response> getProductsWithSubCat(
      {required int categoryId,
      required int subCategoryId,
      required int shopId,
      required int page}) async {
    String url = "$baseUrl/produits?page=$page";

    Response response = await post(
      Uri.parse(url),
      body: jsonEncode({
        "categorie_id": categoryId,
        "sous_categorie_id": subCategoryId,
        "magasin_id": shopId
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 200) {

      return response;
    } else {
      print('errr ${response.body}');
      throw Exception('unable post to obtain products');
    }
  }

  static Future<Response> getProductsWithSubSubCat(
      {required int categoryId,
      required int subSubCategoryId,
      required int subCategoryId,
      required int shopId,
      required int page}) async {
    String url = "$baseUrl/produits?page=$page";

    Response response = await post(
      Uri.parse(url),
      body: jsonEncode({
        "categorie_id": categoryId,
        "sous_categorie_id": subCategoryId,
        "mini_categorie_id": subSubCategoryId,
        "magasin_id": shopId
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      // print('main ${stores[0]}');
      log("message${response.body}");
      return response;
    } else {
      print('errr ${response.body}');
      throw Exception('unable post to obtain products');
    }
  }
}
