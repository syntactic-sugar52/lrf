import 'package:flutter/material.dart';

// for displaying snackbars
showSnackBar(context, String text) {
  return WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black54,
        content: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  });
}
