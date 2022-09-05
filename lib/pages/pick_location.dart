import 'package:flutter/material.dart';
import 'package:open_location_picker/open_location_picker.dart';

class PickLocationPage extends StatefulWidget {
  const PickLocationPage({Key? key}) : super(key: key);

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  String endLatValue = '';
  String endLocationValue = '';
  String endLongValue = '';
  String startLatValue = '';
  String startLocationValue = '';
  String startLongValue = '';

  void _onBackPressed() {
    // Called when the user either presses the back arrow in the AppBar
    try {
      Navigator.of(context).pop({
        'startLocation': startLocationValue,
        'endLocation': endLocationValue,
        'startLat': startLatValue,
        'startLong': startLongValue,
        'endLat': endLatValue,
        'endLong': endLongValue
      });
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
            elevation: 2,
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
                  // todo: change to dark mode
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

                      startLatValue = newValue.lat.toString();
                      startLongValue = newValue.lon.toString();
                    });
                  },
                  onSaved: (FormattedLocation? newValue) {
                    setState(() {
                      startLocationValue = newValue!.displayName;
                      startLatValue = newValue.lat.toString();
                      startLongValue = newValue.lon.toString();
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                MultiOpenMapPicker(
                  textStyle: TextStyle(color: Colors.blueGrey.shade100),
                  decoration: const InputDecoration(
                      hintText: "Add One or More Locations",
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
                    // setState(() {
                    //   endLocationValue = newValue?.displayName ?? '';
                    //   endLatValue = newValue?.lat.toString() ?? '';
                    //   endLongValue = newValue?.lon.toString() ?? '';
                    // });
                  },
                  // onSaved: (FormattedLocation? newValue) {
                  //   /// save new value
                  //   setState(() {
                  //     endLocationValue = newValue!.displayName;
                  //     endLatValue = newValue.lat.toString();
                  //     endLongValue = newValue.lon.toString();
                  //   });
                  // },
                ),
              ],
            ),
          )),
    );
  }
}
