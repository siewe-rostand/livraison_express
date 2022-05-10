import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:livraison_express/service/api_auth_service.dart';
import 'package:livraison_express/service/login_api.dart';
import 'package:livraison_express/views/main/register.dart';

import '../../service/fire-auth.dart';
import '../home-page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscureText = true;
  bool _isPhone = false;
  bool _isProcessing=false;
  final _phoneTextController = TextEditingController();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // user.getIdToken(true).then((value) => print(value));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  void initState() {
    _isPhone = true;
    isObscureText = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(15),
        child: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return _isProcessing? const Center(child: CircularProgressIndicator(),): ListView(
                children: [
                  Image.asset('img/logo.png'),
                  Align(
                      alignment: Alignment.centerLeft,
                      child:_isPhone? TextButton(
                          onPressed: () {
                            setState(() {
                              _isPhone = !_isPhone;
                            });
                          },
                          child: const Text("Se connecter avec l'email ?")):TextButton(
                          onPressed: () {
                            setState(() {
                              _isPhone = !_isPhone;
                            });
                          },
                          child: const Text("Se connecter avec le numero de telephone ?"))),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _isPhone
                          ? IntlPhoneField(
                        controller: _phoneTextController,
                        decoration: InputDecoration(
                          labelText: 'Telephone',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onChanged: (phone) {
                          print(phone.completeNumber);
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
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>const MotDePasse()));
                            },
                            child: const Text("Mot de passe oublie ?")),
                      ),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ))),
                            onPressed: () async{
                              if(_phoneTextController.text!= null){
                                await FireAuth.phoneSignIn(phoneNumber: _phoneTextController.text, context: context);
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
                      child: Divider(),
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
                          onTap:()async{
                            User? user =
                                await FireAuth.signInWithGoogle(context: context);
                            // User? user= userCredential.user;
                            setState(() {
                              _isProcessing = false;
                            });
                            // print(user);

                            if (user != null) {
                              Navigator.of(context)
                                  .pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const HomePage(),
                                ),
                              );
                            }
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 33.0,
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: const Color(0xffF7F7F7),
                                child: Image.asset('img/social/google-logo.png'),
                              )),
                        ),
                        InkWell(
                          onTap: ()async{
                            User? user = await FireAuth.signInWithFacebook(context: context);
                            print(user);
                            setState(() {
                              _isProcessing = false;
                            });

                            if (user != null) {
                              Navigator.of(context)
                                  .pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const HomePage(),
                                ),
                              );
                            }
                          },
                          child: CircleAvatar(
                              radius: 33.0,
                              child: Image.asset('img/social/facebook-logo.png'),),
                        ),
                        InkWell(
                          onTap: ()async{
                            await FireAuth.performLogin('yahoo.com', ['openid mail-r'],
                                {'language': 'fr'});
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
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const RegistrationPage()));
                          }, child: const Text("creer un compte"))
                    ],
                  )
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
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
  bool _isPhone=false;
  @override
  void initState() {
    _isPhone =true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 100,left: 20,right: 20),
        child: Column(
          children:  [
            const Text('Mot de Passe oublie.',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
            const Icon(Icons.lock),
            Align(
              alignment: Alignment.centerLeft,
              child: _isPhone? TextButton(
                  onPressed: () {
                    setState(() {
                      _isPhone = !_isPhone;
                    });
                  },
                  child: const Text("Se connecter avec l'email ?")):TextButton(
                  onPressed: () {
                    setState(() {
                      _isPhone = !_isPhone;
                    });
                  },
                  child: const Text("Se connecter avec le numero de telephone ?")),
            ),
            _isPhone
                ? IntlPhoneField(
              pickerDialogStyle: PickerDialogStyle(
                searchFieldInputDecoration: const InputDecoration(
                  hintText: 'Chercher le pays'
                )
              ),
              dropdownIconPosition: IconPosition.trailing,
              showCountryFlag: false,
              decoration: const InputDecoration(
                labelText: 'Telephone',
              ),
              onChanged: (phone) {
                print(phone.completeNumber);
              },
              initialCountryCode: 'CM',
            )
                : TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                fillColor: Colors.white,
                filled: true,
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ))),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=>const ConfirmCode()));
                  },
                  child: const Text(
                    'VALIDER',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class ConfirmCode extends StatelessWidget {
  const ConfirmCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 100,right: 15,left: 15),
        child: Column(
          children: [
            Image.asset('img/logo.png'),
            const SizedBox(
              height: 15,
            ),
            const Text('Vous allez recevoir un code de verification par SMS dans 1 minute. Veuillez entrer ce code'),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Entrez le code'
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
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


