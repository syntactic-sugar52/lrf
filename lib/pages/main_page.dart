import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glass/glass.dart';
import 'package:lrf/constants/widgets.dart';
import 'package:lrf/data/data_store.dart';
import 'package:lrf/helper/ui_helper.dart';
import 'package:lrf/pages/accepted_page.dart';
import 'package:lrf/pages/home_page.dart';
import 'package:lrf/pages/profile_page.dart';
import 'package:lrf/pages/request_page.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  PageController? _pageController;

  ScrollController _hideBottomNavController = ScrollController();

  bool _isVisible = false;
  @override
  void dispose() {
    _pageController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  //todo: add condition if location is denied
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, keepPage: true);

    _isVisible = true;
    _hideBottomNavController = ScrollController();
    _hideBottomNavController.addListener(
      () {
        if (_hideBottomNavController.position.userScrollDirection == ScrollDirection.reverse) {
          if (_isVisible)
            setState(() {
              _isVisible = false;
            });
        }
        if (_hideBottomNavController.position.userScrollDirection == ScrollDirection.forward) {
          if (!_isVisible)
            setState(() {
              _isVisible = true;
            });
        }
      },
    );
  }

  void closeApp() {
    Platform.isIOS ? exit(0) : SystemNavigator.pop();
  } // bottom tabs navigation

  final tabs = [HomePage(), const RequestPage(), AcceptedPage(), const ProfilePage()];

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

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
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
                backgroundColor: Colors.black45,
                // backgroundColor: kAppBackgroundColor,
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
                selectedItemColor: Colors.white70,
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
                    label: 'Request',
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
        ));
  }
}
