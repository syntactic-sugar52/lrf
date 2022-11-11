import 'package:flutter/material.dart';

//
const Color kAppBackgroundColor = Color.fromARGB(255, 234, 230, 220);
//
const mobileBackgroundColor = Color(0xFF1F1E2C);
const Color kCardColor = Color(0xff3A3A3A);
const Color kWhite = Color(0xfff0f7f4);
const Color kBlueAccent = Color(0xff70abaf);
const Color kLightBlack = Color(0xff705d56);
const Color kGreen = Color(0xff42855B);
String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}
