import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/data/data_store.dart';
import 'package:lrf/pages/main_page.dart';
import 'package:magic_sdk/magic_sdk.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final magic = Magic.instance;

  @override
  void initState() {
    super.initState();
    // todo : move to splash page
    /// Checks if the user is already loggedIn
    var future = magic.user.isLoggedIn();

    future.then((isLoggedIn) {
      if (isLoggedIn) {
        /// Navigate to home page
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kAppBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FaIcon(
                FontAwesomeIcons.lastfmSquare,
                color: Colors.blueAccent,
                size: 30,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Last Resort',
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 18),
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
                'Welcome to Last Resort',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: 16,
                  // decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 35),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.white10,
                    keyboardType: TextInputType.emailAddress,
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.white54),
                      hintText: 'Enter Full Name',
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
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
                        return 'Please enter your Full Name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: Colors.white10,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.white54),
                      hintText: 'Enter Email Address',
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
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
                        return 'Please enter your email address';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
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
                elevation: MaterialStateProperty.all<double>(12),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
              ),
              onPressed: () async {
                var token = await magic.auth.loginWithMagicLink(email: _emailController.text, showUI: true);
                debugPrint('token, $token');

                if (token.isNotEmpty) {
                  /// Navigate to home page
                  DataStore().addUser(name: _nameController.text.trim(), email: _emailController.text.trim(), token: token.trim());
                }
              },
              child: const Text(
                'LOGIN',
                style: TextStyle(color: kAppBackgroundColor, fontWeight: FontWeight.bold, letterSpacing: 3),
              ),
            ),
          ),
        ]));
  }
}
