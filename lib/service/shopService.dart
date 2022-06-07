
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:livraison_express/model/auto_gene.dart';
import 'package:livraison_express/model/category.dart';
import 'package:livraison_express/model/magasin.dart';

import 'api_auth_service.dart';

class ShopServices{

  static Future<List<Shops>> getCategoriesFromShop({required int? shopId}) async{
    String url = "$baseUrl/magasins/?shopId=$shopId/categories";
    Response response = await get(Uri.parse(url),headers: {
      "Accept":"application/json",
      "Content-Type":"application/json",
      "Origin":origin
    });
    if(response.statusCode == 200){
      print('module App Start loading data retrieved successfully');
      var body=json.decode(response.body);
      var rest = body['data'] as List;
      print("rest only  ");
      // print('restq ${rest}');
      List<Shops> shops;

      shops = rest.map<Shops>((json) =>Shops.fromJson(json)).toList();
      // print('main ${stores[0]}');
      return shops;
    }else{
      throw Exception('error loading module data');
    }
  }

  static Future<List<Category>> getCategories({required int shopId})async{
    String url = "$baseUrl/magasins/$shopId/categories";
    Response response = await get(Uri.parse(url),headers: {
      "Accept":"application/json",
      "Content-Type":"application/json",
      "Origin":origin
    });
    if(response.statusCode == 200){
      print('module App Start loading data retrieved successfully');
      var body=json.decode(response.body);
      var rest = body['data'] as List;
      // print("rest only  ");
      // debugPrint('category ${rest}');
      List<Category> categories;

      categories = rest.map<Category>((json) =>Category.fromJson(json)).toList();
      // print('main ${stores[0]}');
      return categories;
    }else{
      throw Exception('error loading module data');
    }
  }
  static Future<List<Category>> getSubCategoriesFromShopAndCategory({required int shopId,required int categoryId}) async{
    String url = "$baseUrl/magasins/$shopId/categories/$categoryId/categories";
    Response response = await get(Uri.parse(url),headers: {
      "Accept":"application/json",
      "Content-Type":"application/json",
      "Origin":origin
    });

    if(response.statusCode == 200){
      print('module App Start loading data retrieved successfully');
      var body=json.decode(response.body);
      var rest = body['data'] as List;
      print("rest only  ");
      // print('restq ${rest}');
      List<Category> categories;

      categories = rest.map<Category>((json) =>Category.fromJson(json)).toList();
      // print('main ${stores[0]}');
      return categories;
    }else{
      throw Exception('error loading module data from getSubCategoriesFromShopAndCategory');
    }
  }
  static Future<List<Category>> getMiniCategories({required int shopId,required int ids}) async{
    String url = "$baseUrl/magasins/$shopId/categories/$ids/categories";
    Response response = await get(Uri.parse(url),headers: {
      "Accept":"application/json",
      "Content-Type":"application/json",
      "Origin":origin
    });

    if(response.statusCode == 200){
      print('module App Start loading data retrieved successfully');
      var body=json.decode(response.body);
      var rest = body['data'] as List;
      print("rest only  ");
      // print('restq ${rest}');
      List<Category> categories;

      categories = rest.map<Category>((json) =>Category.fromJson(json)).toList();
      // print('main ${stores[0]}');
      return categories;
    }else{
      throw Exception('error loading module data from getMiniCategories');
    }
  }
  static Future<List<Magasin>> getShops({required int moduleId, required String city,
    required double latitude,required double longitude,
    required int inner_radius,
    required int outer_radius
  })async{
    String url = "$baseUrl/magasins/search/nearby";
    Response response = await post(
      Uri.parse(url),
      body: jsonEncode({
        "token": token,
        "city": city,
        "module_id": moduleId,
        "latitude": latitude,
        "longitude": longitude,
        "inner_radius": inner_radius,
        "outer_radius": outer_radius,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Origin":origin
      },
    );
    if(response.statusCode == 200){
      var body=jsonDecode(response.body);
      var rest = body['data'];
      print(rest);
      List<Magasin> magasins;
      magasins =rest.map<Magasin>((json) =>Magasin.fromJson(json)).toList();
      return magasins;
    }else{
      throw Exception('et shops error');
    }

  }
}