import 'package:flutter/material.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/main.dart';
import 'package:lrf/pages/feed_page.dart';

import 'package:lrf/pages/widgets/request/general_widgets.dart';

import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String? currentAddress;
  late Database db;
  // Uint8List? _file;
  bool isLoading = false;

  bool needValidator = false;
  String price = '';
  String? subAdminArea;
  String userId = '';

  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
// text controllers for textfield
  final TextEditingController _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final bool _validate = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contactEmailController.dispose();
    _contactNumberController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    db = Database();
    subAdminArea = sharedPreferences.getString('subAdminArea');
    currentAddress = sharedPreferences.getString('address');

    super.initState();
  }

  void postRequest(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to  db
      String res = await db.createPostRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          userId: uid,
          contactNumber: _contactNumberController.text.trim(),
          contactEmail: _contactEmailController.text.trim(),
          username: username,
          photoURL: profImage,
          subAdminArea: subAdminArea!,
          currentAddress: currentAddress!);
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
          Navigator.push(context, MaterialPageRoute(builder: (context) => FeedPage(user: db.user)));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () async {
                final formState = _formKey.currentState;
                if (formState!.validate() && _titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
                  postRequest(db.user.uid, db.user.displayName!, db.user.photoURL!);
                } else {
                  if (mounted) {
                    showSnackBar(context, 'Please enter all fields.');
                  }
                }
              },
              child: const Text(
                'POST',
                style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w800),
              )),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              ListTile(
                dense: true,
                title: const Text('Title : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: textFieldRequest(
                        controller: _titleController,
                        maxLines: 2,
                        hintText: 'Looking for..',
                        onChanged: (value) {},
                        maxLength: 120,
                        validate: _validate,
                        textCapitalization: TextCapitalization.sentences,
                        textInputType: TextInputType.text)),
              ),
              ListTile(
                dense: true,
                title: const Text('Contact Number : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: textFieldRequest(
                        controller: _contactNumberController,
                        maxLines: null,
                        maxLength: null,
                        validate: _validate,
                        validator: (value) {
                          String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          RegExp regExp = RegExp(patttern);
                          if (value!.isEmpty) {
                            return 'Please enter mobile number';
                          } else if (!regExp.hasMatch(value)) {
                            return 'Please enter valid mobile number';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        hintText: '+1234567',
                        textCapitalization: TextCapitalization.none,
                        textInputType: TextInputType.number)),
              ),
              ListTile(
                dense: true,
                title: const Text('Contact Email : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: textFieldRequest(
                        controller: _contactEmailController,
                        maxLines: null,
                        maxLength: null,
                        validate: _validate,
                        onChanged: (value) {},
                        hintText: 'hello@lastrest.com',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is Required';
                          }
                          if (!RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$").hasMatch(value)) {
                            return 'Please enter a valid Email';
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.none,
                        textInputType: TextInputType.emailAddress)),
              ),
              ListTile(
                dense: true,
                title: const Text('Description : ', style: TextStyle(fontSize: 16, color: Color(0xffF1F1F1))),
                subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: textFieldRequest(
                        controller: _descriptionController,
                        maxLines: 20,
                        hintText: '',
                        validate: _validate,
                        onChanged: (value) {},
                        maxLength: 820,
                        textCapitalization: TextCapitalization.sentences,
                        textInputType: TextInputType.multiline)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
