import 'package:flutter/material.dart';
import 'package:lrf/pages/general_widgets.dart';
import 'package:lrf/pages/widgets/request/general_widgets.dart';

class RequestAcceptedPage extends StatefulWidget {
  const RequestAcceptedPage({Key? key}) : super(key: key);

  @override
  State<RequestAcceptedPage> createState() => _RequestAcceptedPageState();
}

class _RequestAcceptedPageState extends State<RequestAcceptedPage> {
  final TextEditingController _instructionsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 2,
        title: const Text('Request Accepted'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            ListTile(
              dense: true,
              title: Text('Reply to request: ', style: TextStyle(fontSize: 16, color: Color(0xffF1F1F1))),
              subtitle: Padding(
                  padding: const EdgeInsets.all(8.0), child: textFieldRequest(controller: _instructionsController, maxLines: 25, maxLength: 820)),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: customButton(text: 'SEND', onPressed: () {}))
          ],
        ),
      ),
    );
  }
}
