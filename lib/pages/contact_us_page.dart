import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  ContactUsPage({Key? key}) : super(key: key);
  final TextEditingController _textEditingController = TextEditingController();

  // todo: drop down choices (bug, feature, i dont like this, i like this, others)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
