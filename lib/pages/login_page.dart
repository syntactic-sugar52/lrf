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
              const SizedBox(
                width: 280,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black,
                  child: Text('LR', style: TextStyle(color: Colors.green, fontSize: 40, fontWeight: FontWeight.w700, fontFamily: 'Roboto')),
                ),
              ),
              const Spacer(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hey there,',
                  style: TextStyle(fontSize: 24, color: Colors.white70),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login or Sign up to your account to continue',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
              const Spacer(),
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong. Try agin.');
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
