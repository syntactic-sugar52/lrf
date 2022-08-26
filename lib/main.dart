import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/login_page.dart';
import 'package:lrf/pages/main_page.dart';
import 'package:lrf/pages/request_accepted_page.dart';
import 'package:magic_sdk/magic_sdk.dart';

Future main() async {
// get values from dotenv file
  await dotenv.load(fileName: ".env");
  //initialize magic link
  Magic.instance = Magic(
    "pk_live_278E6F3C3130FCA1",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // nested material app required for magic relayer
    return MaterialApp(
      home: Stack(children: [
        MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Last Resort App',
          color: Colors.white,
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            highlightColor: Colors.green,
            scaffoldBackgroundColor: kAppBackgroundColor,
            backgroundColor: kAppBackgroundColor,
          ),
          initialRoute: '/login',
          routes: {
            // '/': (_) => const SplashPage(),
            '/login': (_) => const LoginPage(),
            '/main': (_) => const MainPage(),
            '/requestAccepted': (_) => const RequestAcceptedPage()
          },
        ),
        Magic.instance.relayer
      ]),
    );
  }
}
