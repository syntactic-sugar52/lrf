import 'package:flutter/material.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/general_widgets.dart';
import 'package:lrf/pages/widgets/request/general_widgets.dart';

class ContactUsPage extends StatefulWidget {
  ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController _textEditingController = TextEditingController();

  final items = ['Fix', 'Complaint', 'Bug', 'Feature', 'Others'];

  String selectedValue = 'Feature';

  // todo: drop down choices (bug, feature, i dont like this, i like this, others)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: const Text('Contact Us'),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 12, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    // dropdown below..
                    child: DropdownButton<String>(
                      value: selectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },

                      items: items
                          .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),

                      // add extra sugar..
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 42,
                      underline: const SizedBox(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: textFieldRequest(controller: _textEditingController, maxLines: 20, maxLength: 180),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(width: double.infinity, child: customButton(text: 'Send', onPressed: () {}, color: Colors.green.shade900))
            ],
          ),
        ),
      ),
    );
  }
}
