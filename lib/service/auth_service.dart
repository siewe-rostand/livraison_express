
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/model/user.dart';
import 'package:livraison_express/utils/main_utils.dart';
import 'package:livraison_express/views/home/home-page.dart';
import 'package:livraison_express/views/login/login.dart';
import 'package:logger/logger.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/login/reset_password.dart';
import '../views/login/verification_code.dart';
import '../views/widgets/custom_alert_dialog.dart';
import '../views/widgets/custom_dialog.dart';

String baseUrl = 'https://api.test.livraison-express.net/api/v1.1';
// String baseUrl = 'https://api.staging.livraison-express.net/api/v1.1';
String origin = 'https://livraison-express.net';
String devBaseUrl = 'http://192.168.137.194:8002/api/';
String token = '';

class ApiAuthService {
  final logger = Logger();
  final BuildContext context;
  final ProgressDialog? progressDialog;
  bool? fromLogin;
  ApiAuthService({required this.context, this.fromLogin=true, this.progressDialog});

  Future getAccessToken({required String firebaseTokenId}) async {
    String url = '$baseUrl/login/firebase';
    try {
      Response response = await post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Accept": "application/json",
          'Origin': origin
        },
        body: jsonEncode(<String, String>{
          'firebaseTokenId': firebaseTokenId,
        }),
      );
      if (response.statusCode == 200) {
        // logger.i('get token inside get access token /// ${response.body}');
        var body = json.decode(response.body);
        String accessToken = body['access_token'];
        UserHelper.currentUser1?.token=accessToken;
        getUserProfile(accessToken);
      } else {
        logger.e('get error token insider /// ${response.body}');
        progressDialog!.hide();
        showGenDialog(
            context,
            true,
            CustomDialog(
                title: 'Ooooops',
                content: onErrorMessage,
                positiveBtnText: "OK",
                positiveBtnPressed: () {
                  Navigator.of(context).pop();
                }));
        throw ('failed to load data');
      }
    } on SocketException catch (_) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onFailureMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      print('socket error');
    } on HttpException catch (_) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      print('http error');
    } on FormatException catch (e) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      logger.e("message$e");
      print('format error');
    } catch (e) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      logger.e('eer error');
    }
  }

  Future<Response> requestCode(String tokens) async {
    String url = '$baseUrl/user/phone/verify';
    Response response = await get(Uri.parse(url), headers: {
      "Authorization": 'Bearer $tokens',
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      return response;
    } else {
      print(response.body);
      logger.e(response.body);
      throw ('Error in loading user data');
    }
  }

  Future<Response> verifyPhoneActivationCode(
      {required String tokens, required String code}) async {
    String url = '$baseUrl/user/phone/verify/$code';
    Response response = await get(Uri.parse(url), headers: {
      "Authorization": 'Bearer $tokens',
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      return response;
    } else {
      var body = json.decode(response.body);
      logger.e(body);
      throw Exception('Error in loading user data');
    }
  }

  Future register({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? telephoneAlt,
    required String pwdConfirm,
    required String telephone,
    required String countryCode,
    required String licence,
  }) async {
    progressDialog!.show();
    String url =
        '$baseUrl/register/firebase';
    try {
      Response response = await post(
        Uri.parse(url),
        headers: <String, String>{
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Origin": origin
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
        progressDialog!.hide();
        var body = json.decode(response.body);
        String accessToken =body['access_token'];
        UserHelper.token = accessToken;
        UserHelper.currentUser1?.token=accessToken;
        // ApiAuthService(context: context).getUserProfile(accessToken);
        showMessage(context: context,title: "Félicitation",
            errorMessage: "Vos informations ont été enregistrées. Vous allez recevoir un code au numéro $telephone et à l'adresse $email."
        );
        await Future.delayed(const Duration(
            seconds: 2),(){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (bContext)=> VerificationCode(
            email: email,
            phone: telephone,
            token: accessToken,
            resetPassword: false,
            code: countryCode,
          )));
        });
        return response;
      } else {
        progressDialog!.hide();
        var body = json.decode(response.body);
        var res = body['data'];
        debugPrint("${response.statusCode}");
        var mes = body['message'];
        debugPrint('ERROR MESSAGE ${body['message']}');
        logger.e(response.body);
        if(body['message'].toString().contains('email address is already')) {
          showGenDialog(
          context,
          true,
          CustomDialog(
            title: 'Ooooops',
            content:
            "l'adresse e-mail est déjà utilisée par un autre compte",
            positiveBtnText: "OK",
            positiveBtnPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
        }else if(body['message'].toString().contains('phone number is already')){
          showGenDialog(
            context,
            true,
            CustomDialog(
              title: 'Ooooops',
              content:
              'le numéro de téléphone est déjà utilisé par un autre compte',
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
        }else{
          showGenDialog(
            context,
            true,
            CustomDialog(
              title: 'Ooooops',
              content:onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
        }
      }
    }on SocketException catch (_) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onFailureMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      print('socket error');
    } on HttpException catch (_) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      print('http error');
    } on FormatException catch (e) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      logger.e("message$e");
      print('format error');
    } catch (e) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      print('eer error');
    }
  }

  Future signInWithPhone({
    required String telephone,
    required String countryCode,
    required String password,
  }) async {
    progressDialog!.show();
    String url = '$baseUrl/login/firebase/password';
    try {
      Response response = await post(
        Uri.parse(url),
        headers: <String, String>{
          "Accept": "application/json",
          'Content-Type': 'application/json',
          "Origin": origin
        },
        body: jsonEncode(<String, String>{
          'telephone': telephone,
          'password': password,
          'phone_country_code': countryCode,
        }),
      );
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        String accessToken = body['access_token'];
        getUserProfile(accessToken);
        return response;
      } else {
        progressDialog!.hide();
        var body = json.decode(response.body);
        logger.e(response.statusCode);
        var mes = body['message'];
        var err = body['errors'];
        if (response.statusCode == 401) {
          log("$mes  $err");
          if(mes.toString().contains("phone number")) {
            showGenDialog(
            context,
            true,
            CustomDialog(
              title: 'Ooooops',
              content:noPhoneNumberUser,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
          }
        } else if (response.statusCode == 404 ||
            response.statusCode == 408 ||
            response.statusCode == 422 ||
            response.statusCode == 400 ||
            response.statusCode == 499) {
          if(mes == "The given data was invalid.") {
            if(err['password'].toString().contains('8')) {
              showGenDialog(
              context,
              true,
              CustomDialog(
                  title: 'Password Error',
                  content: "Le texte mot de passe doit contenir au moins 8 caractères",
                  positiveBtnText: "OK",
                  positiveBtnPressed: () {
                    Navigator.of(context).pop();
                  }));
            }else{
              showGenDialog(
                  context,
                  true,
                  CustomDialog(
                      title: 'Ooooops',
                      content: onLoginInvalidDate,
                      positiveBtnText: "OK",
                      positiveBtnPressed: () {
                        Navigator.of(context).pop();
                      }));
            }
          }
        } else {
          // debugPrint('ERROR MESSAGE ${body['message']}');
          showGenDialog(
              context,
              true,
              CustomDialog(
                  title: 'Ooooops',
                  content: onErrorMessage,
                  positiveBtnText: "OK",
                  positiveBtnPressed: () {
                    Navigator.of(context).pop();
                  }));
        }
      }
    } on SocketException catch (_) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onFailureMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      logger.e('socket error');
    } on HttpException catch (_) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      print('http error');
    } on FormatException catch (_) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));

      print('format error');
    } catch (e) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      print('eer error');
    }
  }

  Future signInWithPhone1({
    required String telephone,
    required String countryCode,
    required String password,
  }) async {
    String url = '$baseUrl/login/firebase/password';
    var httpClient =HttpClient();

    var body =jsonEncode(<String, String>{
      'telephone': telephone,
      'password': password,
      'phone_country_code': countryCode,
    });

    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    // request.headers.set('content-type', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set("Origin", origin);
    // request.headers.set ('Authorization', "Bearer " + token);
    request.add(utf8.encode(body));
    log(body);
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    logger.i(request.headers);
    // log(token);
    logger.w(reply);
    return reply;
  }

  Future signInWithEmail(String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    progressDialog!.show();
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.toString().isNotEmpty) {
        User? user = result.user;
        if (user != null) {
          final idToken = await user.getIdToken();
          getAccessToken(firebaseTokenId: idToken);
        } else {
          progressDialog!.hide();
          showGenDialog(
              context,
              true,
              CustomDialog(
                  title: 'Ooooops',
                  content: onFailureMessage,
                  positiveBtnText: "OK",
                  positiveBtnPressed: () {
                    Navigator.of(context).pop();
                  }));
          logger.e('Error');
        }
      } else {
        progressDialog!.hide();
      }
    } on FirebaseAuthException catch (e) {
      progressDialog!.hide();
      logger.e("message${e.message}");
      if (e.code == "wrong-password") {
        showGenDialog(
            context,
            true,
            CustomDialog(
                title: 'Password Error',
                content:
                    "Une erreur est survenu. Veuillez verifier votre mot de passe et elle doit contenir au moins 8 caractères",
                positiveBtnText: "OK",
                positiveBtnPressed: () {
                  Navigator.of(context).pop();
                }));
      }
      if (e.code == "user-not-found") {
        showGenDialog(
            context,
            true,
            CustomDialog(
                title: 'Ooooops',
                content:
                    "Une erreur est survenu. Veuillez verifier votre Email",
                positiveBtnText: "OK",
                positiveBtnPressed: () {
                  Navigator.of(context).pop();
                }));
      }
      logger.e(e.code);
    }
  }

  Future<Response> forgotPasswordCode({
    required String telephone,
    required String countryCode,
  }) async {
    progressDialog!.show();
    String url = '$baseUrl/password/code';
    Response response = await post(
      Uri.parse(url),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'phone': telephone,
        'phone_country_code': countryCode,
      }),
    );
    if (response.statusCode == 200) {
      progressDialog!.hide();
      var body = json.decode(response.body);
      // var res = body['data'];
      // AppUser appUsers=AppUser.fromJson(res);
      return response;
    } else {
      progressDialog!.hide();
      var body = json.decode(response.body);
      var res = body['data'];
      logger.e(response.body);
      var mes = body['message'];
      logger.e('ERROR MESSAGE ${body['message']}');
      throw (mes);
    }
  }

  Future<Response> forgotPasswordCodeEmail({required String email}) async {
    progressDialog!.show();
    String url = '$baseUrl/password/code';
    Response response = await post(
      Uri.parse(url),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    if (response.statusCode == 200) {
      progressDialog!.hide();
      var body = json.decode(response.body);
      // var res = body['data'];
      // AppUser appUsers=AppUser.fromJson(res);
      return response;
    } else {
      progressDialog!.hide();
      var body = json.decode(response.body);
      var res = body['data'];
      print(response.body);
      logger.e(body);
      var mes = body['message'];
      debugPrint('ERROR MESSAGE ${body['message']}');
      throw (mes);
    }
  }

  Future verifyResetCode({
    required String telephone,
    required String countryCode,
    required String email,
  }) async {
    progressDialog!.show();
    String url = '$baseUrl/password/code/verify';
    try {
      Response response = await post(
        Uri.parse(url),
        headers: <String, String>{
          "Accept": "application/json",
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'telephone': telephone,
          'code': countryCode,
          'email': email,
        }),
      );
      if (response.statusCode == 202) {
        progressDialog!.hide();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => ResetPassword(
              email: email,
              code: countryCode,
              telephone: telephone,
            )));
        return response;
      } else {
        progressDialog!.hide();
        var body = json.decode(response.body);
        var res = body['message'];
        logger.e(body);
        print('// ${response.body.isNotEmpty}');
        throw (res);
      }
    } on SocketException catch (_) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onFailureMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      print('socket error');
    } on HttpException catch (_) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      print('http error');
    } on FormatException catch (e) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      logger.e("message$e");
      print('format error');
    } catch (e) {
      progressDialog!.hide();
      showGenDialog(
          context,
          true,
          CustomDialog(
              title: 'Ooooops',
              content: onErrorMessage,
              positiveBtnText: "OK",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              }));
      print('eer error');
    }
  }

  Future<Response> edit({required Map data}) async {
    String url = "$baseUrl/user";
    Response response = await put(
      Uri.parse(url),
      body: json.encode(data),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Origin": origin,
        "Authorization": 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      logger.e(response.body);
      throw ('edit error//');
    }
  }

  unAuthenticated({String? message}) async {
    if (!fromLogin!) {
      await Future.delayed(
          const Duration(seconds: 1),
          () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen())));
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
            },
          ));
    }
  }

  getUserProfile(String accessToken) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(UserHelper.token, accessToken);
      token=accessToken;
      String url = "$baseUrl/user";
      final headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $accessToken"
      };
      final response = await get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body)['data'];
        AppUser1 appUser1 = AppUser1.fromJson(map);
        appUser1.token=accessToken;
        token=accessToken;
        UserHelper.currentUser1 = appUser1;
        final userData = json.encode(appUser1);
        preferences.setString("userData", userData);
        getConfigs();
      } else {
        progressDialog!.hide();
        logger.e('getUserProfile error ${response.body}');
        unAuthenticated();
        // logger.e(json.decode(response.body),response.statusCode);
      }
    } catch (e) {
      unAuthenticated();
    }
  }

  getConfigs() async {
    String city = await UserHelper.getCity();
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
        Fluttertoast.showToast(
            msg: "Connexion avec success", backgroundColor: Colors.green);
        if(fromLogin ==true) {
          progressDialog!.hide();
        }
        await Future.delayed(
            const Duration(seconds: 1),
            () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage())));
      } else {
        unAuthenticated();
        logger.e(response.body);
      }
    } catch (e) {
      unAuthenticated();
    }
  }

  Future<Response> resetPassword({
    required String email,
    required String telephone,
    required String code,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    progressDialog!.show();
    String url = "$baseUrl/password/reset";
    Response response = await post(
      Uri.parse(url),
      body: jsonEncode(<String, String>{
        'email': email,
        'password': newPassword,
        'password_confirmation': newPasswordConfirmation,
        'telephone': telephone,
        'code': code
      }),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Origin": origin,
        "Authorization": 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      progressDialog!.hide();
      // print("/// ${response.body}");
      var body = json.decode(response.body);
      return response;
    } else {
      progressDialog!.hide();
      logger.e(response.body);
      throw ('edit error//');
    }
  }
}
