import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:lrf/constants/widgets.dart';

void showToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0);
}

void showLocationPermissionRequired(BuildContext context) {
  return showAlert(
    context: context,
    title: 'Location access',
    messageBody: Text(
      'You denied the permission to access your location. In order to navigate to your locaiton, please visit the permissions settings page and grant the location access for Last Resort app.',
    ),
    textButton1: 'CLOSE',
    onPressedButton1: () {
      Navigator.of(context).pop();
    },
    textButton2: 'GO TO SETTINGS',
    onPressedButton2: () async {
      // Geolocator.openLocationSettings();
      Navigator.of(context).pop();
    },
  );
}
