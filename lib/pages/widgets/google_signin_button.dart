import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass/glass.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/feed_page.dart';

import 'package:lrf/provider/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  Future saveUsertoLocal(String displayName, String uid, String photoUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('currentUserName', displayName.toString());
    prefs.setString('currentUserUid', uid.toString());
    prefs.setString('currentUserPhotoUrl', photoUrl.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: _isSigningIn
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                  elevation: MaterialStateProperty.all(12),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _isSigningIn = true;
                  });
                  User? user = await Authentication().signInWithGoogle(context: context, mounted: mounted);

                  setState(() {
                    _isSigningIn = false;
                  });

                  if (user != null) {
                    await saveUsertoLocal(user.displayName!, user.uid, user.photoURL!);

                    if (mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => FeedPage(
                                  user: user,
                                )),
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
                        size: 30,
                        color: Colors.green,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
