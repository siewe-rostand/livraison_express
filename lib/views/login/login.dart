import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/service/auth_service.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/login/register.dart';
import 'package:livraison_express/views/login/verification_code.dart';
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
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: primaryColor),
      child: Scaffold(
        body: Container(
            margin: const EdgeInsets.all(15),
            child: ListView(
              children: [
                Image.asset('img/logo.png'),
                Align(
                    alignment: Alignment.centerLeft,
                    child: _isPhone
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                _isPhone = !_isPhone;
                              });
                            },
                            child: const Text("Se connecter avec l'email ?"))
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                _isPhone = !_isPhone;
                              });
                            },
                            child: const Text(
                                "Se connecter avec le numero de telephone ?"))),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isPhone
                        ? IntlPhoneField(
                            controller: _phoneTextController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Telephone',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onChanged: (phone) {
                              countryCode = phone.countryCode;
                            },
                            initialCountryCode: 'CM',
                          )
                        : TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              fillColor: Colors.white,
                              filled: true,
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32)),
                            ),
                            controller: emailTextController,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
                        suffixIcon: IconButton(
                          icon: isObscureText
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isObscureText = !isObscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: isObscureText,
                      controller: passwordTextController,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const MotDePasse()));
                          },
                          child: const Text("Mot de passe oublie ?")),
                    ),
                    !_isProcessing
                        ? Container()
                        : const CircularProgressIndicator(),
                    SizedBox(
                      height: getProportionateScreenHeight(45),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ))),
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
                      SocialCard(icon: 'img/social/ic_google_icon.svg', press: () async {
                        await FireAuth(
                            progressDialog:
                            getProgressDialog(context: context))
                            .signInwithGoogle(context: context);
                      }),
                      SocialCard(icon: 'img/social/ic_facebook_logo.svg', press: () async {
                        await FireAuth(
                            progressDialog:
                            getProgressDialog(context: context))
                            .signInWithFacebook(context: context);
                      }),
                      SocialCard(icon: 'assets/images/ic_yahoo.svg', press: () async {
                        await FireAuth.performLogin('yahoo.com',
                            ['openid mail-r'], {'language': 'fr'});
                      },)
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vous etes nouveau?',
                      style: TextStyle(color: Colors.black38),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationPage()));
                        },
                        child: const Text("creer un compte"))
                  ],
                )
              ],
            ),
            ),
      ),
    );
  }
}

class MotDePasse extends StatefulWidget {
  const MotDePasse({Key? key}) : super(key: key);

  @override
  State<MotDePasse> createState() => _MotDePasseState();
}

class _MotDePasseState extends State<MotDePasse> {
  bool _isPhone = false;
  String countryCode = '';
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void showMessage({required String message, required String title}) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'img/icon/svg/ic_warning_yellow.svg',
                  color: const Color(0xffFFAE42),
                ),
                Text(title)
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(buildContext).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    _isPhone = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: primaryColor),
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Mot de Passe oublie.',
                  style: TextStyle(fontWeight: FontWeight.bold, color: grey80),
                ),
                SvgPicture.asset(
                  'img/icon/svg/ic_forgot_password.svg',
                  color: primaryColor,
                  height: 100,
                  width: 100,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _isPhone
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              _isPhone = !_isPhone;
                            });
                          },
                          child: const Text(
                            "Utiliser l'adresse email ?",
                            style: TextStyle(color: primaryColor),
                          ))
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              _isPhone = !_isPhone;
                            });
                          },
                          child: const Text(
                              "Se connecter avec le numero de telephone ?",
                              style: TextStyle(color: primaryColor))),
                ),
                _isPhone
                    ? IntlPhoneField(
                        controller: phoneController,
                        pickerDialogStyle: PickerDialogStyle(
                            searchFieldInputDecoration: const InputDecoration(
                                hintText: 'Chercher le pays')),
                        dropdownIconPosition: IconPosition.trailing,
                        showCountryFlag: false,
                        decoration: const InputDecoration(
                          labelText: 'Téléphone',
                        ),
                        onChanged: (phone) {
                          countryCode = phone.countryCode;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialCountryCode: 'CM',
                        validator: (val) {
                          if (val!.toString().isEmpty) {
                            return "Veuillez remplir ce champ";
                          }
                          return null;
                        },
                      )
                    : TextFormField(
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'Email',
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Veuillez remplir ce champ";
                          }
                          return null;
                        },
                      ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(45),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
                      onPressed: () async {
                        if (_isPhone) {
                          try {
                            await ApiAuthService(
                                    context: context,
                                    fromLogin: true,
                                    progressDialog:
                                        getProgressDialog(context: context))
                                .forgotPasswordCode(
                                    telephone: phoneController.text,
                                    countryCode: countryCode)
                                .then((response) {
                              var body = json.decode(response.body);
                              var data = body['data'];
                              var phone = data['phone'];
                              var email = data['email'];
                              debugPrint('true/// $phone');
                              debugPrint('true $email');
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          VerificationCode(
                                            phone: phone,
                                            resetPassword: true,
                                            email: email,
                                          )));
                            }).catchError((onError) {
                              print(onError);
                              // showMessage(message: onError.toString(), title: "Alerte");
                              showMessage(
                                  message:
                                      "Vérifiez votre connexion internet puis réessayez. Si l'erreur persiste veuillez nous contacter au 695461461",
                                  title: "Alerte");
                            });
                          } on Exception catch (e) {
                            print('exception $e');
                            showMessage(
                                message:
                                    "Veuillez réessayer plustard ou contactez nous au 695461461",
                                title: 'Erreur');
                          }
                        } else {
                          try {
                            await ApiAuthService(context: context)
                                .forgotPasswordCodeEmail(
                                    email: emailController.text)
                                .then((response) {
                              var body = json.decode(response.body);
                              var data = body['data'];
                              var phone = data['phone'];
                              var email = data['email'];
                              debugPrint('true/// $phone');
                              debugPrint('true $email');
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          VerificationCode(
                                            phone: phone,
                                            resetPassword: true,
                                            email: email,
                                          )));
                            }).catchError((onError) {
                              // showMessage(message: onError.toString(), title: "Alerte");
                              showMessage(
                                  message:
                                      "Vérifiez votre connexion internet puis réessayez. Si l'erreur persiste veuillez nous contacter au 695461461",
                                  title: "Alerte");
                            });
                          } on Exception catch (e) {
                            print('exception $e');
                            showMessage(
                                message:
                                    "Veuillez réessayer plustard ou contactez nous au 695461461",
                                title: 'Erreur');
                          }
                        }
                      },
                      child: const Text(
                        'VALIDER',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmCode extends StatelessWidget {
  const ConfirmCode(
      {Key? key, this.phone, this.email, this.token, this.resetPassword})
      : super(key: key);
  final String? phone;
  final String? email;
  final String? token;
  final bool? resetPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 100, right: 15, left: 15),
        child: Column(
          children: [
            Image.asset('img/logo.png'),
            const SizedBox(
              height: 15,
            ),
            const Text(
                'Vous allez recevoir un code de verification par SMS dans 1 minute. Veuillez entrer ce code'),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Entrez le code'),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ))),
                  onPressed: () {},
                  child: const Text(
                    'VALIDER',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                  onPressed: () {},
                  child: const Text("Se connecter avec l'email ?")),
            )
          ],
        ),
      ),
    );
  }
}
