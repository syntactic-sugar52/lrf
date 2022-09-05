import 'package:flutter/material.dart';

TextField textFieldRequest({required TextEditingController controller, required int maxLines, required int maxLength}) {
  return TextField(
    maxLines: maxLines,
    maxLength: maxLength,
    textCapitalization: TextCapitalization.sentences,
    cursorColor: Colors.grey,
    style: const TextStyle(
      color: Colors.white,
    ),
    autofocus: true,
    controller: controller,
    decoration: const InputDecoration(
      counterStyle: TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffCFFFDC),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orangeAccent),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
  );
}
