import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livraison_express/model/user.dart';
import 'package:livraison_express/service/main_api_call.dart';
import 'package:livraison_express/views/main/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/auto_gene.dart';
import '../service/api_auth_service.dart';
import 'home-page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeInFadeOut;
  getUserInfo(bool fromFb) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppUser1 appUser1 = await ApiAuthService.getUser();
    debugPrint("login user ${appUser1.emailVerifiedAt}");
    String fullName = appUser1.fullname ?? '';
    String phone = appUser1.telephone ?? '';
    String? phoneVerifiedAt =appUser1.phoneVerifiedAt;
    String? emailVerifiedAt =appUser1.emailVerifiedAt;
    if(!fromFb && phoneVerifiedAt!.isNotEmpty && emailVerifiedAt!.isNotEmpty){

    }
    }
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
            () async{
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) =>  const LoginScreen()));});
    animationController = AnimationController(vsync: this,duration: const Duration(seconds: 2));
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
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              child: Image.asset('img/logo.png'),
              opacity: fadeInFadeOut,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(
                  semanticsValue: 'chargement en cours',
                ),
                Text('chargement en cours')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
/*
AnimatedSplashScreen(
      splash: 'img/logo.png',
      duration: 2500,
      animationDuration: const Duration(milliseconds: 2500),
      nextScreen: const HomePage(),
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.topToBottom,
    )
 */
