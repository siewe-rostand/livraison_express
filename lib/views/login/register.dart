import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:livraison_express/service/auth_service.dart';
import 'package:livraison_express/utils/string_manager.dart';
import 'package:livraison_express/views/login/verification_code.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/app-constant.dart';
import '../../data/user_helper.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  int _currentStep = 0;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  final _phoneTextController = TextEditingController();
  final _phone2TextController = TextEditingController();
  final nameTextController = TextEditingController();
  final surnameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final verificationCodeTextController = TextEditingController();
  String phoneNo = '';
  late String smsOTP;
  late String verificationId;
  String errorMessage = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool isClicked = false;
  String countryCode = '';
  bool isEmpty = true;
  getPhone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    phoneNo = preferences.getString('phone1') ?? '';
  }

  @override
  void initState() {
    getPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: Color(0xffE6E6E6)),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffE6E6E6),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 150,
                  child: Image.asset('img/logo.png'),
                ),
                !isLoading
                    ? Stepper(
                        controlsBuilder:
                            (BuildContext bContext, ControlsDetails detail) {
                          return _currentStep == 1
                              ? ElevatedButton(
                                  onPressed: () async {
                                   if (_formKeys[1].currentState!.validate()){
                                     await ApiAuthService(
                                         context: bContext,
                                         fromLogin: true,
                                         progressDialog: getProgressDialog(
                                             context: context))
                                         .register(
                                       username: "+" +
                                           countryCode +
                                           _phoneTextController.text,
                                       firstName:
                                       nameTextController.text,
                                       lastName:
                                       surnameTextController.text,
                                       email: emailTextController.text,
                                       password:
                                       passwordTextController.text,
                                       telephoneAlt:
                                       _phone2TextController.text,
                                       pwdConfirm:
                                       confirmPasswordTextController
                                           .text,
                                       telephone:
                                       _phoneTextController.text,
                                       countryCode: countryCode,
                                       licence: true.toString(),);
                                   }
                                  },
                                  child: const Text(
                                    "ENREGISTRER",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ))
                              : SizedBox(
                                  width:
                                      MediaQuery.of(bContext).size.width * 0.7,
                                  height: 40,
                                  child: ElevatedButton(
                                      onPressed: detail.onStepContinue,
                                      child: const Text(
                                        "CONTINUER",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffF3F3F3)),
                                      )),
                                );
                        },
                        type: StepperType.vertical,
                        physics: const ScrollPhysics(),
                        onStepContinue: continued,
                        currentStep: _currentStep,
                        onStepTapped: (step) => tapped(step),
                        steps: [
                            Step(
                                title: const Text('Information Personnelles'),
                                isActive: _currentStep >= 0,
                                state: _currentStep > 0
                                    ? StepState.complete
                                    : StepState.indexed,
                                content: Form(
                                  key: _formKeys[0],
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        keyboardType: TextInputType.name,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                            hintText: 'Nom ',
                                            suffixIcon: isEmpty == false
                                                ? IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        isClicked = true;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ))
                                                : null),
                                        controller: nameTextController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return StringManager.errorMessage;
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: 'Prenom '),
                                        controller: surnameTextController,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r"[a-zA-Z]+|\s"),
                                          )
                                        ],
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return StringManager.errorMessage;
                                          } else if (value.length < 4) {
                                            return 'minimum 4 lettres svp!';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.emailAddress,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        decoration: const InputDecoration(
                                            hintText: StringManager.email),
                                        controller: emailTextController,
                                        validator: (val) {
                                          if (!val!.isValidEmail) {
                                            return StringManager.errorMessage;
                                          }
                                          return null;
                                        },
                                      ),
                                      IntlPhoneField(
                                        keyboardType: TextInputType.phone,
                                        controller: _phoneTextController,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        showCountryFlag: false,
                                        dropdownIconPosition:
                                            IconPosition.trailing,
                                        decoration: const InputDecoration(
                                          hintText: '${StringManager.phoneNumber} 1',
                                        ),
                                        onChanged: (phone) {
                                          // print(phone.completeNumber);
                                          phoneNo = phone.number;
                                          countryCode = phone.countryCode;
                                        },
                                        initialCountryCode: 'CM',
                                        invalidNumberMessage: invalidPhone,
                                      ),
                                      IntlPhoneField(
                                        showCountryFlag: false,
                                        autovalidateMode:
                                            AutovalidateMode.disabled,
                                        dropdownIconPosition:
                                            IconPosition.trailing,
                                        decoration: const InputDecoration(
                                          hintText: '${StringManager.phoneNumber} 2',
                                        ),
                                        onChanged: (phone) {
                                          // print(phone.completeNumber);
                                        },
                                        initialCountryCode: 'CM',
                                        invalidNumberMessage: invalidPhone,
                                      ),
                                    ],
                                  ),
                                )),
                            Step(
                                title: const Text('Authentification'),
                                isActive: _currentStep >= 0,
                                state: _currentStep > 1
                                    ? StepState.complete
                                    : StepState.indexed,
                                content: Form(
                                  key: _formKeys[1],
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            labelText: StringManager.phoneNumber),
                                        enabled: false,
                                        controller: TextEditingController(
                                            text: _phoneTextController.text),
                                      ),
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration: const InputDecoration(
                                            hintText: StringManager.password),
                                        controller: passwordTextController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return StringManager.errorMessage;
                                          } else if (val.length < 8) {
                                            return 'Le mot de passe doit contenir aumoins 8 caractères';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration: const InputDecoration(
                                            hintText:
                                                'Confirmer le mot de passe'),
                                        controller: confirmPasswordTextController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return StringManager.errorMessage;
                                          } else if (passwordTextController
                                                  .text !=
                                              confirmPasswordTextController
                                                  .text) {
                                            return "les mots de passe ne sont pas les mêmes";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ))
                          ])
                    : const CircularProgressIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() async {
    if (_formKeys[_currentStep].currentState!.validate()){
      _currentStep < 3 ? setState(() => _currentStep += 1) : null;
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}

extension ExString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull {
    return this != null;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
}
