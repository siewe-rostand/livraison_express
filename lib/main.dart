
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:livraison_express_client/provider/cart-provider.dart';
import 'package:livraison_express_client/utils/main_utils.dart';
import 'package:livraison_express_client/views/splash-screen.dart';
import 'package:provider/provider.dart';

import 'constant/app-constant.dart';
import 'model/quartier.dart';

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
    child: ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Livraison Express',
          theme: theme().copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android: ZoomPageTransitionsBuilder()
                },
              )
          ),
          home: child,
        );
      },
      child:  const SplashScreen(),
    ),);
  }
}
