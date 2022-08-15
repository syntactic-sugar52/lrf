import 'package:flutter/material.dart';
import 'package:lrf/constants/constants.dart';

class AcceptedPage extends StatelessWidget {
  const AcceptedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kAppBackgroundColor,
      body: Center(
        child: Text(
          'Accepted',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
