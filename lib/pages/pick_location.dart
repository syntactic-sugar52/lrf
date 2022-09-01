import 'package:flutter/material.dart';
import 'package:open_location_picker/open_location_picker.dart';

class PickLocationPage extends StatefulWidget {
  const PickLocationPage({Key? key}) : super(key: key);

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  String endLocationValue = '';
  String startLocationValue = '';

  void _onBackPressed() {
    // Called when the user either presses the back arrow in the AppBar
    try {
      if (startLocationValue.isNotEmpty && endLocationValue.isNotEmpty) {
        Navigator.of(context).pop({'startLocation': startLocationValue, 'endLocation': endLocationValue});
      } else {
        // todo: add pop up showing error

      }
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _onBackPressed,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Select Location'),
          ),
          body: Center(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                OpenMapPicker(
                  // todo: add validator
                  textStyle: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      hintText: "Add Start Location",
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      fillColor: Colors.white70,
                      filled: true,
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: SizedBox.shrink(),
                      hintStyle: TextStyle(color: Colors.black),
                      icon: Icon(
                        Icons.location_pin,
                        color: Colors.green,
                      ),
                      iconColor: Colors.pink),
                  onChanged: (newValue) {
                    setState(() {
                      startLocationValue = newValue!.displayName;
                    });
                  },
                  onSaved: (FormattedLocation? newValue) {
                    setState(() {
                      startLocationValue = newValue!.displayName;
                    });

                    /// save new value
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                OpenMapPicker(
                  textStyle: TextStyle(color: Colors.blueGrey.shade100),
                  decoration: const InputDecoration(
                      hintText: "Add End Location",
                      fillColor: Colors.white70,
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      prefixIcon: SizedBox.shrink(),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.black),
                      icon: Icon(
                        Icons.location_pin,
                        color: Colors.pink,
                      ),
                      iconColor: Colors.pink),
                  onChanged: (newValue) {
                    setState(() {
                      endLocationValue = newValue!.displayName;
                    });
                  },
                  onSaved: (FormattedLocation? newValue) {
                    /// save new value
                    setState(() {
                      endLocationValue = newValue!.displayName;
                    });
                  },
                ),
              ],
            ),
          )),
    );
  }
}
