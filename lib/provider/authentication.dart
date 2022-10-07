import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lrf/pages/feed_page.dart';
import 'package:lrf/services/database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lrf/utils/utils.dart';

class Authentication {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => FeedPage(user: user)),
      );
    }

    return firebaseApp;
  }

  Future<User?> signInWithGoogle({required BuildContext context, required var mounted}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential = await auth.signInWithPopup(authProvider);
        user = userCredential.user;
      } catch (e) {
        Future.error(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential = await auth.signInWithCredential(credential);

          user = userCredential.user;

          if (user != null) {
            final res = await Database().createUser(
              user.displayName!,
              user.email!,
              userCredential.user!.uid,
              user.photoURL!,
            );
            if (res == "success") {
            } else {
              if (mounted) {
                showSnackBar(context, 'Something went wrong. Please Try Again.');
              }
            }
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            if (mounted) {
              showSnackBar(context, 'The account already exists with a different credential.');
            }
          } else if (e.code == 'invalid-credential') {
            if (mounted) {
              showSnackBar(context, 'Error occurred while accessing credentials. Try again.');
            }
          }
        } catch (e) {
          Future.error(e);
          if (mounted) {
            showSnackBar(context, 'Error occurred using Google Sign-In. Try again.');
          }
        }
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      showSnackBar(context, 'Error signing out. Try again.');
    }
  }
}
