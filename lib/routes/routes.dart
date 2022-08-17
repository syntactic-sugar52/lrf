// how to create a router
// https://www.youtube.com/watch?v=YXDFlpdpp3g
// slide animation
// https://www.youtube.com/watch?v=Q8F9nNBIvQw

import 'package:flutter/material.dart';
import 'package:lrf/pages/login_page.dart';
import 'package:lrf/pages/splash_page.dart';

import '../pages/main_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // sliding navigation - screen moves left, then right
  SlideTransition slideNavigation(child, animation, secondaryAnimation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(-1, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  // depending on the route value - redirect to the proper page
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => SplashPage());

    case '/main':
      return MaterialPageRoute(builder: (context) => MainPage());

    // case '/map':
    //   return MaterialPageRoute(builder: (context) => MapPage());

    // case '/nearme':
    //   return MaterialPageRoute(builder: (context) => NearmePage());

    // case '/other':
    //   return MaterialPageRoute(builder: (context) => OtherPage());

    // case '/about':
    //   return MaterialPageRoute(builder: (context) => AboutPage());

    // case '/splash':
    //   return MaterialPageRoute(builder: (context) => SplashPage());

    // case '/filter':
    //   return PageRouteBuilder(
    //     pageBuilder: (context, animation, secondaryAnimation) => FilterPage(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return slideNavigation(child, animation, secondaryAnimation);
    //     },
    //   );

    // case '/settings':
    //   return PageRouteBuilder(
    //     pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return slideNavigation(child, animation, secondaryAnimation);
    //     },
    //   );

    default:
      return MaterialPageRoute(builder: (context) => LoginPage());
  }
}
