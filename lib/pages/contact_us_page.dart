import 'package:flutter/material.dart';

import 'package:lrf/services/database.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  // todo: add url launcher
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text('Contact BountyBay'),
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
                          Database().sendEmail('hello@.com');
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
