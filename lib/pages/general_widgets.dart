import 'package:flutter/material.dart';

Widget customButton({required String text, required Function onPressed, required Color color}) {
  return ElevatedButton(
    onPressed: () => onPressed(),
    style: ElevatedButton.styleFrom(
        elevation: 12,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 15.0)),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.grey.shade200,
        fontWeight: FontWeight.w700,
        shadows: [
          Shadow(
            blurRadius: 0.0,
            color: Colors.blueGrey.shade800,
            offset: const Offset(0.2, 0.2),
          ),
        ],
      ),
    ),
  );
}
