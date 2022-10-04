import 'package:flutter/material.dart';
import 'package:lrf/constants/constants.dart';

import 'package:lrf/pages/widgets/google_signin_button.dart';

import 'package:lrf/provider/authentication.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kAppBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const FlutterLogo(
                size: 120,
              ),
              const Spacer(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hey There,\nWelcome Back',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login to your account to continue',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const Spacer(),
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton();
                  }
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green,
                    ),
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ));
  }
}
