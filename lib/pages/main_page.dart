import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glass/glass.dart';
import 'package:lrf/constants/widgets.dart';
import 'package:lrf/pages/accepted_page.dart';
import 'package:lrf/pages/home_page.dart';
import 'package:lrf/pages/profile_page.dart';
import 'package:lrf/pages/request_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  LocationPermission? permission;
  bool? serviceEnabled;
  // bottom tabs navigation
  final tabs = [const HomePage(), const RequestPage(), const AcceptedPage(), const ProfilePage()];

  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  //todo: add condition if location is denied
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: 0, keepPage: true);
    _determinePosition();
  }

  void closeApp() {
    Platform.isIOS ? exit(0) : SystemNavigator.pop();
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

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
        child: SafeArea(
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
          bottomNavigationBar: SizedBox(
            // height: 80,
            child: BottomNavigationBar(
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
                    icon: const Icon(Icons.add_alert, size: 20).asGlass(),
                    label: 'Request',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.view_list, size: 20).asGlass(),
                    label: 'Accepted',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.person, size: 20).asGlass(),
                    label: 'Profile',
                  ),
                ]),
          ).asGlass(),
        )));
  }
}
