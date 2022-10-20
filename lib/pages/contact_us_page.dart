import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass/glass.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/services/database.dart';
import 'package:lrf/utils/utils.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  // todo: add url launcher
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBackgroundColor,
        title: const Text('Contact Last Resrt'),
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
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                color: Colors.black54,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ask Us Anything',
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: .5,
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                          // color: Colors.blueGrey.shade100,
                          shadows: [
                            Shadow(
                              blurRadius: 1.0,
                              color: Theme.of(context).primaryColor,
                              offset: const Offset(0.4, 0.2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).asGlass(),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.discord, size: 18, color: Colors.indigoAccent),
                title: const Text(
                  'https://discord.gg/4eJ5McjnAE',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                trailing: CircleAvatar(
                  child: IconButton(
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(text: 'https://discord.gg/4eJ5McjnAE')).then((_) {
                          showSnackBar(context, "Copied to clipboard");
                        });
                      },
                      icon: const Icon(Icons.copy, size: 18, color: Colors.white70)),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: const Icon(Icons.mail, size: 18, color: Colors.blueAccent),
                title: const Text(
                  'hello@lastresrt.com',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                trailing: CircleAvatar(
                  child: IconButton(
                      onPressed: () {
                        try {
                          Database().sendEmail('hello@lastresrt.com');
                        } catch (e) {
                          Future.error(e.toString());
                        }
                      },
                      icon: const Icon(Icons.contact_page_outlined, size: 18, color: Colors.white70)),
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
