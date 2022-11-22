import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/provider/authentication.dart';
import 'package:lrf/services/database.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String intlPhoneNumber = '';
  ButtonState? buttonState;
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  @override
  void initState() {
    _btnController.reset();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: kAppBackgroundColor,
        body: Padding(
          padding: kIsWeb ? const EdgeInsets.all(220.0) : const EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Center(
                  child: Container(
                      color: Colors.transparent,
                      child: const SizedBox(
                          child: Text(
                        'BountyBay',
                        style: TextStyle(fontSize: 38, color: Colors.black),
                      )).asGlass()),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Enter Phone Number to Continue',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      child: SizedBox(
                          height: 90,
                          child: IntlPhoneField(
                            controller: phoneController,
                            showCountryFlag: true,
                            flagsButtonMargin: const EdgeInsets.all(5),
                            dropdownIconPosition: IconPosition.trailing,
                            dropdownIcon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            cursorColor: const Color(0xff6B6968),
                            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff6B6968), width: 2.0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xff6B6968), width: 2.0)),
                              contentPadding: // Text Field height
                                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                              hintText: '123-456-789',
                              hintStyle: const TextStyle(color: Color(0xff6B6968), fontWeight: FontWeight.w400, fontSize: 18),
                            ),
                            initialCountryCode: 'US',
                            onChanged: (phone) {
                              setState(() {
                                intlPhoneNumber = phone.completeNumber;
                              });
                            },
                            onSubmitted: (phone) {},
                          )),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    RoundedLoadingButton(
                      color: Colors.blue.shade900,
                      resetDuration: const Duration(seconds: 1),
                      resetAfterDuration: true,
                      controller: _btnController,
                      onPressed: () async {
                        //validate phone number if not null
                        final formValid = formKey.currentState!.validate();
                        // if valid
                        if (formValid) {
                          String res = await context.read<Authentication>().phoneSignIn(
                                _scaffoldKey.currentContext,
                                intlPhoneNumber,
                                mounted,
                              );

                          if (res == 'success') {
                            _btnController.success();
                          } else {
                            _btnController.reset();
                          }
                        } else {
                          _btnController.reset();
                        }
                      },
                      child: const Text('Sign in', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        // Controls visual overflow
                        overflow: TextOverflow.clip,
                        // Controls how the text should be aligned horizontally
                        textAlign: TextAlign.center,
                        // Control the text direction
                        textDirection: TextDirection.rtl,
                        // Whether the text should break at soft line breaks
                        softWrap: true,
                        // Maximum number of lines for the text to span
                        maxLines: 2,
                        // The number of font pixels for each logical pixel
                        textScaleFactor: 1,
                        text: TextSpan(
                          text: 'By continuing, you agree to our ',
                          style: const TextStyle(fontSize: 12, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'End User Agreement',
                                recognizer: TapGestureRecognizer()..onTap = () => Provider.of<Database>(context, listen: false).launchURLBrowser(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, decoration: TextDecoration.underline, fontSize: 12, color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ));
  }

  // _onBasicAlertPressed(context) {
  //   Alert(
  //     context: context,
  //     title: "End User Agreement",
  //     desc: '',
  //   ).show();
  // }
}
