// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:lrf/constants/constants.dart';
// import 'package:lrf/pages/login_page.dart';
// import 'package:lrf/pages/main_page.dart';

// class SplashPage extends StatefulWidget {
//   const SplashPage({Key? key}) : super(key: key);

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         backgroundColor: kAppBackgroundColor,
//         body: StreamBuilder<User?>(
//             stream: FirebaseAuth.instance.authStateChanges(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else if (snapshot.hasError) {
//                 return const Center(
//                   child: Text('Something Went Wrong'),
//                 );
//                 // if user has an account
//               } else if (snapshot.hasData) {
//                 // return const MainPage();
//               } else {
//                 return const LoginPage();
//               }
//               // return Center(
//               //     child: RichText(
//               //   text: const TextSpan(
//               //       text: 'Last',
//               //       style: TextStyle(
//               //         fontFamily: 'Poppins',
//               //         color: Colors.greenAccent,
//               //         fontSize: 32,
//               //         fontWeight: FontWeight.bold,
//               //       ),
//               //       children: [TextSpan(text: 'Resort', style: TextStyle(fontFamily: 'Poppins', color: Colors.greenAccent, fontSize: 32))]),
//               // ));
//             }),
//       );
// }
