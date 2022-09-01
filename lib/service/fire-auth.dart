import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:livraison_express/model/user.dart';
import 'package:logger/logger.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local_db/db-helper.dart';
import '../data/user_helper.dart';
import 'api_auth_service.dart';

class FireAuth {
  final logger = Logger();
  final ProgressDialog progressDialog;
  FireAuth({required this.progressDialog});
  // register new user

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    progressDialog.show();
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
        if (user != null) {
          final idToken = await user.getIdToken();
          ApiAuthService(
                  context: context,
                  fromLogin: true,
                  progressDialog: getProgressDialog(context: context))
              .getAccessToken(firebaseTokenId: idToken).catchError((onError){

          });
          // if (kDebugMode) {
          //   log("$idToken ???");
          // }
        } else {
          ApiAuthService(
                  context: context,
                  progressDialog: getProgressDialog(context: context))
              .unAuthenticated();
        }
      } catch (e) {
        progressDialog.hide();
        e is FirebaseException
            ? ApiAuthService(
                    context: context,
                    progressDialog: getProgressDialog(context: context))
                .unAuthenticated(message: e.message)
            : ApiAuthService(
                    context: context,
                    progressDialog: getProgressDialog(context: context))
                .unAuthenticated();
      }
    }

    return user;
  }

  static Future<User?> signInWithGoogle1(
      {required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }

  static Future<User?> signInUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      print('success $user');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showMessage(e, context);
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showMessage(e, context);
        print('Wrong password provided.');
      }
    } catch (e) {
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

  static Future<void> signOutFromGoogle() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    DBHelper dbHelper = DBHelper();
    // await dbHelper.deleteAll();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    User? user = _auth.currentUser;
    // print(user!.providerData[0].providerId);
    if (user != null) {
      if (user.providerData[0].providerId == 'facebook.com') {
        await FacebookAuth.instance.logOut();
      }
      if (user.providerData[0].providerId == 'google.com') {
        await _googleSignIn.signOut();
      }
      if (user.providerData[0].providerId == 'yahoo.com') {}
    }
    await _auth.signOut();
  }

  Future<User?> signInWithFacebook({required BuildContext context}) async {
    User? user;
    progressDialog.show();
    try {
      progressDialog.hide();
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      UserCredential? userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      user = userCredential.user;
      AppUser1 appUser1 = AppUser1();
      appUser1.email = user?.email;
      appUser1.firstname = user?.displayName;
      appUser1.lastname = user?.displayName;
      // appUser1.id =user?.uid as int?;
      String? token = await user?.getIdToken();
      debugPrint('firebase token ${loginResult.accessToken}');
      var b = await ApiAuthService(
              context: context,
              fromLogin: true,
              progressDialog: getProgressDialog(context: context))
          .getAccessToken(firebaseTokenId: token!);
      print('/// ${b.body}');
    } on FirebaseAuthException catch (e) {
      progressDialog.hide();
      if (e.code == 'account-exists-with-different-credential') {
        debugPrint('account-exists-with-different-credential $e');
        showMessage(e, context);
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
        showMessage(e, context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content:
                Text('Error occurred while accessing credentials. Try again.'),
          ),
        );
      }
    } catch (e) {
      progressDialog.hide();
      print(" face book $e");
    }
    return user;
  }

  static void showMessage(FirebaseAuthException e, BuildContext context,
      {bool? isLoading}) {
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
                  isLoading = false;
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

  static Future<void> signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    preferences.clear();
    await _auth.signOut();
    await _googleSignIn.signOut();
    DBHelper dbHelper = DBHelper();
    // await dbHelper.deleteAll();
  }
}
