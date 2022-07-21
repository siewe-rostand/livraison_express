import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/module_color.dart';
import 'package:livraison_express/model/user.dart';
import 'package:livraison_express/utils/main_utils.dart';
import 'package:livraison_express/views/home/home-page.dart';
import 'package:livraison_express/views/main/login.dart';
import 'package:logger/logger.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/widgets/custom_dialog.dart';

String baseUrl = 'https://api.staging.livraison-express.net/api/v1.1';
String origin = 'https://livraison-express.net';
String devBaseUrl = 'http://192.168.137.194:8002/api/';
String token = '';
// String token =
//     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMDUzNzkwY2JhMTNmYjM0OTIyZTAxNTIxMWNhZTU0MDI0Njg5ZGEzN2IyN2U3NGIzZGMzNGI2NDAwZDkyNjk0MDY2MTJlYjMwZWY5MGVjZDkiLCJpYXQiOjE2NTE4MzMyNjksIm5iZiI6MTY1MTgzMzI2OSwiZXhwIjoxNjgyOTM3MjY5LCJzdWIiOiI0OTYyMSIsInNjb3BlcyI6WyJ1c2VyIiwidXNlci1wcm9maWxlIl19.KXj-zpOxjdrio1Q1tUl9QXJApax41STH3IGlkpRqnPgIz_uLmJusFmR0p3yGxEyK19MIvNiVcpRETFGfOBVcPvHRaoXK5jc6Bwk5lhEjluxJBVu0MOV3Plv5Sxf5FoLDFEsq113jH7S96GZl6Zt7BFRqVEmi28nFX1UalOSzpmdWkecqIuu5hgnRVHO6GNuLrfqQ29JMAzt_CnmNncSY_5Ge5YtOk4Y9KIqyYe9BPBSnQaioNSY9sVBP06GkfR7GfkIXW5DwxhDTITBWT5fL8ApjZLBwPnW6wD_xCgidxNAwcCTdTgwvQld_A7YBfVsZGv2HRZQUN7TpMZmShNihklFpndxBTH_LkzAMgx8E4PrvN-Nxe_dsDrN-zR6Y8FXtrW8Il40t63hTgIpwGgWrVC0Ht-PqGnuv4UOHFeLPXhGWIsgFfpXrBt6pGDAoQ879SolfEXyhB2zR0awd-VNGgZSSmxTPbbWcIHa16CL2rjEUL2bq5HBtvWRE6a-GDMVhS7pd5RNGHxyeIPeic3uYGdlJovfHgeVeSXy1xD3C2YIwXEyWrckVJ3gDOcw8IezJ9Ux6QALWMfyWbxkluHvE0lymCAbkhkE-ep7sufnP6LA27OfY8XV1sJM-GhAb3Yj_JRQ7OGJXUKdiqeN55ICwFJdUrZLrmCsfQUvuqeq_JoA';
class ApiAuthService {
  ModuleColor moduleColor=ModuleColor();
  final logger = Logger();
  final BuildContext context;
  final ProgressDialog? progressDialog;
   bool? fromLogin;
  ApiAuthService({required this.context, this.fromLogin, this.progressDialog});
   Future getAccessToken(
      { required String firebaseTokenId}) async {
    String url = 'https://api.staging.livraison-express.net/api/v1.1/login/firebase';
    Response response = await post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Accept":"application/json",
          'Origin': origin
        },
        body: jsonEncode(<String, String>{
          'firebaseTokenId': firebaseTokenId,
        }),
        );
    if (response.statusCode == 200) {
      logger.i('get token inside get access token /// ${response.body}');
      var body = json.decode(response.body);
      String accessToken = body['access_token'];
      // print("body access $accessToken");
      token = accessToken;
      getUserProfile(accessToken);
    } else {
      logger.e('get error token insider /// ${response.body}');
      throw Exception('failed to load data');
    }
  }

  static Future<Response> requestCode(String tokens) async {
    String url = 'https://api.staging.livraison-express.net/api/v1.1/user/phone/verify';
    Response response =
        await get(Uri.parse(url), headers: {
          "Authorization": 'Bearer $tokens',
          "Accept":"application/json",
        });
    if (response.statusCode == 200) {
      // var body = json.decode(response.body);
      // var res = body['data'];
      // AppUser1 appUsers=AppUser1.fromJson(res);
      //
      //
      // print('user body ${appUsers.telephone}');
      return response;
    } else {
      print(response.body);
      throw Exception('Error in loading user data');
    }
  }
  static Future<Response> verifyCode({required String tokens, required String code}) async {
    String url = '$baseUrl/user/phone/verify/$code';
    Response response =
        await get(Uri.parse(url), headers: {
          "Authorization": 'Bearer $tokens',
          "Accept":"application/json",
        });
    if (response.statusCode == 200) {
      // var body = json.decode(response.body);
      // var res = body['data'];
      // AppUser1 appUsers=AppUser1.fromJson(res);
      //
      //
      // print('user body ${appUsers.telephone}');
      return response;
    } else {
      print(response.body);
      throw Exception('Error in loading user data');
    }
  }
  static Future<AppUser1> getUser() async {
    String url = 'https://api.staging.livraison-express.net/api/v1.1/user';
    Response response =
        await get(Uri.parse(url), headers: {
          "Authorization": 'Bearer $token',
          "Accept":"application/json",
        });
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var res = body['data'];
      AppUser1 appUsers=AppUser1.fromJson(res);


      print('user body ${appUsers.telephone}');
      return appUsers;
    } else {
      print(response.body);
      throw Exception('Error in loading user data');
    }
  }

   Future<Response> register(
      {required String username,required String firstName,
        required String lastName,required String email,required String password, String? telephoneAlt,
        required String pwdConfirm,required String telephone,required String countryCode,required String licence,
      }) async {
    String url = 'https://api.staging.livraison-express.net/api/v1.1/register/firebase';
    Response response = await post(Uri.parse(url),
      headers: <String, String>{
        "Accept":"application/json",
        'Content-Type': 'application/json',
        "Origin":origin
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'password': password,
        'password_confirmation': pwdConfirm,
        'telephone': telephone,
        'phone_country_code': countryCode,
        'telephone_alt': telephoneAlt!,
        'licence': licence,
      }),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      logger.d(body);
      return response;
    } else {
      var body = json.decode(response.body);
      var res = body['data'];
      debugPrint("${response.statusCode}");
      var mes =body['message'];
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw Exception(mes);
    }
  }


  Future signInWithPhone(
      {required String telephone,required String countryCode,required String password,
      }) async {
    try {
      String url = '$baseUrl/login/firebase/password';
      Response response = await post(Uri.parse(url),
        headers: <String, String>{
          "Accept":"application/json",
          'Content-Type': 'application/json',
          "Origin":origin
        },
        body: jsonEncode(<String, String>{
          'telephone': telephone,
          'password': password,
          'phone_country_code': countryCode,
        }),
      );
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        // print("body $body");
        String accessToken = body['access_token'];
        token = accessToken;
        String nToken = "Bearer $accessToken";
        // logger.d(nToken);
        getUserProfile(accessToken);
        return response;
      }  else {
        var body = json.decode(response.body);
        logger.e("+++ ${response.statusCode} ${response.body}");
        var mes = body['message'];
        var err = body['errors'];
        if (response.statusCode == 401) {
          throw (onErrorMessage);
        } else if (response.statusCode == 404 ||response.statusCode == 408||
            response.statusCode == 422 ||
            response.statusCode == 400 ||
            response.statusCode == 499) {
          logger.e(response.statusCode);
          logger.d(response.body);
          throw (onFailureMessage);
        }else{
          debugPrint('ERROR MESSAGE ${body['message']}');
          throw (onFailureMessage);
        }

      }
    } catch (e) {
      print(e);
      unAuthenticated();
    }
  }


  Future signInWithEmail(String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.toString().isNotEmpty ) {
        User? user = result.user;
        if (user != null) {
          final idToken = await user.getIdToken();
          getAccessToken(firebaseTokenId: idToken);
        } else {
          unAuthenticated();
          logger.e('Error');
        }
      } else {
        unAuthenticated();
        logger.e('error');
      }
    }catch (e) {
      print(e);
    }
  }


   Future<Response> forgotPasswordCode(
      {required String telephone,required String countryCode,
      }) async {
    String url = '$baseUrl/password/code';
    Response response = await post(Uri.parse(url),
      headers: <String, String>{
        "Accept":"application/json",
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'phone': telephone,
        'phone_country_code': countryCode,
      }),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      // var res = body['data'];
      // AppUser appUsers=AppUser.fromJson(res);
      return response;
    } else {
      var body = json.decode(response.body);
      var res = body['data'];
      logger.e(response.body);
      var mes =body['message'];
      logger.e('ERROR MESSAGE ${body['message']}');
      throw (mes);
    }
  }


  static Future<Response> verifyResetCode(
      {required String telephone,required String countryCode,required String email,
      }) async {
    String url = '$baseUrl/password/code/verify';
    Response response = await post(Uri.parse(url),
      headers: <String, String>{
        "Accept":"application/json",
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'telephone': telephone,
        'code': countryCode,
        'email': email,
      }),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      // var res = body['data'];
      // AppUser appUsers=AppUser.fromJson(res);
      return response;
    } else {
      var body = json.decode(response.body);
      var res = body['data'];
      print(response.body);
      var mes =body['message'];
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw (mes);
    }
  }


  static Future<Response> forgotPasswordCodeEmail(
      {required String email
      }) async {
    String url = '$baseUrl/password/code';
    Response response = await post(Uri.parse(url),
      headers: <String, String>{
        "Accept":"application/json",
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      // var res = body['data'];
      // AppUser appUsers=AppUser.fromJson(res);
      return response;
    } else {
      var body = json.decode(response.body);
      var res = body['data'];
      print("${response.body}");
      var mes =body['message'];
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw (mes);
    }
  }

  Future<Response> edit({required Map data})async{
    String url ="$baseUrl/user";
    Response response = await put(Uri.parse(url),
      body: json.encode(data) ,
      headers:  <String, String>{
        "Accept":"application/json",
        'Content-Type': 'application/json',
        "Origin":origin,
        "Authorization": 'Bearer $token',
      },
    );

    if(response.statusCode ==200){
      // print("/// ${response.body}");
      var body = json.decode(response.body);
      return response;
    }else{
      logger.e(response.body);
      throw ('edit error//');
    }
  }

  unAuthenticated({String? message}) async {
    if (!fromLogin!) {
      await Future.delayed(
          const Duration(seconds: 1),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const LoginScreen())));
    } else {
      UserHelper.userExitDialog(
          context,
          false,
          CustomAlertDialog(
              svgIcon: "img/icon/svg/smiley_sad.svg",
              title: "Oops!",
              message: message ?? "Une erreur est survenue",
              positiveText: 'Fermer',
              onContinue: () {
                Navigator.pop(context);
              }, moduleColor: moduleColor,));
      print('///|||');
    }
  }

  getUserProfile(String accessToken) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(UserHelper.token, accessToken);
      String url = "$baseUrl/user";
      final headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $accessToken"
      };
      final response = await get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body)['data'];
        AppUser1 appUser1=AppUser1.fromJson(map);
        UserHelper.currentUser1=appUser1;
        appUser1.token = accessToken;
        UserHelper.currentUser1?.token=accessToken;
        final userData = json.encode(appUser1);
        preferences.setString("userData", userData);
        logger.i('user profile //${appUser1.emailVerifiedAt}//${appUser1.telephone}');
        // debugPrint('user profile ${appUser1.toJson()}');
        getConfigs();
      } else {
        logger.e('getUserProfile error ${response.body}');
        unAuthenticated();
        // logger.e(json.decode(response.body),response.statusCode);
      }
    } catch (e) {
      unAuthenticated();
    }
  }

  getConfigs() async {
     String city=await UserHelper.getCity();
    try {
      String url = '$baseUrl/preload?city=$city';
      final headers = {
        'Accept': 'application/json',
      };
      final response = await get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> value = jsonDecode(response.body)['data'];
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('modules', jsonEncode(value['modules']));
        preferences.setString('cities', jsonEncode(value['cities']));
        print('get module finished');
        Fluttertoast.showToast(msg: "Connexion avec success",backgroundColor: Colors.green);
        await Future.delayed(
            const Duration(seconds: 1),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomePage())));
      } else {
        unAuthenticated();
        logger.e(response.body);
      }
    } catch (e) {
      unAuthenticated();
    }
  }
}
