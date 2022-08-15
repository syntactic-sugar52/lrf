import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/main_page.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Magic magic = Magic.instance;

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kAppBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.signHanging,
                color: Colors.indigoAccent.shade200,
                size: 30,
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                'Last Resort',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: ListView(physics: const NeverScrollableScrollPhysics(), children: [
          Container(
            height: MediaQuery.of(context).size.height / 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Enter Your Phone Number',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 1, fontSize: 16),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height / 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: TextFormField(
                  cursorColor: Colors.white10,
                  keyboardType: TextInputType.phone,
                  controller: textController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.white54),
                    hintText: '+1234567',
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            padding: const EdgeInsets.only(left: 30, right: 30),
            width: MediaQuery.of(context).size.width * 0.2,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(4),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent.shade700),
              ),
              onPressed: () async {
                var token = await magic.auth.loginWithSMS(phoneNumber: textController.text);
                debugPrint('token, $token');

                if (token.isNotEmpty) {
                  if (mounted) {
                    Navigator.push(
                      context,
                      PageTransition(type: PageTransitionType.bottomToTop, child: const MainPage(), inheritTheme: true, ctx: context),
                    );
                  } else {
                    // add pop up error

                    return;
                  }
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ),
        ]));
  }
}
