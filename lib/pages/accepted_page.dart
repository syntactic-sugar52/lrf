import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:lrf/constants/constants.dart';

import 'package:lrf/pages/inquired_tab.dart';
import 'package:lrf/pages/posts_tab.dart';

class AcceptedPage extends StatefulWidget {
  final User user;
  const AcceptedPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AcceptedPage> createState() => _AcceptedPageState();
}

class _AcceptedPageState extends State<AcceptedPage> {
  bool showRequest = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: kAppBackgroundColor,
          bottom: const TabBar(tabs: [
            Tab(
              text: 'Posts',
            ),
            Tab(
              text: 'Inquiry',
            )
          ]),
        ),
        body: const TabBarView(
          children: [PostsTabPage(), InquiredTabPage()],
        ),
      ),
    );
  }
}
