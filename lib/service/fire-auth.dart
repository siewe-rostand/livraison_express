import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local_db/db-helper.dart';
import 'api_auth_service.dart';

class FireAuth{
  // register new user
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  })async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try{
      UserCredential userCredential =await auth.createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;
    }on FirebaseAuthException catch (e){
      if(e.code == 'weak-Password') {
        print('the password provided is too short');
      }
      else if(e.code == 'email-already-in-use') {
        print('Account already exist for that email');
      }else{
        print(e);
      }
    }catch (e){
      print(e);
    }
    return user;
  }
  static Future<void> verifyPhoneNumber(
      String phone,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
      PhoneCodeSent codeSent,
      Duration duration,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.verifyPhoneNumber(
        phoneNumber: phone,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        codeSent: codeSent,
        timeout: duration,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed);
  }

  static Future<void> phoneSignIn({required String phoneNumber,required BuildContext context}) async {
    String _verificationId;
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
              ),
              actions: [TextButton(
                  onPressed: (){

                  },
                  child: const Text('OK'))],
            );
          }
      );
    }
    try{
      await auth.verifyPhoneNumber(
        phoneNumber: '+237 '+ phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential){
          print(credential);
        },
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

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
        auth.currentUser?.getIdToken();
        String? token =await user?.getIdToken();
        debugPrint('token$token');
        user?.getIdToken().then((value) {
          print('user token from firebase $value');
          var q = ApiAuthService.getAccessToken( firebaseTokenId: value);
        });

        // print('user  $user');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content:
            Text('Successful sign in with google account'),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 1),
              backgroundColor: Colors.red,
              dismissDirection: DismissDirection.up,
              content:
              Text('The account already exists with a different credential.'),
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content:
              Text('Error occurred while accessing credentials. Try again.'),
            ),
          );
        }else{
          print(e);
        }
      } catch (e) {
        print('err $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error occurred using Google Sign-In. Try again.'),
          ),
        );
      }
    }

    return user;
  }

  static Future<User?> signInUsingEmailPassword({required String email, required String password,required BuildContext context
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      print('success $user');
    // }
    // on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     showMessage(e, context);
    //     print('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     showMessage(e, context);
    //     print('Wrong password provided.');
    //   }
    }catch(e){
      print(e);
    }

    return user;
  }

  // refresh user info
  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;
    print(refreshedUser?.emailVerified);
    return refreshedUser;
  }

  static Future<void> signOutFromGoogle() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    DBHelper dbHelper=DBHelper();
    await dbHelper.deleteAll();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    User? user = _auth.currentUser;
    // print(user!.providerData[0].providerId);
    if(user!= null){
      if(user.providerData[0].providerId == 'facebook.com'){
        await FacebookAuth.instance.logOut();
      }
      if(user.providerData[0].providerId == 'google.com'){
        await _googleSignIn.signOut();
      }
      if(user.providerData[0].providerId == 'yahoo.com'){}
    }
    await _auth.signOut();
  }
  static Future<User?> signInWithFacebook({required BuildContext context}) async {
    User? user;
   try{
     // Trigger the sign-in flow
     final LoginResult loginResult = await FacebookAuth.instance.login();

     // Create a credential from the access token
     final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

     // Once signed in, return the UserCredential
     UserCredential? userCredential =await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
     user =userCredential.user;
     String? token =await user?.getIdToken();
      print('firebase token $token');
     var b=await ApiAuthService.getAccessToken(firebaseTokenId: token!);
     print('/// ${b.body}');
   }on FirebaseAuthException catch (e) {
     if (e.code == 'account-exists-with-different-credential') {
       debugPrint('account-exists-with-different-credential $e');
       List<String> emailList = await FirebaseAuth.instance
           .fetchSignInMethodsForEmail(e.email!);
       showMessage(e,context);
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           duration: Duration(seconds: 1),
           backgroundColor: Colors.red,
           dismissDirection: DismissDirection.up,
           content:
           Text('The account already exists with a different credential.'),
         ),
       );
     } else if (e.code == 'invalid-credential') {
       debugPrint('invalid credential $e');
       showMessage(e,context);
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           backgroundColor: Colors.red,
           content:
           Text('Error occurred while accessing credentials. Try again.'),
         ),
       );
     }
   }
   catch(e){
     print(e);
   }
   return user;
  }

  static void showMessage(FirebaseAuthException e,BuildContext context,{bool? isLoading}) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(e.message!),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                  isLoading=false;
                },
              )
            ],
          );
        });
  }

  static Future<void> performLogin(String provider, List<String> scopes,
      Map<String, String> parameters) async {
    try {
      await FirebaseAuthOAuth().openSignInFlow(provider, scopes, parameters);
    } on PlatformException catch (error) {
      debugPrint("${error.code}: ${error.message}");
      print(error);
    }
  }
  static Future<void> signOut()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    DBHelper dbHelper=DBHelper();
    await dbHelper.deleteAll();
  }
}