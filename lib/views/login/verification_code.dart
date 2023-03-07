import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/service/auth_service.dart';
import 'package:livraison_express/utils/main_utils.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/home/home-page.dart';
import 'package:livraison_express/views/login/login.dart';
import 'package:livraison_express/views/login/reset_password.dart';
import 'package:livraison_express/views/widgets/custom_alert_dialog.dart';
import 'package:livraison_express/views/widgets/custom_dialog.dart';

import '../../constant/color-constant.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode(
      {Key? key,
      this.phone,
      this.email,
      this.token,
      this.resetPassword,
      this.code})
      : super(key: key);
  final String? phone;
  final String? email;
  final String? token;
  final String? code;
  final bool? resetPassword;

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  bool resetPassword = false, isLoading = false;
  String phone = '';
  String email = '';
  String token = '';
  String code = '';
  final codeTextController = TextEditingController();
  requestResetCode() async {
    await ApiAuthService(context: context)
        .forgotPasswordCodeEmail(email: widget.email!)
        .then((response) {
      var body = json.decode(response.body);
      print(body);
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  initView() {
    // debugPrint("verif \n$resetPassword\n$token\n$email\n$phone\n$code}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 100, right: 15, left: 15),
        child: Column(
          children: [
            Image.asset('img/logo.png'),
            SizedBox(
              height: getProportionateScreenHeight(15),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : const Text(
                    'Vous allez recevoir un code de verification par SMS dans 1 minute. Veuillez entrer ce code'),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: codeTextController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Entrez le code'),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'veuillez remplir ce champs';
                } else if (val.length < 5) {
                  return "Le code doit contenir aumoins 5 chiffres";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: getProportionateScreenHeight(45),
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ))),
                  onPressed: () {
                    if (widget.resetPassword == false &&
                        codeTextController.text.isNotEmpty) {
                      token = widget.token!;
                      ApiAuthService(context: context)
                          .verifyPhoneActivationCode(
                              tokens: token, code: codeTextController.text)
                          .then((response) async {
                        showGenDialog(
                            context,
                            true,
                            CustomDialog(
                              title: 'Félicitation',
                              content:
                                  'Votre compte a été activé. Vous pouvez désormais profiter pleinement de Livraison express',
                              positiveBtnText: "OK",
                              positiveBtnPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginScreen()));
                              },
                            ));
                      }).catchError((onError) {
                        log("message$onError");
                        showGenDialog(
                            context,
                            false,
                            CustomDialog(
                                title: "Oooops",
                                content:
                                    "Ce code est incorrecte ou n'est plus valide",
                                positiveBtnText: "OK",
                                positiveBtnPressed: () =>
                                    Navigator.of(context).pop()));
                        // log(onError);
                      });
                    } else {
                      email = widget.email!;
                      phone = widget.phone!;
                      debugPrint(
                          '$email,,,$phone,,,${codeTextController.text}');
                      ApiAuthService(
                              context: context,
                              progressDialog:
                                  getProgressDialog(context: context))
                          .verifyResetCode(
                              telephone: phone,
                              countryCode: codeTextController.text,
                              email: email);
                    }
                  },
                  child: const Text(
                    'VALIDER',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (resetPassword != widget.resetPassword) {
                      await ApiAuthService(context: context)
                          .forgotPasswordCodeEmail(email: widget.email!)
                          .then((response) {
                        var body = json.decode(response.body);
                        print(body);
                        setState(() {
                          isLoading = false;
                        });
                      }).catchError((onError) {
                        setState(() {
                          isLoading = false;
                        });
                        print(onError);
                      });
                    } else {
                      token = widget.token!;
                      await ApiAuthService(context: context)
                          .requestCode(token)
                          .then((response) {
                            setState(() {
                            isLoading= false;
                            });
                            showGenDialog(context, false, CustomDialog(
                              title: 'success',
                              content:
                              "un nouveau code a été envoyé à votre adresse e-mail, veuillez vérifier",
                              positiveBtnText: "OK",
                              positiveBtnPressed: () {
                                Navigator.of(context).pop();
                              },
                            ));
                        var body = json.decode(response.body);
                        print(body);
                      }).catchError((onError) {
                        setState(() {
                          isLoading= false;
                        });
                        showGenDialog(context, false, CustomDialog(
                          title: 'Ooooops',
                          content:
                          onErrorMessage,
                          positiveBtnText: "OK",
                          positiveBtnPressed: () {
                            Navigator.of(context).pop();
                          },
                        ));
                        print(onError);
                      });
                    }
                  },
                  child: const Text("Demander un nouveau code ")),
            )
          ],
        ),
      ),
    );
  }
}
