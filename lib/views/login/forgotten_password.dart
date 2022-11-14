
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:livraison_express/views/login/verification_code.dart';

import '../../constant/color-constant.dart';
import '../../data/user_helper.dart';
import '../../service/auth_service.dart';
import '../../utils/size_config.dart';

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