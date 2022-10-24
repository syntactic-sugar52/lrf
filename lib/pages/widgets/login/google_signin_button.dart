import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lrf/main.dart';
import 'package:lrf/pages/feed_page.dart';

import 'package:lrf/provider/authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  State<GoogleSignInButton> createState() => GoogleSignInButtonState();
}

class GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

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
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    elevation: MaterialStateProperty.all(12),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (mounted) {
                      setState(() {
                        _isSigningIn = true;
                      });
                    }

                    User? user = await Authentication().signInWithGoogle(context: context, mounted: mounted);
                    if (mounted) {
                      setState(() {
                        _isSigningIn = false;
                      });
                    }

                    if (user != null) {
                      sharedPreferences.setString('currentUserName', user.displayName.toString());

                      sharedPreferences.setString('currentUserEmail', user.email.toString());
                      sharedPreferences.setString(
                        'currentUserUid',
                        user.uid.toString(),
                      );

                      sharedPreferences.setBool('isLoggedIn', true);
                      if (mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const FeedPage()),
                        );
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        FaIcon(
                          FontAwesomeIcons.google,
                          size: 15,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
