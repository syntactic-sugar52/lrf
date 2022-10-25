import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lrf/main.dart';
import 'package:lrf/pages/feed_page.dart';
import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class Authentication extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic>? currentUser;
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<User?> signInWithGoogle({required BuildContext context, required var mounted}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    String? svg;
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

        if (user != null && userCredential.additionalUserInfo!.isNewUser) {
          svg = DateTime.now().toIso8601String();
          sharedPreferences.setString('currentUserName', user.displayName.toString());
          sharedPreferences.setString('currentUserPhotoUrl', svg.toString());
          sharedPreferences.setString('currentUserEmail', user.email.toString());
          sharedPreferences.setString(
            'currentUserUid',
            userCredential.user!.uid,
          );
          sharedPreferences.setBool('isLoggedIn', true);
          final res = await Database().createUser(
            user.displayName!,
            user.email!,
            userCredential.user!.uid,
            svg,
          );
          if (res == "success") {
          } else {
            if (mounted) {
              showSnackBar(context, 'Something went wrong. Please Try Again.');
            }
          }
        } else if (user?.uid == sharedPreferences.getString('currentUserUid') && sharedPreferences.getBool('isLoggedIn') == false) {
          sharedPreferences.setBool('isLoggedIn', true);
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

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();
      user = null;
      sharedPreferences.setBool('isLoggedIn', false);
      print('isLoggin false');
    } catch (e) {
      showSnackBar(context, 'Error signing out. Try again.');
    }
  }

  Future<User> signInWithApple({List<Scope> scopes = const [], required var mounted, required BuildContext context}) async {
    User? user;
    String? svg;
    // 1. perform the sign-in request
    FirebaseAuth auth = FirebaseAuth.instance;
    final result = await TheAppleSignIn.performRequests([AppleIdRequest(requestedScopes: scopes)]);

    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential appleIdCredential = result.credential!;

        OAuthProvider oAuthProvider = OAuthProvider('apple.com');
        final AuthCredential credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;

        final fullName = appleIdCredential.fullName;
        final email = appleIdCredential.email;
        // if first time user and has data
        if (userCredential.additionalUserInfo!.isNewUser && user != null) {
          svg = DateTime.now().toIso8601String();
          final displayName = '${fullName?.givenName} ${fullName?.familyName}';
          sharedPreferences.setString('currentUserPhotoUrl', svg);
          // create user in db
          final res = await Database().createUser(
            displayName,
            appleIdCredential.email!,
            userCredential.user!.uid,
            svg,
          );

          if (res == "success") {
            // save credentials to local
            sharedPreferences.setBool('isLoggedIn', true);
            sharedPreferences.setString('currentUserName', displayName.toString());
            sharedPreferences.setString('currentUserEmail', email.toString());
            sharedPreferences.setString(
              'currentUserUid',
              userCredential.user!.uid,
            );
            //navigate to feed page
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const FeedPage()),
              );
            }
          } else {
            if (mounted) {
              showSnackBar(context, 'Something went wrong. Please Try Again.');
            }
          }
          // saved uid is equal to auth uid and when isLoggedIn is false
        } else if (sharedPreferences.getString('currentUserUid') == user?.uid &&
            sharedPreferences.getBool('isLoggedIn') == false &&
            userCredential.additionalUserInfo!.isNewUser == false) {
          // set isLoggedIn to true
          sharedPreferences.setBool('isLoggedIn', true);
        }

        return user!;

      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );

      default:
        throw UnimplementedError();
    }
  }

  Future<String> onStartUp() async {
    String retVal = 'error';
    User? firebaseUser = auth.currentUser;
    bool? currentUserLoggedIn = sharedPreferences.getBool('isLoggedIn');

    try {
      if (firebaseUser != null) {
        currentUser = await Database().getUserDetails(uid: firebaseUser.uid);
        if (currentUser!.isNotEmpty && currentUserLoggedIn == true) {
          retVal = 'success';
        }
      }
    } on Exception catch (e) {
      Future.error(e);
    }

    return retVal;
  }
}
