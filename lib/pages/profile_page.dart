import 'package:flutter/material.dart';
import 'package:lrf/constants/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kAppBackgroundColor,
      body: Center(
        child: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
