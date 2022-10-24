import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/widgets/login/apple_Sign_in_button.dart';

import 'package:lrf/pages/widgets/login/google_signin_button.dart';

import 'package:lrf/provider/authentication.dart';

import 'feed_page.dart';

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
              Card(color: Colors.transparent, elevation: 12, child: SizedBox(width: 220, child: Image.asset('assets/LRlogo.png')).asGlass()),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Find What You\'re Looking For..',
                style: TextStyle(fontSize: 16, color: Colors.greenAccent),
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
                  style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  const GoogleSignInButton(),
                  Platform.isIOS ? const AppleSignInButtonL() : const SizedBox.shrink(),
                ],
              ),
              const Spacer(),
            ],
          ),
        ));
  }
}
