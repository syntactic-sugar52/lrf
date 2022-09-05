import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final void Function(String) onChanged;

  const SearchInput({required this.textController, required this.hintText, required this.onChanged, Key? key}) : super(key: key);

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 7, right: 7, top: 30, bottom: 5),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: const Offset(12, 26),
          blurRadius: 50,
          spreadRadius: 0,
          color: Colors.grey.withOpacity(.1),
        ),
      ]),
      child: TextField(
        cursorColor: Colors.green,
        controller: widget.textController,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade900,
          ),
          filled: true,
          fillColor: Colors.white54,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade900,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}
