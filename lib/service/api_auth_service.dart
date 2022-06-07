import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:livraison_express/model/user.dart';

String baseUrl = 'https://api.staging.livraison-express.net/api/v1.1';
String origin = 'https://livraison-express.net';
String devBaseUrl = 'http://192.168.137.194:8002/api/';
String token = '';
// String token =
//     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMDUzNzkwY2JhMTNmYjM0OTIyZTAxNTIxMWNhZTU0MDI0Njg5ZGEzN2IyN2U3NGIzZGMzNGI2NDAwZDkyNjk0MDY2MTJlYjMwZWY5MGVjZDkiLCJpYXQiOjE2NTE4MzMyNjksIm5iZiI6MTY1MTgzMzI2OSwiZXhwIjoxNjgyOTM3MjY5LCJzdWIiOiI0OTYyMSIsInNjb3BlcyI6WyJ1c2VyIiwidXNlci1wcm9maWxlIl19.KXj-zpOxjdrio1Q1tUl9QXJApax41STH3IGlkpRqnPgIz_uLmJusFmR0p3yGxEyK19MIvNiVcpRETFGfOBVcPvHRaoXK5jc6Bwk5lhEjluxJBVu0MOV3Plv5Sxf5FoLDFEsq113jH7S96GZl6Zt7BFRqVEmi28nFX1UalOSzpmdWkecqIuu5hgnRVHO6GNuLrfqQ29JMAzt_CnmNncSY_5Ge5YtOk4Y9KIqyYe9BPBSnQaioNSY9sVBP06GkfR7GfkIXW5DwxhDTITBWT5fL8ApjZLBwPnW6wD_xCgidxNAwcCTdTgwvQld_A7YBfVsZGv2HRZQUN7TpMZmShNihklFpndxBTH_LkzAMgx8E4PrvN-Nxe_dsDrN-zR6Y8FXtrW8Il40t63hTgIpwGgWrVC0Ht-PqGnuv4UOHFeLPXhGWIsgFfpXrBt6pGDAoQ879SolfEXyhB2zR0awd-VNGgZSSmxTPbbWcIHa16CL2rjEUL2bq5HBtvWRE6a-GDMVhS7pd5RNGHxyeIPeic3uYGdlJovfHgeVeSXy1xD3C2YIwXEyWrckVJ3gDOcw8IezJ9Ux6QALWMfyWbxkluHvE0lymCAbkhkE-ep7sufnP6LA27OfY8XV1sJM-GhAb3Yj_JRQ7OGJXUKdiqeN55ICwFJdUrZLrmCsfQUvuqeq_JoA';
class ApiAuthService {
  static Future getAccessToken(
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
      print('get token insider /// ${response.statusCode}');
    } else {
      print('get error token insider /// ${response.body}');
      print('get error token insider /// ${response.statusCode}');
      throw Exception('failed to load data');
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

  static Future<AppUser> register(
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
      var res = body['data'];
      AppUser appUsers=AppUser.fromJson(res);
      return appUsers;
    } else {
      var body = json.decode(response.body);
      var res = body['data'];
      print(response.statusCode);
      var mes =body['message'];
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw Exception(mes);
    }
  }


  static Future<Response> login(
      {required String telephone,required String countryCode,required String password,
      }) async {
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
      // var res = body['data'];
      // AppUser appUsers=AppUser.fromJson(res);
      return response;
    } else {
      var body = json.decode(response.body);
      var res = body['data'];
      print("${response.statusCode}");
      var mes =body['message'];
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw Exception(mes);
    }
  }


  static Future<Response> forgotPasswordCode(
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
      print(response.body);
      var mes =body['message'];
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw Exception(mes);
    }
  }


  static Future forgotPasswordCodeEmail(
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
      return body;
    } else {
      var body = json.decode(response.body);
      var res = body['data'];
      print("${response.body}");
      var mes =body['message'];
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw Exception(mes);
    }
  }

  static Future<Response> edit({required Map data})async{
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
      print(response.body);
      throw Exception('edit error//');
    }
  }
}
