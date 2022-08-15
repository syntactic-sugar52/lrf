import 'package:flutter/material.dart';
import 'package:lrf/constants/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Home',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
