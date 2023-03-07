import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:livraison_express/service/auth_service.dart';

import '../data/user_helper.dart';
class LoginApi{
   getAccessToken(String firebaseAccessToken,String url,BuildContext context)async{
    Response response = await ApiAuthService(context: context,fromLogin: true,progressDialog: getProgressDialog(context: context)).getAccessToken( firebaseTokenId: firebaseAccessToken);

    if(response.body!=null){
      print("from login api ${response.body}");
    }
    return response;
  }
}