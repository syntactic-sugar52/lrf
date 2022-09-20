import 'package:flutter/material.dart';

//
const Color kAppBackgroundColor = Color(0xFF1F1E2C);
//
const mobileBackgroundColor = Color(0xFF1F1E2C);
const Color kCardColor = Color(0xff3A3A3A);
const Color kWhite = Color(0xfff0f7f4);
const Color kBlueAccent = Color(0xff70abaf);
const Color kLightBlack = Color(0xff705d56);
String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}
