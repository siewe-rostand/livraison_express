import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../model/address.dart';
import 'api_auth_service.dart';

class FavoriteAddressApi{
  final logger = Logger();

  Future<List<Adresse>> getAddresses(String accessToken) async {
    List<Adresse> addressList = [];
    String url = "$baseUrl/user/adresses";
    final headers = {
      'Accept': 'application/json',
      'Authorization': accessToken
    };
    final response = await get(
        Uri.parse(url),
        headers: headers
    );
    if (response.statusCode == 200) {
      List addresses = jsonDecode(response.body)['data'] as List;
      addresses.map((json) =>Adresse.fromJson(json)).toList();
    } else {
      logger.e(response.body);
    }
    return addressList;
  }
  static Future<Response> getAddressList() async {
    String url = '$baseUrl/user/adresses';
    Response response = await get(Uri.parse(url), headers: {
      "Authorization": 'Bearer $token',
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      // var res = body['data'];
      // AppUser1 appUsers=AppUser1.fromJson(res);
      //
      //
      // print('user body ${appUsers.telephone}');
      // return appUsers;
      return response;
    } else {
      var body = json.decode(response.body);
      print(response.body);
      var message = body['message'];
      throw Exception(message);
    }
  }

  static Future<Response> create({
    required int clientId,required double latitude,required double longitude,
    required String quartier,required String nom,required String surnom,
    required String description,required String ville,required int villeId,
    required String providerId,required String providerName,required int isFavorite,
  }) async {
    String url = '$baseUrl/v1.1/adresses';
    Response response = await post(
      Uri.parse(url),
      headers: <String, String>{
        "Authorization": 'Bearer $token',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'client_id': clientId.toString(),'latitude': latitude.toString(),'longitude': longitude.toString(),'quartier': quartier,
        'nom': nom,'surnom': surnom,'description': description,'ville': ville,
        'ville_id': villeId.toString(),'provider_id': providerId,'provider_name': providerName,'est_favorite': isFavorite.toString(),
      }),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      // var res = body['data'];
      // AppUser appUsers=AppUser.fromJson(res);
      return response;
    } else {
      var body = json.decode(response.body);
      print("+++ ${response.statusCode}");
      var mes = body['message'];
      if (response.statusCode == 401) {
        throw Exception(mes);
      } else if (response.statusCode == 404 ||
          response.statusCode == 422 ||
          response.statusCode == 400 ||
          response.statusCode == 499) {
        throw Exception(mes);
      }
      debugPrint('ERROR MESSAGE saving fav address\n ${body['message']}');
      throw Exception("error calculating order distance");
    }
  }
}