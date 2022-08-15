import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/pages/widgets/search_bar_widget.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const FaIcon(
              FontAwesomeIcons.signHanging,
              color: Colors.indigoAccent,
              size: 32,
            ),
            const Text('Location : ', style: TextStyle(fontSize: 16, color: Colors.white)),
            Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.locationDot,
                  color: Colors.pink,
                ),
                SizedBox(width: double.infinity, height: 60, child: SearchBarWidget(onResultItemTap: () {})),
              ],
            ),
            const ListTile(
              leading: Text('Instructions : ', style: TextStyle(fontSize: 16)),
            ),
            const ListTile(
              title: TextField(
                maxLines: 20,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black54,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    borderSide: BorderSide(
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orangeAccent),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
