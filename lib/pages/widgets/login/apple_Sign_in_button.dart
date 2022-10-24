import 'package:flutter/material.dart';
import 'package:lrf/main.dart';
import 'package:lrf/pages/feed_page.dart';
import 'package:lrf/pages/widgets/login/apple_signin_Avail.dart';
import 'package:lrf/provider/authentication.dart';
import 'package:lrf/utils/utils.dart';

import 'package:the_apple_sign_in/the_apple_sign_in.dart' as asi;

class AppleSignInButtonL extends StatefulWidget {
  const AppleSignInButtonL({
    super.key,
  });

  @override
  State<AppleSignInButtonL> createState() => _AppleSignInButtonLState();
}

class _AppleSignInButtonLState extends State<AppleSignInButtonL> {
  bool _isSigningIn = false;

  Future<void> _signInWithApple(BuildContext context) async {
    final appleSignInAvailable = await AppleSignInAvailable.check();
    String? currentUserId = sharedPreferences.getString('currentUserUid');
    bool? currentUserLoggedIn = sharedPreferences.getBool('isLoggedIn');

    try {
      setState(() {
        _isSigningIn = true;
      });
      if (appleSignInAvailable.isAvailable) {
        await Authentication().signInWithApple(scopes: [asi.Scope.email, asi.Scope.fullName], context: context, mounted: mounted);
        setState(() {
          _isSigningIn = false;
        });
        if (currentUserLoggedIn == true && currentUserId != null) {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const FeedPage()),
            );
          }
        }
      } else {
        if (mounted) {
          showSnackBar(context, 'Cannot sign in with apple');
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Something went wrong. Try again.');
      }
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: _isSigningIn
            ? const Hero(
                tag: 'loading',
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  backgroundColor: Colors.green,
                ),
              )
            : asi.AppleSignInButton(
                style: asi.ButtonStyle.black,
                type: asi.ButtonType.signIn,
                onPressed: () => _signInWithApple(context),
              ));
  }
}
