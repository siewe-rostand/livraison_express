import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/user_helper.dart';
import '../service/auth_service.dart';
import '../utils/main_utils.dart';
import '../views/widgets/custom_dialog.dart';

class AuthProvider with ChangeNotifier{
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  final logger = Logger();
  final BuildContext context;
  final ProgressDialog? progressDialog;
  AuthProvider({required this.context, this.progressDialog});

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future getAccessToken({required String firebaseTokenId}) async {
    String url = '$baseUrl/login/firebase';
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
      // print("body access $accessToken");
      _token=accessToken;
      UserHelper.token=accessToken;
      ApiAuthService(context: context).getUserProfile(accessToken);
    } else {
      logger.e('get error token insider /// ${response.body}');
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
      throw ('failed to load data');
    }
  }

  Future signInWithPhone({
    required String telephone,
    required String countryCode,
    required String password,
  }) async {
    progressDialog!.show();
    String url = '$baseUrl/login/firebase/password';
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
      // print("body $body");
      String accessToken = body['access_token'];
      _token=accessToken;
       logger.d(accessToken);
      progressDialog!.hide();
      notifyListeners();
      ApiAuthService(context: context).getUserProfile(accessToken);
      return response;
    } else {
      progressDialog!.hide();
      var body = json.decode(response.body);
      logger.e("+++ ${response.statusCode} ");
      var mes = body['message'];
      var err = body['errors'];
      if (response.statusCode == 401) {
        showGenDialog(
          context,
          true,
          CustomDialog(
            title: 'Ooooops',
            content:
            'Une erreur est survenu. Veuillez verifier votre Numero de telephone ou le mot de passe',
            positiveBtnText: "OK",
            positiveBtnPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      } else if (response.statusCode == 404 ||
          response.statusCode == 408 ||
          response.statusCode == 422 ||
          response.statusCode == 400 ||
          response.statusCode == 499) {
        logger.e(response.statusCode);
        logger.d(response.body);
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
      } else {
        // debugPrint('ERROR MESSAGE ${body['message']}');
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
      }
    }
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry!), logout);
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
    json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    notifyListeners();
    _autoLogout();
    return true;
  }
}