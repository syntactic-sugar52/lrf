import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lrf/provider/authentication.dart';
import 'package:lrf/root.dart';

import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';
import 'package:provider/provider.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () async {
        try {
          if (_firebaseAuth.currentUser != null) {
            _firebaseAuth.currentUser?.delete();
            await Provider.of<Authentication>(context, listen: false).signOut(context: context);
            if (mounted) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RootPage()));
            }
          } else {
            showSnackBar(context, 'Something went wrong, Try again.');
          }
        } catch (e) {
          Future.error(e);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Account and Data"),
      content: const Text("Are you sure you want to delete your account?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Divider(
                color: Colors.grey,
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Delete your account and data'),
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_forever,
                  size: 22,
                ),
                title: const Text(
                  'Delete Account and Logout',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                trailing: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: IconButton(
                      onPressed: () {
                        try {
                          showAlertDialog(context);
                        } catch (e) {
                          Future.error(e.toString());
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                        size: 18,
                      )),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('We would love to hear from you! Send us an email about your experience.'),
              ),
              ListTile(
                leading: const Icon(
                  Icons.mail,
                  size: 22,
                ),
                title: const Text(
                  'hello@bountybay.net',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                trailing: CircleAvatar(
                  child: IconButton(
                      onPressed: () {
                        try {
                          Database().sendEmail('hello@bountybay.net');
                        } catch (e) {
                          Future.error(e.toString());
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                        size: 18,
                      )),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
