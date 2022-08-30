import 'package:flutter/material.dart';
import 'package:open_location_picker/open_location_picker.dart';

class PickLocationPage extends StatefulWidget {
  const PickLocationPage({Key? key}) : super(key: key);

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Select Location'),
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              OpenMapPicker(
                decoration: InputDecoration(
                    hintText: "Add Start Location",
                    fillColor: Color(0xff3A3A3A),
                    filled: true,
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: SizedBox.shrink(),
                    hintStyle: TextStyle(color: Colors.white),
                    icon: Icon(
                      Icons.location_pin,
                      color: Colors.green,
                    ),
                    iconColor: Colors.pink),
                onSaved: (FormattedLocation? newValue) {
                  /// save new value
                },
              ),
              SizedBox(
                height: 20,
              ),
              OpenMapPicker(
                textStyle: TextStyle(color: Colors.blueGrey.shade100),
                decoration: InputDecoration(
                    hintText: "Add End Location",
                    fillColor: Color(0xff3A3A3A),
                    prefixIcon: SizedBox.shrink(),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.blueGrey.shade100),
                    icon: Icon(
                      Icons.location_pin,
                      color: Colors.pink,
                    ),
                    iconColor: Colors.pink),
                onSaved: (FormattedLocation? newValue) {
                  /// save new value
                },
              ),
              // MultiOpenMapPicker(
              //   decoration: const InputDecoration(hintText: "Add 2 locations", fillColor: Color(0xffF6F6F6), filled: true),
              //   onSaved: (List<FormattedLocation> newValue) {
              //     /// save new value
              //   },
              // ),
            ],
          ),
        ));
    // OpenStreetMapSearchAndPick(
    //     center: LatLong(9, 1),
    //     buttonColor: Colors.blue,
    //     buttonText: 'Set Current Location',
    //     onPicked: (pickedData) {
    //       print(pickedData.latLong.latitude);
    //       print(pickedData.latLong.longitude);
    //       print(pickedData.address);
    //     }));
  }
}
