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
    style: const TextStyle(),
    autofocus: true,
    controller: controller,
    onChanged: onChanged,
    validator: validator,
    decoration: InputDecoration(
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
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orangeAccent),
      ),
      disabledBorder: const OutlineInputBorder(
          // borderSide: BorderSide(color: mobileBackgroundColor),
          ),
    ),
  );
}
