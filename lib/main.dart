import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/routes.dart' as router;

final navigatorKey = GlobalKey<NavigatorState>();
late SharedPreferences sharedPreferences;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Last Resort App',
      color: Colors.white,
      theme: ThemeData.dark().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        highlightColor: Colors.green,
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      onGenerateRoute: router.generateRoute,
      home: const LoginPage(),
    );
  }
}
