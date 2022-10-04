import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/utils/utils.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  // todo: add url launcher
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
                height: 30,
              ),
              const Text(
                'Join Our Growing Community',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.discord),
                title: const Text(
                  'https://discord.gg/ESBqwvkN',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                trailing: IconButton(
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: 'https://discord.gg/ESBqwvkN')).then((_) {
                        showSnackBar(context, "Copied to clipboard");
                      });
                    },
                    icon: const Icon(Icons.copy)),
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: const Icon(Icons.mail),
                title: const Text(
                  'hello@lastresrt.com',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                trailing: IconButton(
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: 'hello@lastresrt.com')).then((_) {
                        showSnackBar(context, "Copied to clipboard");
                      });
                    },
                    icon: const Icon(Icons.copy)),
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
