import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:lrf/pages/widgets/request/general_widgets.dart';
import 'package:lrf/pages/widgets/request/slider_widget.dart';

import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String price = '';
  // Uint8List? _file;
  bool isLoading = false;

// text controllers for textfield
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

// scrollbar
  final ScrollController _scrollController = ScrollController();
  final user = FirebaseAuth.instance.currentUser!;
  String userId = '';
  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
  }

  void postRequest(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await Database().uploadPost(_descriptionController.text.trim(), uid, username, profImage, _titleController.text.trim(), price);
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
          Navigator.pushNamed(context, '/main');
        }
      } else {
        if (mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

//todo  : add images
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SafeArea(
            child: Scrollbar(
          thumbVisibility: false,
          controller: _scrollController,
          interactive: true,
          child: ListView(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              children: [
                isLoading
                    ? const LinearProgressIndicator(
                        color: Colors.green,
                      )
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () async {
                          final userDetails = await Database().getUserDetails();
                          // final user = FirebaseAuth.instance.currentUser!;
                          postRequest(userDetails['id'], userDetails['displayName'], userDetails['photoUrl']);
                        },
                        child: const Text(
                          'POST',
                          style: TextStyle(color: Color(0xffF1F1F1), fontWeight: FontWeight.w800),
                        )),
                  ],
                ),
                ListTile(
                  dense: true,
                  title: const Text('Title : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                  subtitle:
                      Padding(padding: const EdgeInsets.all(8.0), child: textFieldRequest(controller: _titleController, maxLines: 2, maxLength: 120)),
                ),
                ListTile(
                    dense: true,
                    title: const Text('Price for the request : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SliderWidget(
                          min: 0,
                          max: 500,
                          divisions: 25,
                          onChange: (value) {
                            setState(() {
                              price = value.toString();
                            });
                          }),
                    )),
                ListTile(
                  dense: true,
                  title: const Text('Description : ', style: TextStyle(fontSize: 16, color: Color(0xffF1F1F1))),
                  subtitle: Padding(
                      padding: const EdgeInsets.all(8.0), child: textFieldRequest(controller: _descriptionController, maxLines: 25, maxLength: 820)),
                ),
                const SizedBox(height: 40),
              ]),
        )));
  }
}
