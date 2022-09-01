import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/service/api_auth_service.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/login/login.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final String code;
  final String telephone;
  const ResetPassword(
      {Key? key,
      required this.email,
      required this.code,
      required this.telephone})
      : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isObscureText = true;
  final passwordTextController = TextEditingController();
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
            SizedBox(
              width: double.infinity,
              child: Text(
                "Entrez votre nouveau mot de passe",
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(15),
            ),
            TextFormField(
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                fillColor: Colors.white,
                filled: true,
                labelText: 'Mot de passe',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
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
            SizedBox(
              height: getProportionateScreenHeight(15),
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
                  onPressed: () async {
                    await ApiAuthService(
                            context: context,
                            progressDialog: getProgressDialog(context: context))
                        .resetPassword(
                            email: widget.email,
                            telephone: widget.telephone,
                            code: widget.code,
                            newPassword: passwordTextController.text,
                            newPasswordConfirmation: passwordTextController.text)
                        .then((value) {
                      print('cool//');
                      Fluttertoast.showToast(
                          msg: 'Mot de passe réinitialisé avec succès',backgroundColor: Colors.green);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginScreen()));
                    }).catchError((onError) {
                      print(onError);
                    });
                  },
                  child: const Text(
                    'ENREGISTRER',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
