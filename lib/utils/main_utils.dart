import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livraison_express/utils/size_config.dart';

import '../constant/color-constant.dart';
import '../data/user_helper.dart';

const onFailureMessage =
    "Veuillez vérifier votre connexion internet puis réessayez. Si le problème persiste, veuillez contacter le service technique.";
const onErrorMessage =
    "Nous rencontrons actuellement des problèmes lies à cette opération. Veuillez réessayer plus tard ou contactez le service technique.";
const onLoginInvalidDate =
    "Une erreur est survenu. Veuillez verifier votre Numero de telephone ou le mot de passe";
const noPhoneNumberUser =
    "Aucun utilisateur avec ce numéro de téléphone n'a été trouvé. veuillez vous connecter avec un e-mail ou créer un nouveau compte si ce n'est pas encore fait";
ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: kGrey5,
    primaryColor: primaryColor,
    fontFamily: "Muli",
    textTheme: textTheme(),
    appBarTheme: appBarTheme(),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: primaryColorDark,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  );
}

TextTheme textTheme() {
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
ButtonStyle primaryButtonStyle() => ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    )),
    backgroundColor: MaterialStateProperty.all(primaryColor));

ButtonStyle loginButtonStyle() => ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    )));

InputDecoration inputDecoration(
    {required String labelText, Widget? suffixIcon}) {
  return InputDecoration(
      labelText: labelText,
      contentPadding: EdgeInsets.all(10.r),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      suffixIcon: suffixIcon);
}

BoxDecoration containerDecoration() {
  return BoxDecoration(
      color: UserHelper.getColor(),
      border: Border.all(color: primaryColor, width: 1.5),
      borderRadius: BorderRadius.circular(getProportionateScreenHeight(25)));
}

class MainUtils {
  static hideKeyBoard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
  }
}
