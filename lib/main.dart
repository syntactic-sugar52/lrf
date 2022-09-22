import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/login_page.dart';
import 'package:lrf/pages/main_page.dart';
import 'package:lrf/pages/reply_post_page.dart';

import 'package:lrf/provider/google_sign_in.dart';
import 'package:lrf/provider/user_provider.dart';

import 'package:lrf/responsive/responsive_layout.dart';
import 'package:lrf/responsive/web_screen_layout.dart';

import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // name: 'lrf',
      // options: FirebaseOptions(
      //     apiKey: "AIzaSyChrXeQ8IJu2rozvHxdWsw64SjH_s_7Rz4",
      //     appId: "1:281394997658:web:b1e791121eb6dfc07d7223",
      //     messagingSenderId: "281394997658",
      //     projectId: "last-resort-89e02",
      //     storageBucket: "last-resort-89e02.appspot.com")
      );
  //todo: move to dotenv
  // await Supabase.initialize(
  //   url: 'https://ehdaxvwciymzvuljhrrr.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVoZGF4dndjaXltenZ1bGpocnJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjM2NTEyMjIsImV4cCI6MTk3OTIyNzIyMn0.dlLeqZb9A9_VLR_HPBDBKs9zaEHfZsW70GhC7BakYg4',
  // );
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleSignInProvider>(
          create: (_) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Last Resort App',
        color: Colors.white,
        theme: ThemeData.dark().copyWith(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          highlightColor: Colors.green,
          // scaffoldBackgroundColor: kAppBackgroundColor,
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        initialRoute: '/login',
        routes: {
          // '/': (_) => const SplashPage(),
          '/login': (_) => const LoginPage(),
          '/main': (_) => const MainPage(),
          // '/requestAccepted': (_) => const RequestAcceptedPage()
        },

        // home: StreamBuilder(
        //     stream: FirebaseAuth.instance.authStateChanges(),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.active) {
        //         // return MainPage();
        //         return const ResponsiveLayout(mobileScreenLayout: MainPage(), webScreenLayout: WebScreenLayout());
        //       } else if (snapshot.hasError) {
        //         return Center(
        //           child: Text('${snapshot.error}'),
        //         );
        //       }
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const Center(
        //           child: CircularProgressIndicator(
        //             color: Colors.green,
        //           ),
        //         );
        //       }
        //       return const LoginPage();
        //     }),
      ),
    );
  }
}
