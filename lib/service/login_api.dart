import 'package:http/http.dart';
import 'package:livraison_express/service/api_auth_service.dart';
class LoginApi{
  static getAccessToken(String firebaseAccessToken,String url)async{
    Response response = await ApiAuthService.getAccessToken( firebaseTokenId: firebaseAccessToken);

    if(response.body!=null){
      print("from login api ${response.body}");
    }
    return response;
  }
}