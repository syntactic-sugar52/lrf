import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lrf/pages/general_widgets.dart';
import 'package:lrf/pages/widgets/request/slider_widget.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
//time picker
  bool timePicked = false;
  String newTimePicked = '';
  int length = 0;
  bool? serviceEnabled;
  LocationPermission? permission;
// scrollbar
  final ScrollController _scrollController = ScrollController();
//todo ask for location required before page render
// text controllers for textfield
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _headlineController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

//todo: add condition if location is denied
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          controller: _scrollController,
          interactive: true,
          child: ListView(shrinkWrap: true, scrollDirection: Axis.vertical, controller: _scrollController, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'POST',
                      style: TextStyle(color: Color(0xffF1F1F1), fontWeight: FontWeight.w800),
                    )),
              ],
            ),
            // ListTile(dense: true, leading: Text('Headline : ', style: TextStyle(fontSize: 16, color: Colors.white))),
            ListTile(
              dense: true,
              title: Text('Headline : ', style: TextStyle(fontSize: 16, color: Colors.white)),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 1,
                  controller: _headlineController,
                  cursorColor: Colors.grey,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCFFFDC),
                      ),
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
            ),
            ListTile(
              dense: true,
              title: const Text('Location :', style: TextStyle(fontSize: 16, color: Colors.white70)),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: customButton(
                  text: 'Select Location',
                  onPressed: () {
                    Navigator.pushNamed(context, '/pickLocation');
                  },
                ),
              ),
            ),

            ListTile(
                dense: true,
                title: const Text('Time to accomplish request : ', style: TextStyle(fontSize: 16, color: Colors.white70)),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customButton(
                    text: // change text to show time picked when user picks a time
                        timePicked ? newTimePicked : 'Add Time',
                    onPressed: () async {
                      final TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialEntryMode: TimePickerEntryMode.input,
                        initialTime: TimeOfDay.now(),
                      );

                      if (newTime == null) {
                        // don't change when cancel is pressed
                        setState(() {
                          timePicked = false;
                        });
                      } else {
                        setState(() {
                          timePicked = true;
                          // when user picks a time , show time picked
                          newTimePicked = '${newTime.hour}:${newTime.minute} ${newTime.period == DayPeriod.am ? 'am' : 'pm'}';
                        });
                      }
                    },
                  ),
                )),

            ListTile(
                dense: true,
                title: const Text('Price for the request : ', style: TextStyle(fontSize: 16, color: Colors.white70)),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SliderWidget(min: 0, max: 500, divisions: 25, onChange: (_) {}),
                )),

            ListTile(
              dense: true,
              title: Text('Instructions : ', style: TextStyle(fontSize: 16, color: Colors.white70)),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 20,
                  maxLength: 40,
                  onChanged: (String value) {
                    setState(() {
                      length = value.length;
                    });
                  },
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: Colors.grey,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  autofocus: true,
                  controller: _instructionsController,
                  decoration: const InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCFFFDC),
                      ),
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
            ),
            const SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _headlineController.dispose();
    _instructionsController.dispose();
    _scrollController.dispose();
  }
}
