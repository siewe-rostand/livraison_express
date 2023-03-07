import 'package:flutter/material.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/model/module_color.dart';

import '../../utils/size_config.dart';

class ProgressBar extends StatelessWidget {
  final ModuleColor? moduleColor;
  const ProgressBar({Key? key,  this.moduleColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: getProportionateScreenWidth(30),
              width: getProportionateScreenWidth(30),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(moduleColor?.moduleColor??primaryColor),
              )
          ),
          SizedBox(height: getProportionateScreenHeight(10),),
          const Text(
            "Chargement en cours...",
            style: TextStyle(
                color: Colors.grey
            ),
          )
        ]
    );
  }
}

class RotationFadeTransitionBuilder extends PageTransitionsBuilder {
  const RotationFadeTransitionBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return _RotationFadeTransitionBuilder(
        routeAnimation: animation, child: child);
  }
}

class _RotationFadeTransitionBuilder extends StatelessWidget {
  _RotationFadeTransitionBuilder({
    Key? key,
    required Animation<double> routeAnimation,
    required this.child,
  })  : _turnsAnimation = routeAnimation.drive(_linearToEaseOut),
        _opacityAnimation = routeAnimation.drive(_easeInTween),
        super(key: key);

  static final Animatable<double> _linearToEaseOut =
  CurveTween(curve: Curves.linearToEaseOut);
  static final Animatable<double> _easeInTween =
  CurveTween(curve: Curves.easeIn);

  final Animation<double> _turnsAnimation;
  final Animation<double> _opacityAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _turnsAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: child,
      ),
    );
  }
}


class ZoomSlideUpTransitionsBuilder extends PageTransitionsBuilder {
  const ZoomSlideUpTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return _ZoomSlideUpTransitionsBuilder(
        routeAnimation: animation, child: child);
  }
}

class _ZoomSlideUpTransitionsBuilder extends StatelessWidget {
  _ZoomSlideUpTransitionsBuilder({
    Key? key,
    required Animation<double> routeAnimation,
    required this.child,
  })  : _scaleAnimation = CurvedAnimation(
    parent: routeAnimation,
    curve: Curves.linear,
  ).drive(_scaleTween),
        _slideAnimation = CurvedAnimation(
          parent: routeAnimation,
          curve: Curves.linear,
        ).drive(_kBottomUpTween),
        super(key: key);

  final Animation<Offset> _slideAnimation;
  final Animation<double> _scaleAnimation;

  static final Animatable<double> _scaleTween =
  Tween<double>(begin: 0.0, end: 1);
  static final Animatable<Offset> _kBottomUpTween = Tween<Offset>(
    begin: const Offset(0.0, 1.0),
    end: const Offset(0.0, 0.0),
  );

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: child,
      ),
    );
  }
}