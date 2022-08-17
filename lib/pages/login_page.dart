import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/utils/constant.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final textController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    final response = await supabase.auth.signIn(email: textController.text);

    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(
        message: error.message,
      );
    } else {
      context.showSnackBar(message: 'Check your email for login link!');
      textController.clear();
    }

    setState(() {
      _isLoading = false;
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
                'Enter Your Email Address To Start',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
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
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: Colors.white10,
                  keyboardType: TextInputType.emailAddress,
                  controller: textController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.white54),
                    hintText: 'hello@lastresort.com',
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
                      return 'Please enter your email address';
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
                elevation: MaterialStateProperty.all<double>(8),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
              ),
              onPressed: () {
                _signIn();
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
