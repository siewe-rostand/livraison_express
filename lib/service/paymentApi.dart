
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../constant/app-constant.dart';
import '../data/user_helper.dart';
import 'auth_service.dart';

class PaymentApi{
  Map<String, dynamic>? paymentIntentData;
  final logger = Logger();
  final BuildContext context;
  PaymentApi({required this.context});
   makePayment({required String amount}) async {
    try {

      paymentIntentData =
      await createPaymentIntent(amount, 'XAF'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            applePay: true,
            googlePay: true,
            testEnv: true,
            style: ThemeMode.dark,
            merchantCountryCode: 'US',
            merchantDisplayName: 'ROSTAND',
            customerId: paymentIntentData!['customer'],
            customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],));
      ///now finally display payment sheeet
      displayPaymentSheet();
      // log("$paymentIntentData");
      return paymentIntentData;
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {

    try {
      await Stripe.instance.presentPaymentSheet();


    } on StripeException catch (e) {
      logger.e('Exception/DISPLAYPAYMENTSHEET==> $e');
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: const Text("Paiement annulé"),
        backgroundColor: Colors.redAccent.shade200,
      ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
            'Bearer $stripeSecret',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      // logger.d('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      logger.e('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    var db =double.parse(amount);
    final a = db.toInt();
    return a.toString();
  }

  Future<Map<String, dynamic>> createTestPaymentSheet({required String amount}) async {
    final url = Uri.parse('$baseUrl/checkout/user/intent');
    final response = await post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "Authorization":{UserHelper.token},
        "amount":amount
      }),
    );
    final body = json.decode(response.body);

    if (body['error'] != null) {
      throw Exception('Error code: ${body['error']}');
    }

    return body;
  }
}