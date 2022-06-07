import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:livraison_express/model/auto_gene.dart';
import 'package:livraison_express/model/module.dart';
import 'package:livraison_express/service/api_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/_module.dart';

class MainApi{

  static Future<List<Module>> getModule({required String city}) async{
    String url = "$baseUrl/preload?city=$city";
    final param={
      'city':city
    };
    Response response = await get(Uri.parse(url),headers: {
      "Accept":"application/json",
      "Content-Type":"application/json"
    });
    if(response.statusCode == 200){
      print('module App Start loading data retrieved successfully');
      var body=json.decode(response.body);
      var rest1 = body['data']['modules'];
      // print("rest 1 $rest1");
      var rest = body['data']['modules'] as List;
      print("rest only  ");
      print('restq ${rest}');
      List<Module> stores;
      var a=List<Module>.from(
          rest1
              .map((data) => Module.fromJson(data))
      );
      print('/////$a');

      stores = rest.map<Module>((json) =>Module.fromJson(json)).toList();
      // print('main ${stores[0]}');
      return stores;
    }else{
      throw Exception('error loading module data');
    }
  }
  static Future<Response> getModuleConfigs({required String city}) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String url = "$baseUrl/preload?city=$city";
    final param={
      'city':city
    };
    Response response = await get(Uri.parse(url),headers: {
      "Accept":"application/json",
      "Content-Type":"application/json",
    });
    try{
      if(response.statusCode == 200){
        return response;
      }else{
        var body=json.decode(response.body);
        var message =body["message"];
        debugPrint('error loading module data');
        throw Exception(message);
      }
    }catch (e) {
      print(e);
      throw e;
    }

  }
  static Future getModule1({required String city}) async{
    String url = "$baseUrl/preload?city=$city";
    final param={
      'city':city
    };
    Response response = await get(Uri.parse(url),headers: {
      "Accept":"application/json",
      "Content-Type":"application/json"
    });
    if(response.statusCode == 200){
      print('module App Start loading data retrieved successfully');
      var body=json.decode(response.body);
      var rest1 = body['data']['modules'];
      // print("rest 1 $rest1");
      var rest = body['data']['modules'] as List;
      print("rest only  ");

      return rest1;
    }else{
      throw Exception('error loading module data');
    }
  }

}