import 'package:flutter/material.dart';

import '../constant/color-constant.dart';

 const onFailureMessage =
    "Veuillez vérifier votre connexion internet puis réessayez. Si le problème persiste, veuillez contacter le service technique.";
 const onErrorMessage="Nous rencontrons actuellement des problèmes lies à cette opération. Veuillez réessayer plustard ou contactez le service technique.";

ThemeData theme(){
  return ThemeData(
    scaffoldBackgroundColor: kGrey5,
    primaryColor: primaryColor,
    fontFamily: "Muli",
    textTheme: textTheme(),
    appBarTheme: appBarTheme(),
  );
}
/// Bold text style - w700
TextStyle boldTextStyle(
    double size, {
      Color? color,
      double? height,
      String? fontFamily,
    }) =>
    thinTextStyle(size, color: color, height: height).copyWith(
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
    );
/// Thin text style - w100
TextStyle thinTextStyle(
    double size, {
      Color? color,
      double? height,
      String? fontFamily,
    }) =>
    TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w100,
      fontFamily: fontFamily,
      color: color,
      height: height,
    );

AppBarTheme appBarTheme(){
  return const AppBarTheme(
    color: primaryColorDark,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
        headline6: TextStyle(color: Colors.white, fontSize: 18)
    ),
  );
}

TextTheme textTheme(){
  return const TextTheme(
    bodyText1: TextStyle(color: kTextColor),
    bodyText2: TextStyle(color: kTextColor),
  );
}

class MainUtils {
  static hideKeyBoard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
  }


}
