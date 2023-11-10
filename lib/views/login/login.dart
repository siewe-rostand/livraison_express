import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/service/auth_service.dart';
import 'package:livraison_express/utils/app_extension.dart';
import 'package:livraison_express/utils/asset_manager.dart';
import 'package:livraison_express/utils/main_utils.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/utils/string_manager.dart';
import 'package:livraison_express/views/login/forgotten_password.dart';
import 'package:livraison_express/views/login/register.dart';
import 'package:livraison_express/views/login/verification_code.dart';
import 'package:livraison_express/views/widgets/custom_textfield.dart';
import 'package:livraison_express/views/widgets/social-card.dart';

import '../../model/city.dart';
import '../../service/fire-auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String routeName = "/login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscureText = true;
  bool _isPhone = false;
  bool _isProcessing = false;
  final _phoneTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final emailTextController = TextEditingController();
  String countryCode = '';
  List<City> cities = [];
  @override
  void initState() {
    _isPhone = true;
    isObscureText = true;

    super.initState();
  }

  @override
  void dispose() {
    passwordTextController.dispose();
    _phoneTextController.dispose();
    emailTextController.dispose();
    super.dispose();
  }

  void printScreenInformation(BuildContext context) {
    print('Device Size:${Size(1.sw, 1.sh)}');
    print('Device pixel density:${ScreenUtil().pixelRatio}');
    print('Bottom safe zone distance dp:${ScreenUtil().bottomBarHeight}dp');
    print('Status bar height dp:${ScreenUtil().statusBarHeight}dp');
    print('The ratio of actual width to UI design:${ScreenUtil().scaleWidth}');
    print(
        'The ratio of actual height to UI design:${ScreenUtil().scaleHeight}');
    print('System font scaling:${ScreenUtil().textScaleFactor}');
    print('0.5 times the screen width:${0.5.sw}dp');
    print('0.5 times the screen height:${0.5.sh}dp');
    print('Screen orientation:${ScreenUtil().orientation}');
  }

  @override
  Widget build(BuildContext context) {
    // printScreenInformation(context);
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(statusBarColor: primaryColor),
        child: Scaffold(
          body: Container(
            margin: const EdgeInsets.all(15),
            child: ListView(
              children: [
                Image.asset(AssetManager.logo),
                Align(
                    alignment: Alignment.centerLeft,
                    child: _isPhone
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                _isPhone = !_isPhone;
                                _phoneTextController.clear();
                                emailTextController.clear();
                              });
                            },
                            child: const Text(StringManager.connectWithEmail))
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                _isPhone = !_isPhone;
                                emailTextController.clear();
                                _phoneTextController.clear();
                              });
                            },
                            child: const Text(StringManager.connectWithPhone))),
                10.sBH,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isPhone
                        ? IntlPhoneField(
                            controller: _phoneTextController,
                            pickerDialogStyle: PickerDialogStyle(
                              searchFieldInputDecoration: inputDecoration(
                                  labelText: 'Chercher le pays'),
                            ),
                            disableLengthCheck: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: inputDecoration(
                                labelText: StringManager.phoneNumber),
                            onChanged: (phone) {
                              countryCode = phone.countryCode;
                            },
                            initialCountryCode: 'CM',
                          )
                        : CustomTextField(
                            keyboardType: TextInputType.emailAddress,
                            labelText: StringManager.email,
                            controller: emailTextController,
                          ),
                    10.sBH,
                    CustomTextField(
                      labelText: StringManager.password,
                      isPassword: isObscureText,
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordTextController,
                      suffixIcon: IconButton(
                        icon: isObscureText
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off_rounded),
                        onPressed: () {
                          setState(() {
                            isObscureText = !isObscureText;
                          });
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const ForgottenPasswordScreen()));
                          },
                          child: const Text(StringManager.forgottenPassword)),
                    ),
                    !_isProcessing
                        ? Container()
                        : const CircularProgressIndicator(),
                    SizedBox(
                      height: getProportionateScreenHeight(45),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: loginButtonStyle(),
                          onPressed: () async {
                            if (_phoneTextController.text.isNotEmpty) {
                              await ApiAuthService(
                                      context: context,
                                      fromLogin: true,
                                      progressDialog:
                                          getProgressDialog(context: context))
                                  .signInWithPhone(
                                      telephone: _phoneTextController.text,
                                      countryCode: countryCode,
                                      password: passwordTextController.text);
                            }
                            if (emailTextController.text.isNotEmpty) {
                              ApiAuthService(
                                      context: context,
                                      fromLogin: true,
                                      progressDialog:
                                          getProgressDialog(context: context))
                                  .signInWithEmail(emailTextController.text,
                                      passwordTextController.text);
                            }
                          },
                          child: const Text(
                            'CONNEXION',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(children: const [
                  Expanded(
                    child: Divider(
                      thickness: 1.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Ou'),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1.5,
                    ),
                  )
                ]),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialCard(
                          icon: AssetManager.googleIcon,
                          press: () async {
                            await FireAuth(
                                    progressDialog:
                                        getProgressDialog(context: context))
                                .signInwithGoogle(context: context);
                          }),
                      SocialCard(
                          icon: AssetManager.facebookIcon,
                          press: () async {
                            await FireAuth(
                                    progressDialog:
                                        getProgressDialog(context: context))
                                .signInWithFacebook(context: context);
                          }),
                      SocialCard(
                        icon: AssetManager.yahooIcon,
                        press: () async {
                          await FireAuth.performLogin('yahoo.com',
                              ['openid mail-r'], {'language': 'fr'});
                        },
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vous êtes nouveau?',
                      style: TextStyle(color: Colors.black38),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationPage()));
                        },
                        child: const Text(StringManager.createAccount))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
