import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:lrf/provider/authentication.dart';
import 'package:lrf/root.dart';
import 'package:lrf/services/database.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'routes/routes.dart' as router;

final navigatorKey = GlobalKey<NavigatorState>();
late SharedPreferences sharedPreferences;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //       options: const FirebaseOptions(
  //     storageBucket: "bountybay-96d6e.appspot.com",
  //     authDomain: "bountybay-96d6e.firebaseapp.com",
  //     measurementId: "G-FV4M36Q76W",
  //     apiKey: "AIzaSyCK48zw_pQiGFCcek3jY-rUhjjtDn0iuyA",
  //     appId: "1:859672609504:web:8a5d001f6891b7c4fcc685",
  //     messagingSenderId: "859672609504",
  //     projectId: "bountybay-96d6e",
  //   ));
  // } else {

  // }
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
            // builder: (context, child) => ResponsiveWrapper.builder(
            //       child,
            //       maxWidth: 1200,
            //       minWidth: 480,
            //       defaultScale: true,
            //       breakpoints: [
            //         const ResponsiveBreakpoint.resize(480, name: MOBILE),
            //         const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            //         const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            //       ],
            //     ),
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Bounty Bay App',
            onGenerateRoute: router.generateRoute,
            home: const RootPage()),
      ),
    );
  }
}
