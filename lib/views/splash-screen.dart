import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/utils/asset_manager.dart';
import 'package:livraison_express/views/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/user_helper.dart';
import '../service/auth_service.dart';
import '../utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeInFadeOut;
  fetchConnectionState(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString(UserHelper.token);
    if (token != null) {
      // await Firebase.initializeApp();
      ApiAuthService(context: context, fromLogin: false).getUserProfile(token);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      fetchConnectionState(context);
    });
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    fadeInFadeOut = Tween(begin: 0.0, end: 0.5).animate(animationController);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: primaryColor),
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: FadeTransition(
                child: Image.asset(AssetManager.logo),
                opacity: fadeInFadeOut,
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(
                    semanticsValue: 'chargement en cours',
                  ),
                  Text('chargement en cours ..')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
