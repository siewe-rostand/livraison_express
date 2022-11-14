import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';


class MainApi{
  final logger = Logger();
 getPaymentIntentClientSecret({required String token,required String amount}) async {
  String url = 'https://api.staging.livraison-express.net/api/v1.1/checkout/user/intent';
  Response response = await post(Uri.parse(url),
    headers: <String, String>{
      "Accept":"application/json",
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      "Authorization":token,
      "amount":amount
    }),
  );
  if (response.statusCode == 200) {
    var body = json.decode(response.body);
    logger.d(body);
    return response;
  } else {
    var body = json.decode(response.body);
    var res = body['data'];
    debugPrint("${response.statusCode}$res");
    var mes =body['message'];
    debugPrint('ERROR MESSAGE ${body['message']}');
    throw Exception(mes);
  }
}

}