import 'package:flutter/material.dart';
import 'package:lrf/pages/feed_page.dart';
import 'package:lrf/pages/login_page.dart';
import 'package:lrf/provider/authentication.dart';
import 'package:provider/provider.dart';

enum AuthStatus { notLoggedIn, loggedIn }

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.notLoggedIn;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Authentication user = Provider.of<Authentication>(context, listen: false);

    String returnString = await user.onStartUp();

    if (returnString == "success") {
      if (mounted) {
        setState(() {
          _authStatus = AuthStatus.loggedIn;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? retVal;

    switch (_authStatus) {
      case AuthStatus.notLoggedIn:
        retVal = const LoginPage();
        break;
      case AuthStatus.loggedIn:
        retVal = const FeedPage();
        break;
      default:
    }
    return retVal!;
  }
}
