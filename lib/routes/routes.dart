// how to create a router
// https://www.youtube.com/watch?v=YXDFlpdpp3g
// slide animation
// https://www.youtube.com/watch?v=Q8F9nNBIvQw

import 'package:flutter/material.dart';
import 'package:lrf/pages/contact_us_page.dart';
import 'package:lrf/pages/login_page.dart';
import 'package:lrf/pages/inquiry_page.dart';
import 'package:lrf/pages/splash_page.dart';

import '../pages/main_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // sliding navigation - screen moves left, then right
  SlideTransition slideNavigation(child, animation, secondaryAnimation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  // depending on the route value - redirect to the proper page
  switch (settings.name) {
    // case '/':
    //   return MaterialPageRoute(builder: (context) => const SplashPage());

    // case '/main':
    //   return MaterialPageRoute(builder: (context) => const MainPage());

    // case '/requestAccepted':
    //   return PageRouteBuilder(
    //     pageBuilder: (context, animation, secondaryAnimation) => const RequestAcceptedPage(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return slideNavigation(child, animation, secondaryAnimation);
    //     },
    //   );

    case '/contactUs':
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ContactUsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return slideNavigation(child, animation, secondaryAnimation);
        },
      );

    default:
      return MaterialPageRoute(builder: (context) => const LoginPage());
  }
}
