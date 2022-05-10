import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:livraison_express/constant/app-constant.dart';
import 'package:livraison_express/service/fire-auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final nameTextController = TextEditingController();
  final surnameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final verificationCodeTextController = TextEditingController();
  late String phoneNo;
  late String smsOTP;
  late String verificationId;
  String errorMessage = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? _verificationId;
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
               !isLoading? Form(
                 key: _formKey,
                 child: Stepper(
                      controlsBuilder: (BuildContext context, ControlsDetails detail) {
                        return _currentStep == 1 ?ElevatedButton(
                            onPressed: () async{
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });}
                              if(passwordTextController.text == confirmPasswordTextController.text) {
                                User? user = await FireAuth.registerUsingEmailPassword(name: nameTextController.text, email: emailTextController.text, password: passwordTextController.text);
                                await phoneSignIn(phoneNumber: _phone2TextController.text).then((value) => debugPrint('success'));
                              }else{
                                debugPrint('error');
                              }

                            },
                            child: const Text(
                              "ENREGISTRER",
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold),
                            )):
                        ElevatedButton(
                            onPressed: detail.onStepContinue,
                            child: const Text(
                              "CONTINUER",
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold),
                            )) ;
                      },
                      type: StepperType.vertical,
                      physics: const ScrollPhysics(),
                      onStepContinue: continued,
                      currentStep: _currentStep,
                      onStepTapped: (step) => tapped(step),
                      steps: [
                        Step(
                            title: const Text('Information Personnelles'),
                            isActive: _currentStep >=0,
                            state: _currentStep >0? StepState.complete:StepState.indexed,
                            content: Column(
                              children: [
                                TextFormField(
                                  decoration:
                                  const InputDecoration(hintText: 'Nom '),
                                  controller: nameTextController,
                                ),
                                TextFormField(
                                  decoration:
                                  const InputDecoration(hintText: 'Prenom '),
                                  controller: surnameTextController,
                                ),
                                TextFormField(
                                  decoration:
                                  const InputDecoration(hintText: 'Email '),
                                  controller: emailTextController,
                                ),
                                IntlPhoneField(
                                  controller: _phoneTextController,
                                  showCountryFlag: false,
                                  dropdownIconPosition: IconPosition.trailing,
                                  decoration: const InputDecoration(
                                    hintText: 'Telephone 1',
                                  ),
                                  onChanged: (phone) {
                                    print(phone.completeNumber);
                                  },
                                  initialCountryCode: 'CM',
                                  invalidNumberMessage: constantUtil.invalid_phone,
                                ),
                                IntlPhoneField(
                                  controller: _phone2TextController,
                                  showCountryFlag: false,
                                  dropdownIconPosition: IconPosition.trailing,
                                  decoration: const InputDecoration(
                                    hintText: 'Telephone 2',
                                  ),
                                  onChanged: (phone) {
                                    print(phone.completeNumber);
                                  },
                                  initialCountryCode: 'CM',
                                  invalidNumberMessage: constantUtil.invalid_phone,
                                ),
                              ],
                            )),
                        Step(
                            title: const Text('Authentification'),
                            isActive: _currentStep >=0,
                            state: _currentStep >1? StepState.complete:StepState.indexed,
                            content: Column(
                              children: [
                                TextFormField(
                                  decoration:
                                  const InputDecoration(labelText: 'Telephone '),
                                  initialValue: _phoneTextController.text,
                                  enabled: false,
                                ),
                                TextFormField(
                                  decoration:
                                  const InputDecoration(hintText: 'Mot de passe '),
                                  controller: passwordTextController,
                                ),
                                TextFormField(
                                  decoration:
                                  const InputDecoration(hintText: 'Confirmer le mot de passe'),
                                  controller: confirmPasswordTextController,
                                ),
                              ],
                            ))
                      ]),
               ):CircularProgressIndicator()
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

  continued() async{
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'nom':nameTextController.text,
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

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      verificationCodeTextController.text = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      try{
        UserCredential credential =
        await user!.linkWithCredential(authCredential);
      }on FirebaseAuthException catch(e){
        if(e.code == 'provider-already-linked'){
          await _auth.signInWithCredential(authCredential);
        }
      }
      setState(() {
        isLoading = false;
      });
      // Navigator.pushNamedAndRemoveUntil(
      //     context, Constants.homeNavigate, (route) => false);
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      showMessage("The phone number entered is invalid!");
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    print(forceResendingToken);
    print("code sent");
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  void showMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text("Ok"),
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

  smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enter SMS Code'),
            content: SizedBox(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              TextButton(
                child: const Text('Done'),
                onPressed: () {

                  FirebaseAuth auth = FirebaseAuth.instance;
                  User? user =_auth.currentUser;
                  // auth.currentUser().then((user) {
                  //   if (user != null) {
                  //     Navigator.of(context).pop();
                  //   } else {
                  //     signIn();
                  //   }
                  // });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user =userCredential.user;
      final  currentUser = _auth.currentUser;
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/homepage');
    } catch (e) {
      print(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message!;
        });

        break;
    }
  }
  verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int? forceCodeResend]) {
      verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            verificationId = verId;
          },
          codeSent:
          smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> phoneSignIn1({required String phoneNumber,required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
     codeSent (String verId, [int? forceCodeResend]){
      _verificationId =verId;
      TextEditingController controller = TextEditingController();
      showDialog(context: context,
          builder: (BuildContext buildContext){
            return AlertDialog(
              content: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                    labelText: 'Verification code'
                ),
                onChanged: (value){
                  smsOTP = value;
                },
              ),
              actions: [TextButton(
                  onPressed: () async {
                    try {
                      final AuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: smsOTP,
                      );
                      final UserCredential userCredential = await _auth.signInWithCredential(credential);
                      User? user =userCredential.user;
                      final  currentUser = _auth.currentUser;
                      print(user);
                      Navigator.of(context).pop();
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('OK'))],
            );
          }
      );
    };
    try{
      await auth.verifyPhoneNumber(
        phoneNumber: '+237 '+ phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential){
          print(credential);
        },
        timeout: const Duration(minutes: 1),
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(milliseconds: 250),
                backgroundColor: Colors.red,
                content:
                Text('The provided phone number is not valid.'),
              ),
            );
            print('The provided phone number is not valid.');
          }

          // Handle other errors
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },);
    }catch(e){
      print(e);
    };
  }
}

class VerificationCode extends StatelessWidget {
  const VerificationCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

        ],
      ),
    );
  }
}

