import 'package:flutter/material.dart';

Widget customButton({required String text, required Function onPressed}) {
  return ElevatedButton(
    child: Text(
      text,
      style: TextStyle(
        color: Colors.grey.shade200,
        fontWeight: FontWeight.w700,
        shadows: [
          Shadow(
            blurRadius: 1.0,
            color: Colors.black,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
    ),
    onPressed: () => onPressed(),
    style: ElevatedButton.styleFrom(
        elevation: 12,
        primary: Color(0xff3A3A3A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 15.0)),
  );
}
