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

void showOTPDialog({
  required BuildContext context,
  required TextEditingController codeController,
  required VoidCallback onPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Enter OTP"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.number,
            controller: codeController,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Done"),
          onPressed: onPressed,
        )
      ],
    ),
  );
}
