
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../constant/app-constant.dart';
import '../data/user_helper.dart';
import 'api_auth_service.dart';

class PaymentApi{
  Map<String, dynamic>? paymentIntentData;
  final logger = Logger();
  final BuildContext context;
  PaymentApi({required this.context});
  Future<void> makePayment({required String amount}) async {
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
            merchantDisplayName: 'ANNIE',
            customerId: paymentIntentData!['customer'],
            customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],)).then((value){
      });


      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {

    try {
      await Stripe.instance.presentPaymentSheet().then((newValue){


        print('payment intent'+paymentIntentData!['id'].toString());
        logger.v('payment intent'+paymentIntentData!['client_secret'].toString());
        print('payment intent'+paymentIntentData!['amount'].toString());
        print('payment intent'+paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Paiement reussir"),
          backgroundColor: Colors.green,
        ));

        paymentIntentData = null;

      }).onError((error, stackTrace){
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });


    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
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
      logger.i(body);
      var response = await post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
            'Bearer $stripeSecret',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      logger.d('Create Intent reponse ===> ${response.body.toString()}');
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