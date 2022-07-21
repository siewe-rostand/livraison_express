
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livraison_express/service/api_auth_service.dart';
import 'package:livraison_express/utils/size_config.dart';
class VerificationCode extends StatefulWidget {
  const VerificationCode({Key? key, this.phone, this.email, this.token, this.resetPassword, this.code}) : super(key: key);
  final String? phone;
  final String? email;
  final String? token;
  final String? code;
  final bool? resetPassword;

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  bool resetPassword=false;
   String phone='';
   String email='';
   String token='';
   String code='';
  final codeTextController = TextEditingController();
  requestResetCode()async{
    await ApiAuthService.forgotPasswordCodeEmail(email: widget.email!).then((response) {
      var body = json.decode(response.body);
      print(body);
    }).catchError((onError){
      print(onError);
    });
  }

  @override
  void initState() {
    initView();
    super.initState();
  }
  initView(){
    resetPassword =widget.resetPassword!;
    token =widget.token!;
    email =widget.email!;
    phone =widget.phone!;
    code =widget.code!;
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
            const SizedBox(
              height: 15,
            ),
            const Text(
                'Vous allez recevoir un code de verification par SMS dans 1 minute. Veuillez entrer ce code'),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: codeTextController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Entrez le code'),
              validator: (val){
                if(val!.isEmpty){
                  return'veuillez remplir ce champs';
                } else if(val.length<5){
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
                  onPressed: () async{
                    if(resetPassword){
                      await ApiAuthService.verifyCode(tokens: token,code: codeTextController.text).then((response) {
                        var body = json.decode(response.body);
                        print(body);
                      }).catchError((onError){
                        print(onError);
                      });
                    }else{
                      await ApiAuthService.verifyResetCode(
                        telephone: phone,
                        countryCode: code,
                        email: email
                      ).then((response) {
                        var body = json.decode(response.body);
                        print(body);
                      }).catchError((onError){
                        print(onError);
                      });
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
                  onPressed: ()async {
                    setState(() {
                      resetPassword =true;
                    });
                    if(resetPassword){
                      await ApiAuthService.forgotPasswordCodeEmail(email: widget.email!).then((response) {
                        var body = json.decode(response.body);
                        print(body);
                      }).catchError((onError){
                        print(onError);
                      });
                    }else{
                      await ApiAuthService.requestCode(token).then((response) {
                        var body = json.decode(response.body);
                        print(body);
                      }).catchError((onError){
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