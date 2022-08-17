import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/login_page.dart';
import 'package:lrf/pages/main_page.dart';
import 'package:lrf/pages/splash_page.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future main() async {
// get values from dotenv file
  await dotenv.load(fileName: ".env");
  //initialize magic link
  Magic.instance = Magic(
    "pk_live_278E6F3C3130FCA1",
  );
  String supabaseBaseUrl = dotenv.env['SUPABASE_BASE_URL'] ?? '';
  String supabaseBaseKey = dotenv.env['SUPABASE_BASE_KEY'] ?? '';
  // initialize database
  Supabase.initialize(
      url: supabaseBaseUrl,
      anonKey: supabaseBaseKey,
      authCallbackUrlHostname: 'login-callback', // optional
      debug: true // optional
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
            highlightColor: Colors.amber,
            scaffoldBackgroundColor: kAppBackgroundColor,
            backgroundColor: kAppBackgroundColor,
          ),
          initialRoute: '/main',
          routes: {
            // '/': (_) => const SplashPage(),
            '/login': (_) => const LoginPage(),
            '/main': (_) => const MainPage(),
          },
        ),
        Magic.instance.relayer
      ]),
    );
  }
}
