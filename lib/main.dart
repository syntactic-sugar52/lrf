import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:lrf/provider/authentication.dart';
import 'package:lrf/root.dart';
import 'package:lrf/services/database.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'routes/routes.dart' as router;

final navigatorKey = GlobalKey<NavigatorState>();
late SharedPreferences sharedPreferences;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //instantiate shared preference to use globally
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Authentication(FirebaseAuth.instance),
          ),
          ChangeNotifierProvider(
            create: (_) => Database(),
          ),
          //check if user is logged in or out then navigate to proper screen
          StreamProvider(
            create: (context) => context.read<Authentication>().authStateChanges,
            initialData: null,
          ),
        ],
        child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Bounty Bay App',
            onGenerateRoute: router.generateRoute,
            home: const RootPage()),
      ),
    );
  }
}
