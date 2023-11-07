
import 'dart:convert';

import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:livraison_express/utils/app_extension.dart';
import 'package:livraison_express/views/login/verification_code.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/color-constant.dart';
import '../../data/user_helper.dart';
import '../../service/auth_service.dart';
import '../../utils/asset_manager.dart';
import '../../utils/main_utils.dart';
import '../../utils/size_config.dart';
import '../../utils/string_manager.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/custom_textfield.dart';

class ForgottenPasswordScreen extends StatefulWidget {
  const ForgottenPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgottenPasswordScreen> createState() =>
      _ForgottenPasswordScreenState();
}

class _ForgottenPasswordScreenState extends State<ForgottenPasswordScreen> {
  bool _isPhone = true;
  String countryCode = '';
  bool isClicked = false;
  bool isDisabledButton = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  launchCall()async{
    final Uri launchUri = Uri(scheme: 'tel', path: '695461461');
    await launchUrl(launchUri);
  }
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
                  AssetManager.warningIcon,
                  color: const Color(0xffFFAE42),
                ),
                Text(title)
              ],
            ),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
                TextButton(onPressed: (){launchCall();}, child:const Text('695461461'))
              ],
            ),
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
    isClicked = false;
    super.initState();
  }
  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: primaryColor),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.only(top: 100.h, left: 20.w, right: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    StringManager.forgottenPassword,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: grey80),
                  ),
                  SvgPicture.asset(
                    AssetManager.forgottenPassword,
                    color: primaryColor,
                    height: 100.h,
                    width: 100.w,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _isPhone == true
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                _isPhone = false;
                                phoneController.clear();
                              });
                            },
                            child: const Text(
                              StringManager.useEmail,
                              style: TextStyle(color: primaryColor),
                            ),)
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                _isPhone = true;
                                emailController.clear();
                              });
                            },
                            child: const Text(
                                StringManager.usePhone,
                                style: TextStyle(color: primaryColor))),
                  ),
                  _isPhone
                      ? IntlPhoneField(
                          controller: phoneController,
                          pickerDialogStyle: PickerDialogStyle(
                            searchFieldInputDecoration:
                                inputDecoration(labelText: 'Chercher le pays'),
                          ),
                          dropdownIconPosition: IconPosition.trailing,
                          showCountryFlag: false,
                          decoration: inputDecoration(labelText: StringManager.phoneNumber),
                          onChanged: (phone) {
                            countryCode = phone.countryCode;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          initialCountryCode: 'CM',
                          validator: (val) {
                            if (val!.toString().isEmpty) {
                              return StringManager.invalidPhoneNumber;
                            }
                            return null;
                          },
                        )
                      : CustomTextField(
                          controller: emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          isEmail: true,
                          labelText: StringManager.email,
                          validateField: true,
                        ),
                  20.sBH,
                  SizedBox(
                    height: getProportionateScreenHeight(45),
                    width: double.infinity,
                    child: ElevatedButton(
                        style: loginButtonStyle(),
                        onPressed: isDisabledButton == false
                            ? () async {
                                // bool result =
                                //     await DataConnectionChecker().hasConnection;
                                if (((emailController.text.isNotEmpty ||
                                    phoneController.text.isNotEmpty) &&
                                    _formKey.currentState!.validate())) {
                                    if (_isPhone) {
                                      await ApiAuthService(
                                        context: context,
                                        progressDialog: getProgressDialog(context: context),
                                        fromLogin: false,
                                      )
                                          .forgotPasswordCode(
                                          telephone: phoneController.text,
                                          countryCode: countryCode);
                                    }
                                    else {
                                      await ApiAuthService(
                                        context: context,
                                        fromLogin: false,
                                        progressDialog: getProgressDialog(context: context),
                                      )
                                          .forgotPasswordCodeEmail(
                                          email: emailController.text);
                                    }
                                }
                                else  {
                                  Fluttertoast.showToast(msg: StringManager.invalidField,backgroundColor: primaryRed);
                                }
                              }
                            : null,
                        child:  Text(
                          StringManager.validate.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
