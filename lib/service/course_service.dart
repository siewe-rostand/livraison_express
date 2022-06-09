import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import 'api_auth_service.dart';

class CourseApi {
  static Future<Response> getOrders() async {
    String url = '$baseUrl/user/delivery';
    Response response = await get(Uri.parse(url), headers: {
      "Authorization": 'Bearer $token',
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Origin": origin
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

  static Future<Response> calculateOrderDistance({
    required String origin,
    required String destination,
  }) async {
    String url = '$baseUrl/external/google/distancematrix';
    Response response = await post(
      Uri.parse(url),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'origin': origin,
        'destination': destination,
      }),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      // var res = body['data'];
      // AppUser appUsers=AppUser.fromJson(res);
      return response;
    } else {
      var body = json.decode(response.body);
      print("+++ ${response.body}");
      var mes = body['message'];
      if (response.statusCode == 401) {
        throw Exception(mes);
      } else if (response.statusCode == 404 ||
          response.statusCode == 422 ||
          response.statusCode == 400 ||
          response.statusCode == 499) {
        throw Exception(mes);
      }
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw Exception("error calculating order distance");
    }
  }

  static Future<Response> commnander({
    required Map data
  }) async {
    String url = '$baseUrl/user/delivery';
    Response response = await post(
      Uri.parse(url),
      headers: <String, String>{
        "Authorization": 'Bearer $token',
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Origin": origin
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      // var res = body['data'];
      // AppUser appUsers=AppUser.fromJson(res);
      return response;
    } else {
      var body = json.decode(response.body);
      print("+++ ${response.statusCode} ${response.body}");
      var mes = body['message'];
      if (response.statusCode == 401) {
        throw Exception(mes);
      } else if (response.statusCode == 404 ||
          response.statusCode == 422 ||
          response.statusCode == 400 ||
          response.statusCode == 499) {
        throw Exception(mes);
      }
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw Exception("error calculating order distance");
    }
  }
}
