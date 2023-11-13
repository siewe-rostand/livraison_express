import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/model/category.dart';
import 'package:livraison_express/model/user.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/city.dart';
import '../model/module.dart';
import '../model/shop.dart';
import '../views/widgets/custom_alert_dialog.dart';

showGenDialog(context, dismissible, dialog) => showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 800),
    transitionBuilder: (context, a1, a2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
            parent: a1,
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeOutCubic),
        child: dialog,
      );
    },
    pageBuilder: (BuildContext context, Animation anim, Animation secondAnim) {
      return Container();
    });

ProgressDialog getProgressDialog(
    {required BuildContext context,
    String message = "Chargement en cours..."}) {
  ProgressDialog progressDialog = ProgressDialog(context,
      type: ProgressDialogType.normal, isDismissible: false, showLogs: true);

  progressDialog.style(
      message: message,
      messageTextStyle: TextStyle(color: Colors.grey[800]),
      borderRadius: 5);

  return progressDialog;
}

void showMessage({
  required BuildContext context,
  String? errorMessage,
  String? title,
  String? positiveText,
  String? negativeText,
}) {
  showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return AlertDialog(
          title: Text(title ?? ""),
          content: Text(errorMessage ?? ""),
          actions: [
            TextButton(
              child: Text(positiveText ?? ""),
              onPressed: () async {
                Navigator.of(builderContext).pop();
              },
            ),
            TextButton(
              child: Text(negativeText ?? ""),
              onPressed: () async {
                Navigator.of(builderContext).pop();
              },
            )
          ],
        );
      });
}

showToast(
    {required BuildContext context,
    required String text, IconData? iconData,
      ToastGravity? gravity, Color? color}) {
  Fluttertoast.showToast(msg: text,backgroundColor: color ?? UserHelper.getColor(),gravity:gravity ?? ToastGravity.BOTTOM);
}
showError({required String title, required String message,required BuildContext context,
    String icon = 'img/icon/svg/alert_round.svg'}) {
  UserHelper.userExitDialog(
      context,
      false,
      CustomAlertDialog(
        title: title,
        message: message,
        svgIcon: icon,
        positiveText: 'Fermer',
        onContinue: () {
          Navigator.pop(context);
        },
      ));
}
errorDialog({required BuildContext context,required String title,required String message,required Function() onTap}){
  return showDialog(
      context: context,
      builder: (BuildContext builderContext){
        return AlertDialog(
          content: Text(message),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(FontAwesomeIcons.triangleExclamation,color: Color(0xffFFAE42),),
              const SizedBox(
                width: 10,
              ),
              Text(title),
            ],
          ),
          actions: [
            TextButton(
              child:  const Text("Annuler"),
              onPressed: (){
                Navigator.of(builderContext).pop();
              },
            ),
            TextButton(
              child:  const Text("OK"),
              onPressed:onTap,
            )
          ],
        );
      }
  );
}
class UserHelper {
  static const kPrimaryColor = Color(0xFF2A5CA8);
  static AppUser1? currentUser1 = AppUser1();
  static String token = "accessToken";
  static String chooseTime = "";
  static String selectedFavAdd = "";
  static City city = City();
  static int cartNewPrice = 0;
  static String selectCity = '';
  static List<String> quarters = [];
  static bool isTodayOpen = false;
  static bool isTomorrowOpen = false;

  static Shops shops = Shops();
  static Modules module = Modules();
  static Category category = Category();

  static getCity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String city = pref.getString('city') ?? "DOUALA";
    return city;
  }

  static getCurrentUser() async {
    AppUser1? appUser1 = AppUser1();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userString = sharedPreferences.getString("userData");
    final extractedUserData = json.decode(userString!);
    appUser1 = AppUser1.fromJson(extractedUserData);
    return appUser1;
  }

  static userExitDialog(context, dismissible, dialog) => showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => dialog);

  static clear() {
    module = Modules();
    shops = Shops();
  }

  static Color getColor() {
    if (module.toString().isNotEmpty && module.moduleColor != null) {
      return colorFromHex(module.moduleColor!);
    }
    return kPrimaryColor;
  }

  static Color getColorDark() {
    if (module.moduleColor != null) {
      int R = int.parse(module.moduleColor!.substring(1, 3), radix: 16);
      int G = int.parse(module.moduleColor!.substring(3, 5), radix: 16);
      int B = int.parse(module.moduleColor!.substring(5, 7), radix: 16);

      R = (R * 0.8).toInt();
      G = (G * 0.8).toInt();
      B = (B * 0.8).toInt();

      R = R < 255 ? R : 255;
      G = G < 255 ? G : 255;
      B = B < 255 ? B : 255;

      String RR = (
          (R.toString().length == 1) ?
          "0" + R.toRadixString(16) :
          R.toRadixString(16)
      );

      String GG = (
          (G.toString().length == 1) ?
          "0" + G.toRadixString(16) :
          G.toRadixString(16)
      );

      String BB = (
          (B.toString().length == 1) ?
          "0" + B.toRadixString(16) :
          B.toRadixString(16)
      );

      String color = "#$RR$GG$BB";
      return colorFromHex(color);
    }
    return primaryColorDark;
  }
}


Color colorFromHex(String hexColor) {
  final hexCode = "FF${hexColor.replaceAll('#', '')}";
  return Color(int.parse(hexCode, radix: 16));
}
