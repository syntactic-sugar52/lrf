import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_udid/flutter_udid.dart';

import 'package:lrf/main.dart';

import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';

import 'package:username_gen/username_gen.dart';

class Authentication with ChangeNotifier {
  Authentication(this._auth);

  Map<String, dynamic>? currentUser;
  String? udid;

  final FirebaseAuth _auth;

  // GET USER DATA
  // using null check operator since this method should be called only
  // when the user is logged in
  User get user => _auth.currentUser!;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // PHONE SIGN IN
  Future<String> phoneSignIn(
    BuildContext context,
    String phoneNumber,
    var mounted,
  ) async {
    TextEditingController codeController = TextEditingController();
    String udid = await FlutterUdid.consistentUdid;
    String svg = DateTime.now().toIso8601String();
    final usernameGen = UsernameGen().generate();
    String res = "Some error occurred";
    try {
      // FOR ANDROID, IOS
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        //  Automatic handling of the SMS code
        verificationCompleted: (PhoneAuthCredential credential) async {
          // !!! works only on android !!!
          await _auth.signInWithCredential(credential);
        },
        // Displays a message when verification fails
        verificationFailed: (e) {
          if (mounted) {
            showSnackBar(context, e.message!);
          }
        },

        // Displays a dialog box when OTP is sent
        codeSent: ((String verificationId, int? resendToken) async {
          showOTPDialog(
            codeController: codeController,
            context: context,
            onPressed: () async {
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: codeController.text.trim(),
                );

                // !!! Works only on Android, iOS !!!
                UserCredential userCredential = await _auth.signInWithCredential(credential);

                if (mounted) {
                  Navigator.of(context).pop();
                }

                if (userCredential.additionalUserInfo!.isNewUser) {
                  final res = await Database().createUser(
                    phoneNumber,
                    userCredential.user!.uid,
                    svg,
                    usernameGen,
                    udid.toString(),
                  );
                  if (res == "success") {
                    sharedPreferences.setString(
                      'currentUserUid',
                      userCredential.user!.uid,
                    );
                    sharedPreferences.setBool('isChecked', true);
                    sharedPreferences.setString('udid', udid.toString());
                  } else {
                    if (mounted) {
                      showSnackBar(context, 'Something went wrong. Please Try Again.');
                    }
                  }
                } else if (sharedPreferences.getString('udid') == udid) {
                  sharedPreferences.setString(
                    'currentUserUid',
                    userCredential.user!.uid,
                  );
                } else {
                  if (mounted) {
                    showSnackBar(context, 'Something went wrong. Please Try Again.');
                  }
                }
              } on FirebaseAuthException catch (e) {
                if (mounted) {
                  showSnackBar(context, 'Something went wrong. Please Try Again.');
                }
                Future.error(e);
              }
            },
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
      res = 'success';
    } catch (e) {
      res = e.toString();
      Future.error(e);
    }

    return res;
  }

  Future<void> signOut({required BuildContext context}) async {
    try {
      await _auth.signOut();
      sharedPreferences.remove('currentUserUid');
    } catch (e) {
      showSnackBar(context, 'Error signing out. Try again.');
    }
  }
}
