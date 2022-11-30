
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/model/quartier.dart';
import 'package:livraison_express/utils/main_utils.dart';
import 'package:livraison_express/views/splash-screen.dart';
import 'package:livraison_express/views/super-market/cart-provider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await Firebase.initializeApp();
  Stripe.publishableKey = stripePublishableKey;

  await Stripe.instance.applySettings();
  runApp(
      const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=>CartProvider()),
      ChangeNotifierProvider(create: (context)=>QuarterProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Livraison Express',
      theme: theme().copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder()
          },
        )
      ),
      home: const SplashScreen(),
    ),);
  }
}
