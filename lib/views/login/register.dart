import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:livraison_express/service/auth_service.dart';
import 'package:livraison_express/views/login/verification_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/app-constant.dart';
import '../../data/user_helper.dart';
import '../../utils/size_config.dart';

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
  String errorMessage = '';
  bool isLoading = false;
  bool isClicked = false;
  String countryCode='',code='237';
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
                    ? Stepper(
                        controlsBuilder:
                            (BuildContext bContext, ControlsDetails detail) {
                          return _currentStep == 1
                              ? ElevatedButton(
                                  onPressed: () async {
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
                                           String accessToken =body['access_token'];
                                               UserHelper.token = accessToken;
                                               UserHelper.currentUser1?.token=accessToken;
                                           // ApiAuthService(context: context).getUserProfile(accessToken);
                                           showMessage(context: bContext,title: "Félicitation",
                                               errorMessage: "Vos informations ont été enregistrées. Vous allez recevoir un code au numéro ${_phoneTextController.text} et à l'adresse ${emailTextController.text}."
                                           );
                                           await Future.delayed(const Duration(
                                             seconds: 2),(){
                                             Navigator.of(bContext).pushReplacement(MaterialPageRoute(builder: (bContext)=> VerificationCode(
                                               email: emailTextController.text,
                                               phone: _phoneTextController.text,
                                               token: accessToken,
                                               resetPassword: false,
                                               code: countryCode,
                                             )));
                                           });

                                       // debugPrint('access_token \n${emailTextController.text}\n${_phoneTextController.text}\n$countryCode\n');
                                     }).catchError((onError){
                                       print('errpp// $onError');
                                       showMessage(title: "ERROR",
                                           errorMessage: "Le donner existe deja", context: bContext,negativeText: "OK");

                                     });
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
                              content: Form(
                                key: _formKeys[0],
                                child: Column(
                                  children: [
                                    TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.name,
                                      decoration:  InputDecoration(
                                          hintText: 'Nom ',
                                        suffixIcon:isEmpty==false ?IconButton(onPressed:(){
                                            setState(() {
                                              isClicked =true;
                                            });
                                        }, icon: const Icon(Icons.error,color: Colors.red,)):null
                                      ),
                                      controller: nameTextController,
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return'veuillez remplir ce champs';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.emailAddress,
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
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.phone,
                                      controller: _phoneTextController,
                                      showCountryFlag: false,
                                      dropdownIconPosition:
                                          IconPosition.trailing,
                                      decoration: const InputDecoration(
                                        hintText: 'Telephone 1',
                                      ),
                                      onChanged: (phone) {
                                        phoneNo=phone.number;
                                        countryCode =phone.countryCode;
                                      },
                                      initialCountryCode: 'CM',
                                      invalidNumberMessage:
                                          invalid_phone,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(width: 1,color: Colors.black45)
                                        )
                                      ),
                                      child: Row(
                                        children: [
                                          Row(children: [
                                            Text("+$code"),
                                            IconButton(
                                                onPressed: (){
                                                  showCountryPicker(context: context, onSelect:(val){
                                                    setState(() {
                                                      code = val.phoneCode;
                                                    });
                                                  });
                                                },
                                                icon: const Icon(Icons.arrow_drop_down,color: Colors.black45,)
                                            )
                                          ],),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _phone2TextController,
                                              keyboardType: TextInputType.emailAddress,
                                              decoration: const InputDecoration(
                                                  hintText: 'Telephone 2 ',
                                                border: InputBorder.none
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(30),
                                    )
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
                                          labelText: 'Telephone '),
                                      enabled: false,
                                      controller: TextEditingController(text: _phoneTextController.text),
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.visiblePassword,
                                      decoration: const InputDecoration(
                                          hintText: 'Mot de passe '),
                                      controller: passwordTextController,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Veuillez remplir ce champ";
                                        } else if(val.length<8){
                                          return 'Le mot de passe doit contenir au moins 8 caractères';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.visiblePassword,
                                      decoration: const InputDecoration(
                                          hintText:
                                              'Confirmer le mot de passe'),
                                      controller:
                                          confirmPasswordTextController,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
    // _currentStep < 3 ? setState(() => _currentStep += 1) : null;
    if(_formKeys[_currentStep].currentState!.validate()){
      switch (_currentStep){
        case 0:
          setState(() => _currentStep += 1);
          break;
        default:
          break;
      }
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