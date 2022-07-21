import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/user.dart';
import 'package:livraison_express/service/api_auth_service.dart';
import 'package:livraison_express/service/main_api_call.dart';
import 'package:livraison_express/views/widgets/widgets.dart';
import 'package:http/http.dart' as http;
class StripeCheckoutDialog extends StatefulWidget {
  final String amount;
  const StripeCheckoutDialog({Key? key, required this.amount}) : super(key: key);

  @override
  State<StripeCheckoutDialog> createState() => _StripeCheckoutDialogState();
}

class _StripeCheckoutDialogState extends State<StripeCheckoutDialog> {
   CardFieldInputDetails? _inputDetails;
   bool ? _saveCard;
   String paymentIntentClientSecret='';

   Future<void> handlePayment() async {
     AppUser1? appUser1=UserHelper.currentUser1;
     String clientSecret;
// 1. fetch Intent Client Secret from backend
    await MainApi().getPaymentIntentClientSecret(token: appUser1!.token!, amount: widget.amount).then((response){
      var body = json.decode(response.body);
      var data=body['data'];
      paymentIntentClientSecret=data['client_secret'];
     });

// 2. Gather customer billing information (ex. email)
     final billingDetails = BillingDetails(
       email: appUser1.email,
       phone: appUser1.telephone,
     ); // mo mocked data for tests

// 3. Confirm payment with card details
// The rest will be done automatically using webhooks
// ignore: unused_local_variable
     final paymentIntent = await Stripe.instance.confirmPayment(
       paymentIntentClientSecret,
       PaymentMethodParams.card(
         paymentMethodData: PaymentMethodData(
           billingDetails:billingDetails
         ),
         options: PaymentMethodOptions(
           setupFutureUsage:
           _saveCard == true ? PaymentIntentsFutureUsage.OffSession : null,
         )
       ),
     );
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CardField(
            onCardChanged: (card){
              setState(() {
                _inputDetails=card;
              });
            },
          ),
          ElevatedButton(onPressed: handlePayment, child:const Text('pay'))
        ],
      ),
    );
  }
}


class PaymentSheetScreenWithCustomFlow extends StatefulWidget {
  const PaymentSheetScreenWithCustomFlow({Key? key, required this.amount}) : super(key: key);
  final String amount;

  @override
  _PaymentSheetScreenState createState() => _PaymentSheetScreenState();
}

class _PaymentSheetScreenState extends State<PaymentSheetScreenWithCustomFlow> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Payment Sheet',
      tags: const ['Custom Flow'],
      children: [
        Stepper(
          controlsBuilder: emptyControlBuilder,
          currentStep: step,
          steps: [
            Step(
              title: Text('Init payment'),
              content: LoadingButton(
                onPressed: initPaymentSheet,
                text: 'Init payment sheet',
              ),
            ),
            Step(
              title: Text('Select payment method'),
              content: LoadingButton(
                onPressed: presentPaymentSheet,
                text: 'Select payment method',
              ),
            ),
            Step(
              title: Text('Confirm payment'),
              content: LoadingButton(
                onPressed: confirmPayment,
                text: 'Pay now',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final data = await createTestPaymentSheet();

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Enable custom flow
          customFlow: true,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: data['paymentIntent'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['customer'],
          // Extra options
          testEnv: true,
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          merchantCountryCode: 'DE',
        ),
      );
      setState(() {
        step +=1;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> presentPaymentSheet() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      setState(() {
        step = 2;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment option selected'),
        ),
      );
    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unforeseen error: ${e}'),
          ),
        );
      }
    }
  }

  Future<void> confirmPayment() async {
    try {
      // 4. Confirm the payment sheet.
      await Stripe.instance.confirmPaymentSheetPayment();

      setState(() {
        step = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment succesfully completed'),
        ),
      );
    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unforeseen error: ${e}'),
          ),
        );
      }
    }
  }

  Future<Map<String, dynamic>> createTestPaymentSheet() async {
    final url = Uri.parse('$baseUrl/checkout/user/intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "Authorization":token,
        "amount":widget.amount
      }),
    );
    final body = json.decode(response.body);

    if (body['error'] != null) {
      throw Exception('Error code: ${body['error']}');
    }

    return body;
  }
}

final ControlsWidgetBuilder emptyControlBuilder = (_, __) => Container();

