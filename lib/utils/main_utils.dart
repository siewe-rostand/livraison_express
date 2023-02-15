import 'package:flutter/material.dart';

import '../constant/color-constant.dart';

 const onFailureMessage =
    "Veuillez vérifier votre connexion internet puis réessayez. Si le problème persiste, veuillez contacter le service technique.";
 const onErrorMessage="Nous rencontrons actuellement des problèmes lies à cette opération. Veuillez réessayer plus tard ou contactez le service technique.";
 const onLoginInvalidDate = "Une erreur est survenu. Veuillez verifier votre Numero de telephone ou le mot de passe";
 const noPhoneNumberUser = "Aucun utilisateur avec ce numéro de téléphone n'a été trouvé. veuillez vous connecter avec un e-mail ou créer un nouveau compte si ce n'est pas encore fait";
ThemeData theme(){
  return ThemeData(
    scaffoldBackgroundColor: kGrey5,
    primaryColor: primaryColor,
    fontFamily: "Muli",
    textTheme: textTheme(),
    appBarTheme: appBarTheme(),
  );
}

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

class MainUtils {
  static hideKeyBoard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
  }


}
