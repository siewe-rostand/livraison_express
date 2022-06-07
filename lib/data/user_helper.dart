import 'dart:convert';

import 'package:livraison_express/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper{
  static AppUser1 currentUser=AppUser1();

  Future<AppUser1> getCurrentUser()async{
    AppUser1 appUser1 =AppUser1();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userString =sharedPreferences.getString("userData");
    final extractedUserData =json.decode(userString!);
    if(currentUser != null){
      appUser1 =UserHelper.currentUser;
    }else{
      if(userString != null){
        appUser1 =extractedUserData;
        currentUser =appUser1;
      }
    }

    return appUser1;
  }
}