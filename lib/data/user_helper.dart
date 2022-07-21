import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livraison_express/model/auto_gene.dart';
import 'package:livraison_express/model/user.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/city.dart';

ProgressDialog getProgressDialog(
    {required BuildContext context, String message = "Chargement en cours..."}) {
  ProgressDialog progressDialog = ProgressDialog(context,
      type: ProgressDialogType.normal, isDismissible: false, showLogs: true);

  progressDialog.style(
      message: message,
      messageTextStyle: TextStyle(color: Colors.grey[800]),
      borderRadius: 5);

  return progressDialog;
}
class UserHelper{
  static const kPrimaryColor = Color(0xFF2A5CA8);
  static AppUser1? currentUser;
  static AppUser1? currentUser1=AppUser1();
  static String token = "access_token";
  static City city=City();
  static String selectCity='';
  static Shops shops=Shops();
  static Modules module=Modules();
  static bool isTodayOpen=false;
  static bool isTomorrowOpen=false;

  static getCity()async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    String city=pref.getString('city')??"DOUALA";
    return city;
  }

  static getCurrentUser()async{
    AppUser1? appUser1 =AppUser1();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userString =sharedPreferences.getString("userData");
    final extractedUserData =json.decode(userString!);
    appUser1 =AppUser1.fromJson(extractedUserData);
    return appUser1;
  }

  static userExitDialog(context, dismissible, dialog) => showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => dialog
  );
  static clear(){
    module=Modules();
    shops=Shops();
  }
   static Color getColor() {
    if (module.toString().isNotEmpty && module.moduleColor != null) {
      return colorFromHex(module.moduleColor!);
    }
    return kPrimaryColor;
  }
}
Color colorFromHex(String hexColor) {
  final hexCode = "FF${hexColor.replaceAll('#', '')}";
  return Color(int.parse(hexCode, radix: 16));
}