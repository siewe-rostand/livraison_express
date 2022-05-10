import 'dart:async';

import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
            () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => const HomePage())));
    animationController = AnimationController(vsync: this,duration: const Duration(seconds: 3));
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
            child:  const CircularProgressIndicator(
              semanticsValue: 'chargement en cours',
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
