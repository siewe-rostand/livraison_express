import 'package:flutter/material.dart';

class SizeConfig{
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context){
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

double getProportionateScreenHeight(double inputHeight){
  double? screenHeight = SizeConfig.screenHeight;
  return(inputHeight / 812.0) * screenHeight!;
}

double getProportionateScreenWidth(double inputWidth){
  double? screenWidth = SizeConfig.screenWidth;
  return(inputWidth / 375.0) * screenWidth!;
}