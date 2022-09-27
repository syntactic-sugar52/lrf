import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:glass/glass.dart';
import 'package:location/location.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/constants/widgets.dart';

import 'package:lrf/pages/accepted_page.dart';
import 'package:lrf/pages/feed_page.dart';
import 'package:lrf/pages/profile_page.dart';
import 'package:lrf/pages/request_page.dart';
import 'package:lrf/provider/user_provider.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final User user;
  const MainPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  PageController? _pageController;

  ScrollController _hideBottomNavController = ScrollController();

  late User _user;
  bool _isSigningOut = false;
  @override
  void dispose() {
    _pageController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  late List<Widget> tabs;
  //todo: add condition if location is denied
  @override
  void initState() {
    if (mounted) {
      _user = widget.user;
      tabs = [
        FeedPage(
          user: _user,
        ),
        const RequestPage(),
        AcceptedPage(
          user: _user,
        ),
        const ProfilePage()
      ];
    }

    _pageController = PageController(initialPage: 0, keepPage: true);

    super.initState();
  }

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  Future getUserLocation() async {
    Location location = Location();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
  }

  void closeApp() {
    Platform.isIOS ? exit(0) : SystemNavigator.pop();
  } // bottom tabs navigation

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() async {
      showAlert(
        context: context,
        title_icon: Icons.error_outline,
        title: 'App Exit',
        messageBody: const Text('Do you want to exit the App?'),
        textButton1: 'YES',
        onPressedButton1: closeApp,
        textButton2: 'NO',
        onPressedButton2: () => Navigator.of(context).pop(false),
      );

      return false;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: PageView(
        // disables page scroll
        physics: const ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: tabs,
      ),
      bottomNavigationBar: Wrap(children: [
        BottomNavigationBar(
            backgroundColor: mobileBackgroundColor,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              _pageController?.jumpToPage(index);
            },
            showUnselectedLabels: false,
            selectedFontSize: 12.0,
            unselectedFontSize: 5.0,
            unselectedItemColor: Colors.white54,
            selectedItemColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.home_filled,
                  size: 20,
                ).asGlass(),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.view_list, size: 20).asGlass(),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.add_alert, size: 20).asGlass(),
                label: 'Notification',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person, size: 20).asGlass(),
                label: 'Profile',
              ),
            ]).asGlass(),
      ]),
    );
  }
}
