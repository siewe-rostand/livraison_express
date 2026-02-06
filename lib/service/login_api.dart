import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../data/user_helper.dart';
import 'auth_service.dart';

class LoginApi{
   getAccessToken(String firebaseAccessToken,String url,BuildContext context)async{
    Response response = await ApiAuthService(context: context,fromLogin: true,
        progressDialog: getProgressDialog(context: context)).getAccessToken( firebaseTokenId: firebaseAccessToken);

    print("from login api ${response.body}");
      return response;
  }
}