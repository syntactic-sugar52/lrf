import 'package:flutter/material.dart';
import 'package:lrf/constants/constants.dart';

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = kAppBackgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(
      message: message,
      backgroundColor: kAppBackgroundColor,
    );
  }
}
