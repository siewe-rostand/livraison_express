import 'dart:convert';

import 'package:http/http.dart';
import 'package:livraison_express/model/address.dart';
import 'package:logger/logger.dart';

import 'auth_service.dart';

class AddressService{
  final logger = Logger();


  Future<Response>getAddressList()async {
    String url = '$baseUrl/user/adresses';
    Response response = await get(Uri.parse(url), headers: {
      "Authorization": 'Bearer $token',
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      return response;
    } else {
      var body = json.decode(response.body);
      print(response.body);
      var message = body['message'];
      throw Exception(message);
    }
  }


  Future<Response> updateAddress({required Address address}) async {
    var data ={
      'client_id': address.clientId,
      'latitude': address.latitude,
      'longitude': address.longitude,
      'nom': address.nom,
      'quartier': address.quarter,
      'description': address.description,
      'surnom': address.surnom,
    };
    String url = "$baseUrl/adresses/${address.id}";
    Response response = await put(
      Uri.parse(url),
      body: json.encode(data),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Origin": origin,
        "Authorization": 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // print("/// ${response.body}");
      return response;
    } else {
      logger.e(response.body);
      throw ('edit error//');
    }
  }

  static Future<Response> deleteAddress({required int id}) async {
    String url = '$baseUrl/adresses/$id';
    Response response = await delete(Uri.parse(url), headers: {
      "Authorization": 'Bearer $token',
      "Accept": "application/json",
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      return response;
    } else {
      var body = json.decode(response.body);
      print(response.body);
      var message = body['message'];
      throw Exception(message);
    }
  }
}