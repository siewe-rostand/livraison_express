import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:livraison_express/constant/all-constant.dart';
import 'package:livraison_express/data/user_helper.dart';
import 'package:livraison_express/service/api_auth_service.dart';
import 'package:livraison_express/utils/main_utils.dart';
import 'package:livraison_express/utils/size_config.dart';
import 'package:livraison_express/views/login/register.dart';
import 'package:livraison_express/views/login/verification_code.dart';
import 'package:livraison_express/views/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/auto_gene.dart';
import '../../model/city.dart';
import '../../service/fire-auth.dart';
import '../../service/main_api_call.dart';
import '../home/home-page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String routeName = "/login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscureText = true;
  bool _isPhone = false;
  bool _isProcessing = false;
  final _phoneTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final emailTextController = TextEditingController();
  String countryCode = '';
  List<City> cities = [];

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    // User? user = FirebaseAuth.instance.currentUser;
    //
    // if (user != null) {
    //   List<Modules> modules = await MainApi.getModuleConfigs(city: "douala");
    //   // user.getIdToken(true).then((value) => print(value));
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (context) =>  HomePage(
    //         modules: modules,
    //       ),
    //     ),
    //   );
    // }

    return firebaseApp;
  }

  void showMessage({required String message, required String title}) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                  setState(() {
                    _isProcessing = false;
                  });
                },
              )
            ],
          );
        }).then((value) {
      setState(() {
        _isProcessing = false;
      });
    });
  }

  @override
  void initState() {
    _isPhone = true;
    isObscureText = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: primaryColor),
      child: Scaffold(
        body: Container(
            margin: const EdgeInsets.all(15),
            child: ListView(
              children: [
                Image.asset('img/logo.png'),
                Align(
                    alignment: Alignment.centerLeft,
                    child: _isPhone
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                _isPhone = !_isPhone;
                              });
                            },
                            child: const Text("Se connecter avec l'email ?"))
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                _isPhone = !_isPhone;
                              });
                            },
                            child: const Text(
                                "Se connecter avec le numero de telephone ?"))),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isPhone
                        ? IntlPhoneField(
                            controller: _phoneTextController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Telephone',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onChanged: (phone) {
                              countryCode = phone.countryCode;
                            },
                            initialCountryCode: 'CM',
                          )
                        : TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              fillColor: Colors.white,
                              filled: true,
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32)),
                            ),
                            controller: emailTextController,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const MotDePasse()));
                          },
                          child: const Text("Mot de passe oublie ?")),
                    ),
                    !_isProcessing
                        ? Container()
                        : const CircularProgressIndicator(),
                    SizedBox(
                      height: getProportionateScreenHeight(45),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ))),
                          onPressed: () async {
                            if (_phoneTextController.text.isNotEmpty) {
                              await ApiAuthService(
                                      context: context,
                                      fromLogin: true,
                                      progressDialog:
                                          getProgressDialog(context: context))
                                  .signInWithPhone(
                                      telephone: _phoneTextController.text,
                                      countryCode: countryCode,
                                      password: passwordTextController.text);
                            }
                            if (emailTextController.text.isNotEmpty) {
                              ApiAuthService(
                                      context: context,
                                      fromLogin: true,
                                      progressDialog:
                                          getProgressDialog(context: context))
                                  .signInWithEmail(emailTextController.text,
                                      passwordTextController.text);

                            }
                          },
                          child: const Text(
                            'CONNEXION',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(children: const [
                  Expanded(
                    child: Divider(
                      thickness: 1.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Ou'),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1.5,
                    ),
                  )
                ]),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          await FireAuth(
                                  progressDialog:
                                      getProgressDialog(context: context))
                              .signInWithGoogle(context: context);
                        },
                        child: CircleAvatar(
                            backgroundColor: const Color(0xff4d000000),
                            radius: 30.0,
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xffF7F7F7),
                              child: SvgPicture.asset(
                                'img/social/ic_google_icon.svg',
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () async {
                          await FireAuth(
                                  progressDialog:
                                      getProgressDialog(context: context))
                              .signInWithFacebook(context: context)
                              .then((value) {
                            // setState(() {
                            //   _isProcessing = true;
                            // });
                          }).catchError((onError) {});

                          // if (user != null) {
                          //   Navigator.of(context)
                          //       .pushReplacement(
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //       const HomePage(),
                          //     ),
                          //   );
                          // }
                        },
                        child: CircleAvatar(
                          radius: 33.0,
                          child: SvgPicture.asset(
                            'img/social/ic_facebook_logo.svg',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await FireAuth.performLogin('yahoo.com',
                              ['openid mail-r'], {'language': 'fr'});
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 35.0,
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.purple.shade800,
                              child: CircleAvatar(
                                backgroundColor: Colors.pink,
                                radius: 26,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(32),
                                    child: Image.asset(
                                      'img/social/yahoo.png',
                                      height: 53,
                                      fit: BoxFit.fill,
                                    )),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vous etes nouveau?',
                      style: TextStyle(color: Colors.black38),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationPage()));
                        },
                        child: const Text("creer un compte"))
                  ],
                )
              ],
            )
            // FutureBuilder(
            //   future: _initializeFirebase(),
            //   builder: (context,snapshot){
            //     if(snapshot.connectionState == ConnectionState.done){
            //       return !_isProcessing? ListView(
            //         children: [
            //           Image.asset('img/logo.png'),
            //           Align(
            //               alignment: Alignment.centerLeft,
            //               child:_isPhone? TextButton(
            //                   onPressed: () {
            //                     setState(() {
            //                       _isPhone = !_isPhone;
            //                     });
            //                   },
            //                   child: const Text("Se connecter avec l'email ?")):TextButton(
            //                   onPressed: () {
            //                     setState(() {
            //                       _isPhone = !_isPhone;
            //                     });
            //                   },
            //                   child: const Text("Se connecter avec le numero de telephone ?"))),
            //           const SizedBox(
            //             height: 10,
            //           ),
            //           Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               _isPhone
            //                   ? IntlPhoneField(
            //                 controller: _phoneTextController,
            //                 decoration: InputDecoration(
            //                   labelText: 'Telephone',
            //                   border: OutlineInputBorder(
            //                     borderRadius: BorderRadius.circular(30),
            //                   ),
            //                 ),
            //                 onChanged: (phone) {
            //                   countryCode =phone.countryCode;
            //                 },
            //                 initialCountryCode: 'CM',
            //               )
            //                   : TextFormField(
            //                 keyboardType: TextInputType.emailAddress,
            //                 decoration: InputDecoration(
            //                   floatingLabelBehavior: FloatingLabelBehavior.auto,
            //                   fillColor: Colors.white,
            //                   filled: true,
            //                   labelText: 'Email',
            //                   border: OutlineInputBorder(
            //                       borderRadius: BorderRadius.circular(32)),
            //                 ),
            //                 controller: emailTextController,
            //               ),
            //               const SizedBox(
            //                 height: 10,
            //               ),
            //               TextFormField(
            //                 decoration: InputDecoration(
            //                   floatingLabelBehavior: FloatingLabelBehavior.auto,
            //                   fillColor: Colors.white,
            //                   filled: true,
            //                   labelText: 'Mot de passe',
            //                   border: OutlineInputBorder(
            //                       borderRadius: BorderRadius.circular(32)),
            //                   suffixIcon: IconButton(
            //                     icon: isObscureText
            //                         ? const Icon(Icons.visibility)
            //                         : const Icon(Icons.visibility_off),
            //                     onPressed: () {
            //                       setState(() {
            //                         isObscureText = !isObscureText;
            //                       });
            //                     },
            //                   ),
            //                 ),
            //                 obscureText: isObscureText,
            //                 controller: passwordTextController,
            //               ),
            //               Align(
            //                 alignment: Alignment.centerRight,
            //                 child: TextButton(
            //                     onPressed: () {
            //                       Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>const MotDePasse()));
            //                     },
            //                     child: const Text("Mot de passe oublie ?")),
            //               ),
            //               SizedBox(
            //                 height: 45,
            //                 width: double.infinity,
            //                 child: ElevatedButton(
            //                     style: ButtonStyle(
            //                         shape:
            //                         MaterialStateProperty.all<RoundedRectangleBorder>(
            //                             RoundedRectangleBorder(
            //                               borderRadius: BorderRadius.circular(25.0),
            //                             ))),
            //                     onPressed: () async{
            //                       setState(() {
            //                         _isProcessing = true;
            //                       });
            //                       if(_phoneTextController.text!= null){
            //                         print(countryCode);
            //                         List<Modules> modules = await MainApi.getModuleConfigs(city: "douala");
            //                         await ApiAuthService.login(telephone: _phoneTextController.text, countryCode: countryCode, password: passwordTextController.text)
            //                         .then((value) {
            //                           String accessToken =value['access_token'];
            //                           token =accessToken;
            //                           // print(token);
            //                           Navigator.of(context).pushReplacement(
            //                               MaterialPageRoute(builder: (BuildContext context) =>  HomePage(
            //                                 modules: modules,
            //                               )));
            //                         });
            //                       }
            //                     },
            //                     child: const Text(
            //                       'CONNEXION',
            //                       style: TextStyle(fontWeight: FontWeight.bold),
            //                     )),
            //               ),
            //             ],
            //           ),
            //           const SizedBox(
            //             height: 20,
            //           ),
            //           Row(children: const [
            //             Expanded(
            //               child: Divider(),
            //             ),
            //             Padding(
            //               padding: EdgeInsets.all(8.0),
            //               child: Text('Ou'),
            //             ),
            //             Expanded(
            //               child: Divider(
            //                 thickness: 1.5,
            //               ),
            //             )
            //           ]),
            //           Container(
            //             margin: const EdgeInsets.symmetric(vertical: 20),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               children: [
            //                 InkWell(
            //                   onTap:()async{
            //                     User? user =
            //                         await FireAuth.signInWithGoogle(context: context);
            //                     // GoogleSignIn googleSignIn = GoogleSignIn();
            //                     // GoogleSignInAccount? account = await googleSignIn.signIn();
            //                     // // User? user= userCredential.user;
            //                     // var ur= await FireAuth.firebaseGoogleAuth(account!, context: context);
            //                     // debugPrint('google sign $ur');
            //                     setState(() {
            //                       _isProcessing = false;
            //                     });
            //                     // print(user);
            //
            //                     if (user != null) {
            //                       Navigator.of(context)
            //                           .pushReplacement(
            //                         MaterialPageRoute(
            //                           builder: (context) =>
            //                               const HomePage(),
            //                         ),
            //                       );
            //                     }
            //                   },
            //                   child: CircleAvatar(
            //                       backgroundColor: const Color(0xff4d000000),
            //                       radius: 30.0,
            //                       child: CircleAvatar(
            //                         radius: 28,
            //                         backgroundColor: const Color(0xffF7F7F7),
            //                         child: SvgPicture.asset('img/social/ic_google_icon.svg',
            //                         ),
            //                       )),
            //                 ),
            //                 InkWell(
            //                   onTap: ()async{
            //                     User? user = await FireAuth.signInWithFacebook(context: context);
            //                     print(user);
            //                     setState(() {
            //                       _isProcessing = true;
            //                     });
            //
            //                     // if (user != null) {
            //                     //   Navigator.of(context)
            //                     //       .pushReplacement(
            //                     //     MaterialPageRoute(
            //                     //       builder: (context) =>
            //                     //       const HomePage(),
            //                     //     ),
            //                     //   );
            //                     // }
            //                   },
            //                   child: CircleAvatar(
            //                       radius: 33.0,
            //                       child: SvgPicture.asset('img/social/ic_facebook_logo.svg',
            //                       color: Colors.white,),),
            //                 ),
            //                 InkWell(
            //                   onTap: ()async{
            //                     await FireAuth.performLogin('yahoo.com', ['openid mail-r'],
            //                         {'language': 'fr'});
            //                   },
            //                   child: CircleAvatar(
            //                       backgroundColor: Colors.black54,
            //                       radius: 35.0,
            //                       child: CircleAvatar(
            //                         radius: 32,
            //                         backgroundColor: Colors.purple.shade800,
            //                         child: CircleAvatar(
            //                           backgroundColor: Colors.pink,
            //                           radius: 26,
            //                           child: ClipRRect(
            //                               borderRadius: BorderRadius.circular(32),
            //                               child: Image.asset(
            //                                 'img/social/yahoo.png',
            //                                 height: 53,
            //                                 fit: BoxFit.fill,
            //                               )),
            //                         ),
            //                       )),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               const Text(
            //                 'Vous etes nouveau?',
            //                 style: TextStyle(color: Colors.black38),
            //               ),
            //               TextButton(
            //                   onPressed: () {
            //                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const RegistrationPage()));
            //                   }, child: const Text("creer un compte"))
            //             ],
            //           )
            //         ],
            //       ):
            //       const Center(child: CircularProgressIndicator(),);
            //     }
            //     return const Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   },
            // )
            ),
      ),
    );
  }
}

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

class ConfirmCode extends StatelessWidget {
  const ConfirmCode(
      {Key? key, this.phone, this.email, this.token, this.resetPassword})
      : super(key: key);
  final String? phone;
  final String? email;
  final String? token;
  final bool? resetPassword;

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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Entrez le code'),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ))),
                  onPressed: () {},
                  child: const Text(
                    'VALIDER',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                  onPressed: () {},
                  child: const Text("Se connecter avec l'email ?")),
            )
          ],
        ),
      ),
    );
  }
}
