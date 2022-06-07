import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:livraison_express/model/product.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'api_auth_service.dart';

class ProductService {
  final RefreshController refreshController =
  RefreshController(initialRefresh: true);
  static Future<List<Products>> getProducts(
      {required int categoryId, required int shopId, required int page,bool? isLoading }) async {
    String url = "$baseUrl/produits?page=$page";

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
      List<Products> categories;

      categories =
          rest.map<Products>((json) => Products.fromJson(json)).toList();
      print("rest only  ");
      // print('main ${stores[0]}');
      return categories;
    } else {
      print('errr ${response.body}');
      throw Exception('unable post to obtain products');
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

  static Future<List<Products>> getProductsWithSubCat(
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
      var body = json.decode(response.body);
      var rest = body['data'] as List;
      List<Products> categories;

      categories =
          rest.map<Products>((json) => Products.fromJson(json)).toList();
      print("rest only  ");
      // print('main ${stores[0]}');
      return categories;
    } else {
      print('errr ${response.body}');
      throw Exception('unable post to obtain products');
    }
  }

  static Future<List<Products>> getProductsWithSubSubCat(
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
      var body = json.decode(response.body);
      var rest = body['data'] as List;
      List<Products> products;

      products = rest.map<Products>((json) => Products.fromJson(json)).toList();
      print("rest only  ");
      // print('main ${stores[0]}');
      return products;
    } else {
      print('errr ${response.body}');
      throw Exception('unable post to obtain products');
    }
  }
}
