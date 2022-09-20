import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/general_widgets.dart';
import 'package:lrf/pages/widgets/request/general_widgets.dart';
import 'package:lrf/provider/google_sign_in.dart';
import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';
import 'package:provider/provider.dart';

class RequestAcceptedPage extends StatefulWidget {
  final String postId;
  const RequestAcceptedPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<RequestAcceptedPage> createState() => _RequestAcceptedPageState();
}

class _RequestAcceptedPageState extends State<RequestAcceptedPage> {
  final TextEditingController _replyController = TextEditingController();
  late FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Reply Sent!"),
        ],
      ));
  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await Database().postReply(
        widget.postId,
        _replyController.text.trim(),
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        if (mounted) {
          showSnackBar(context, res);
        }
      }
      setState(() {
        _replyController.text = "";
      });
      if (mounted) {
        // todo: add timer
        showSnackBar(context, 'Sent!');
        Navigator.of(context).pop();
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  void dispose() {
    _replyController.clear();
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        elevation: 0,
        title: const Text('Reply to Message Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              ListTile(
                dense: true,
                title: const Text('Message: ', style: TextStyle(fontSize: 16, color: Color(0xffF1F1F1))),
                subtitle:
                    Padding(padding: const EdgeInsets.all(8.0), child: textFieldRequest(controller: _replyController, maxLines: 22, maxLength: 800)),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: customButton(
                      text: 'SEND',
                      onPressed: () async {
                        final userDetails = await Database().getUserDetails();
                        postComment(userDetails['id'], userDetails['displayName'], userDetails['photoUrl']);
                        // todo: add something to say its posted
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
