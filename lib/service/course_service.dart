import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/main_utils.dart';
import 'api_auth_service.dart';

class CourseApi {
  final logger  =Logger();
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

   Future<Response> calculateDeliveryDistance({
    required String origin,
    required String destination,
  }) async {
    String url = '$baseUrl/external/google/distancematrix';
    Response response = await post(
      Uri.parse(url),
      headers: <String, String>{
        "Authorization": 'Bearer $token',
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
      logger.e("+++ ${response.body}");
      var mes = body['message'];
      if (response.statusCode == 401) {
        throw Exception(onErrorMessage);
      } else if (response.statusCode == 404 ||
          response.statusCode == 422 ||
          response.statusCode == 400 ||
          response.statusCode == 499) {
        throw Exception(onErrorMessage);
      }
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw Exception(onFailureMessage);
    }
  }

   Future<Response> calculateOrderDistance({
    required String origin,
    required String destination,
    required String module,
    required String magasin,
    required int amount,
  }) async {
    String url = '$baseUrl/external/google/distancematrix';
    Response response = await post(
      Uri.parse(url),
      headers: <String, String>{
        "Authorization": 'Bearer $token',
        "Accept": "application/json",
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'origin': origin,
        'destination': destination,
        'module': module,
        'magasin': magasin,
        'cart_amount': amount.toString(),
      }),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      // var res = body['data'];
      // AppUser appUsers=AppUser.fromJson(res);
      return response;
    } else {
      var body = json.decode(response.body);
      logger.e("+++${response.statusCode}");
      var mes = body['message'];
      if (response.statusCode == 401) {
        throw onFailureMessage;
      } else if (response.statusCode == 404 ||
          response.statusCode == 422 ||
          response.statusCode == 400 ||
          response.statusCode == 499) {
        throw onFailureMessage;
      }
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw (onErrorMessage);
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
        throw (mes);
      } else if (response.statusCode == 404 ||
          response.statusCode == 422 ||
          response.statusCode == 400 ||
          response.statusCode == 499) {
        throw (mes);
      }
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw ("error calculating order distance");
    }
  }

   Future<Response> commnander2({
    required Map data
  }) async {
    String url = '$baseUrl/user/purchases';
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
      var mes = body['message'];
      logger.e("+++ ${response.body}+ ${response.statusCode}");
      if (response.statusCode == 401 || response.statusCode ==400) {
        throw (onErrorMessage);
      } else if (response.statusCode == 404 ||
          response.statusCode == 422 ||
          response.statusCode == 400 ||
          response.statusCode == 499) {
        throw (onErrorMessage);
      }
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw (onFailureMessage);
    }
  }
}
