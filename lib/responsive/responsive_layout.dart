import 'package:flutter/material.dart';
import 'package:lrf/provider/user_provider.dart';
import 'package:lrf/utils/constant.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({
    super.key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  Future addData() async {
    UserProvider _userProvider = Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // 600 can be changed to 900 if you want to display tablet screen with mobile screen layout
      if (constraints.maxWidth > webScreenSize) {
        return widget.webScreenLayout;
        // web screen
      } else {
        return widget.mobileScreenLayout;
      }
    });
  }
}
