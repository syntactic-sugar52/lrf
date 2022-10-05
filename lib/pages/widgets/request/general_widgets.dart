import 'package:flutter/material.dart';

TextFormField textFieldRequest(
    {required TextEditingController controller,
    required maxLines,
    required maxLength,
    required TextCapitalization textCapitalization,
    required bool validate,
    required Function(String?) onChanged,
    required String hintText,
    String? Function(String?)? validator,
    required TextInputType textInputType}) {
  return TextFormField(
    maxLines: maxLines,
    maxLength: maxLength,
    keyboardType: textInputType,
    textCapitalization: textCapitalization,
    cursorColor: Colors.grey,
    style: const TextStyle(
      color: Colors.white,
    ),
    autofocus: true,
    controller: controller,
    onChanged: onChanged,
    validator: validator,
    decoration: InputDecoration(
      counterStyle: const TextStyle(color: Colors.white),
      errorText: validate ? 'Fields Can\'t Be Empty' : null,
      filled: true,
      fillColor: Colors.transparent,
      hintText: hintText,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(
          width: 2.0,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffCFFFDC),
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orangeAccent),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
  );
}
