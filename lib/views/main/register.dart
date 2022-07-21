import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:livraison_express/constant/app-constant.dart';
import 'package:livraison_express/service/api_auth_service.dart';
import 'package:livraison_express/views/main/login.dart';
import 'package:livraison_express/views/main/verification_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/user_helper.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  ConstantUtil constantUtil = ConstantUtil();
  int _currentStep = 0;
  final _phoneTextController = TextEditingController();
  final _phone2TextController = TextEditingController();
  final _phone1TextController = TextEditingController();
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isClicked = false;
  String? _verificationId;
  String countryCode='';
  bool isEmpty =true;
  getPhone()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    phoneNo =preferences.getString('phone1')??'';
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
                    ? Form(
                        key: _formKey,
                        child: Stepper(
                            controlsBuilder:
                                (BuildContext bContext, ControlsDetails detail) {
                              return _currentStep == 1
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                        }
                                        print('contry code $countryCode');
                                        if (passwordTextController.text ==
                                            confirmPasswordTextController
                                                .text) {
                                         await ApiAuthService(context: bContext,fromLogin: true,progressDialog: getProgressDialog(context: context)).register(
                                             username: "+"+countryCode+_phoneTextController.text,
                                             firstName: nameTextController.text,
                                             lastName: surnameTextController.text, email: emailTextController.text,
                                             password: passwordTextController.text, telephoneAlt: _phone2TextController.text,
                                             pwdConfirm: confirmPasswordTextController.text, telephone: _phoneTextController.text,
                                             countryCode: countryCode, licence: true.toString()).then((response)async{
                                               var body = json.decode(response.body);
                                               print('on value $body');
                                               String accessToken =body['access_token'];
                                               // debugPrint('access_token $accessToken');
                                               showMessage("Vos informations ont été enregistrées. Vous allez recevoir un code au numéro ${_phoneTextController.text} et à l'adresse ${emailTextController.text}.");
                                               await Future.delayed(const Duration(
                                                 seconds: 2),()=>
                                                   Navigator.of(bContext).pushReplacement(MaterialPageRoute(builder: (bContext)=> VerificationCode(
                                                     email: emailTextController.text,
                                                     phone: _phoneTextController.text,
                                                     token: accessToken,
                                                     resetPassword: false,
                                                     code: countryCode,
                                                   ))));

                                           // debugPrint('access_token \n${emailTextController.text}\n${_phoneTextController.text}\n$countryCode\n');
                                         }).catchError((onError){
                                           print('errpp// $onError');
                                           showMessage(onError.toString());

                                         });
                                         setState(() {
                                           isLoading=false;
                                         });
                                          // await phoneSignIn(
                                          //         phoneNumber:
                                          //             _phone2TextController
                                          //                 .text)
                                          //     .then((value) =>
                                          //         debugPrint('success'));
                                        } else {
                                          debugPrint('error');
                                        }
                                      },
                                      child: const Text(
                                        "ENREGISTRER",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ))
                                  : SizedBox(
                                width: MediaQuery.of(bContext).size.width*0.7,
                                    height: 40,
                                    child: ElevatedButton(
                                        onPressed: detail.onStepContinue,
                                        child: const Text(
                                          "CONTINUER",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            color: Color(0xffF3F3F3)
                                          ),
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
                                  content: Column(
                                    children: [
                                      TextFormField(
                                        decoration:  InputDecoration(
                                            hintText: 'Nom ',
                                          errorText: isClicked?'veuillez remplir ce champs':null,
                                          suffixIcon:isEmpty==false ?IconButton(onPressed:(){
                                            print('veuillez remplir ce champs');
                                              setState(() {
                                                isClicked =true;
                                              });
                                          }, icon: const Icon(Icons.error,color: Colors.red,)):null
                                        ),
                                        controller: nameTextController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r"[a-zA-Z]+|\s"),
                                          )
                                        ],
                                        validator: (value){
                                          if(value!.isEmpty){
                                            return'veuillez remplir ce champs';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: 'Prenom '),
                                        controller: surnameTextController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r"[a-zA-Z]+|\s"),
                                          )
                                        ],
                                        validator: (value){
                                          if(value!.isEmpty){
                                            return'veuillez remplir ce champs';
                                          }else if( value.length<4){
                                            return 'minimum 4 lettres svp!';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: 'Email '),
                                        controller: emailTextController,
                                        validator: (val){
                                          if(!val!.isValidEmail){
                                            return 'veuillez remplir ce champs';
                                          }
                                          return null;
                                        },
                                      ),
                                      IntlPhoneField(
                                        controller: _phoneTextController,
                                        showCountryFlag: false,
                                        dropdownIconPosition:
                                            IconPosition.trailing,
                                        decoration: const InputDecoration(
                                          hintText: 'Telephone 1',
                                        ),
                                        onChanged: (phone) {
                                          // print(phone.completeNumber);
                                          phoneNo=phone.number;
                                          countryCode =phone.countryCode;
                                        },
                                        initialCountryCode: 'CM',
                                        invalidNumberMessage:
                                            constantUtil.invalid_phone,
                                      ),
                                      IntlPhoneField(
                                        showCountryFlag: false,
                                        autovalidateMode: AutovalidateMode.disabled,
                                        dropdownIconPosition:
                                            IconPosition.trailing,
                                        decoration: const InputDecoration(
                                          hintText: 'Telephone 2',
                                        ),
                                        onChanged: (phone) {
                                          // print(phone.completeNumber);
                                        },
                                        initialCountryCode: 'CM',
                                        invalidNumberMessage:
                                            constantUtil.invalid_phone,
                                      ),
                                    ],
                                  )),
                              Step(
                                  title: const Text('Authentification'),
                                  isActive: _currentStep >= 0,
                                  state: _currentStep > 1
                                      ? StepState.complete
                                      : StepState.indexed,
                                  content: Column(
                                    children: [
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            labelText: 'Telephone '),
                                        enabled: false,
                                        controller: TextEditingController(text: _phoneTextController.text),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: 'Mot de passe '),
                                        controller: passwordTextController,
                                        validator: (val){
                                          if(val!.isEmpty){
                                            return "Veuillez remplir ce champ";
                                          } else if(val.length<8){
                                            return 'Le mot de passe doit contenir aumoins 8 caractères';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            hintText:
                                                'Confirmer le mot de passe'),
                                        controller:
                                            confirmPasswordTextController,
                                        validator: (val){
                                          if(val!.isEmpty){
                                            return "Veuillez remplir ce champ";
                                          } else if(passwordTextController.text != confirmPasswordTextController.text){
                                            return 'Contenu incorrect';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ))
                            ]),
                      )
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
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
    if(_formKey.currentState!.validate()){
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'nom': nameTextController.text,
      'prenom': surnameTextController.text,
      'phone1': _phoneTextController.text,
      'phone2': _phone2TextController.text,
      'email': emailTextController.text
    };
    sharedPreferences.setString('nom', nameTextController.text);
    sharedPreferences.setString('prenom', surnameTextController.text);
    sharedPreferences.setString('phone1', _phoneTextController.text);
    sharedPreferences.setString('phone2', _phone2TextController.text);
    sharedPreferences.setString('email', emailTextController.text);
  }

  void showMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                },
              )
            ],
          );
        }).then((value) {
      setState(() {
        isLoading = false;
      });
    });
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

  bool get isValidName{
    final nameRegExp = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword{
    final passwordRegExp =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull{
    return this!=null;
  }

  bool get isValidPhone{
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }

}