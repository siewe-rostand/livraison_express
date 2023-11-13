import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/service/auth_service.dart';
import 'package:livraison_express/utils/app_extension.dart';
import 'package:livraison_express/utils/asset_manager.dart';
import 'package:livraison_express/utils/main_utils.dart';
import 'package:livraison_express/utils/size_config.dart';

import '../widgets/custom_textfield.dart';

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 100.h, right: 15.r, left: 15.r),
          child: Column(
            children: [
              Image.asset(AssetManager.logo),
              15.sBH,
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Entrez votre nouveau mot de passe",
                  style: TextStyle(color: Colors.grey.shade800,fontSize: 16.sp, wordSpacing: 0.25),
                ),
              ),
              15.sBH,
              CustomTextField(
                labelText: 'Nouveau mot de passe',
                isPassword: isObscureText,
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
             15.sBH,
              SizedBox(
                height: getProportionateScreenHeight(45),
                width: double.infinity,
                child: ElevatedButton(
                    style: loginButtonStyle(),
                    onPressed: () async {
                      await ApiAuthService(
                              context: context,
                              fromLogin: false,
                              progressDialog: getProgressDialog(context: context))
                          .resetPassword(
                              email: widget.email,
                              telephone: widget.telephone,
                              code: widget.code,
                              newPassword: passwordTextController.text,
                              newPasswordConfirmation: passwordTextController.text);
                    },
                    child: const Text(
                      'ENREGISTRER',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
