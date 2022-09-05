import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrf/data/data_store.dart';
import 'package:lrf/pages/general_widgets.dart';
import 'package:lrf/pages/widgets/request/general_widgets.dart';
import 'package:lrf/pages/widgets/request/slider_widget.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String endLat = '';
  String endLocationValue = '';
  String endLong = '';
  var locationData = {};
  String newTimePicked = '';
  String price = '';
  String startLat = '';
  String startLocationValue = '';
  String startLong = '';
//time picker
  bool timePicked = false;

  final TextEditingController _headlineController = TextEditingController();
// text controllers for textfield
  final TextEditingController _instructionsController = TextEditingController();

// scrollbar
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _headlineController.dispose();
    _instructionsController.dispose();
    _scrollController.dispose();
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  Future<void> postRequest() async {
    // todo: make sure copper has value
    try {
      if (_headlineController.text.isNotEmpty && _instructionsController.text.isNotEmpty && newTimePicked != '' && locationData.isNotEmpty) {
        locationData.forEach((key, value) {
          if (key.toString().contains('startLat')) {
            setState(() {
              startLat = value;
            });
          } else if (key.toString().contains('startLong')) {
            setState(() {
              startLong = value;
            });
          } else if (key.toString().contains('endLat')) {
            setState(() {
              endLat = value;
            });
          } else if (key.toString().contains('endLong')) {
            setState(() {
              endLong = value;
            });
          } else if (key.toString().contains('startLocation')) {
            setState(() {
              startLocationValue = value;
            });
          } else {
            setState(() {
              endLocationValue = value;
            });
          }
        });
        await DataStore().addRequest(
            id: idGenerator(),
            headline: _headlineController.text.trim(),
            instructions: _instructionsController.text.trim(),
            time: newTimePicked.trim(),
            startLocation: startLocationValue.trim(),
            endLocation: endLocationValue.trim(),
            price: price,
            startLatitude: startLat.trim(),
            startLongitude: startLong.trim(),
            endLatitude: endLat.trim(),
            endLongitude: endLong.trim());
        setState(() {
          locationData.clear();
          price = '';
          newTimePicked = '';
        });
        // if (success) {
        //   setState(() {
        //     locationData = {};
        //     price = '';
        //     newTimePicked = '';
        //   });
        // } else {
        //   //todo: show error
        // }
      }
    } on PlatformException catch (e) {
      Future.error(e);
      rethrow;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationData.clear();
  }

//todo  : add images
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
                    onPressed: () {
                      postRequest().whenComplete(() {
                        Navigator.pushNamed(context, '/main').whenComplete(() {
                          setState(() {
                            locationData.clear();
                            price = '';
                            newTimePicked = '';
                          });
                        });
                      });
                    },
                    child: const Text(
                      'POST',
                      style: TextStyle(color: Color(0xffF1F1F1), fontWeight: FontWeight.w800),
                    )),
              ],
            ),
            ListTile(
              dense: true,
              title: const Text('Title : ', style: TextStyle(fontSize: 16, color: Colors.white)),
              subtitle:
                  Padding(padding: const EdgeInsets.all(8.0), child: textFieldRequest(controller: _headlineController, maxLines: 2, maxLength: 120)),
            ),
            ListTile(
              dense: true,
              title: const Text('Location :', style: TextStyle(fontSize: 16, color: Colors.white)),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: customButton(
                  text: locationData.isNotEmpty ? 'Select Location' : 'Location Saved',
                  onPressed: () {
                    Navigator.pushNamed(context, '/pickLocation').then((value) {
                      setState(() {
                        locationData = value as Map<dynamic, dynamic>;
                      });
                    });
                  },
                ),
              ),
            ),
            // ListTile(
            //     dense: true,
            //     title: const Text('Time to accomplish request : ', style: TextStyle(fontSize: 16, color: Colors.white)),
            //     subtitle: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: customButton(
            //         text: // change text to show time picked when user picks a time
            //             timePicked ? newTimePicked : 'Add Time',
            //         onPressed: () async {
            //           final TimeOfDay? newTime = await showTimePicker(
            //             context: context,
            //             initialEntryMode: TimePickerEntryMode.input,
            //             initialTime: TimeOfDay.now(),
            //           );

            //           if (newTime == null) {
            //             // don't change when cancel is pressed
            //             setState(() {
            //               timePicked = false;
            //             });
            //           } else {
            //             setState(() {
            //               timePicked = true;
            //               // when user picks a time , show time picked
            //               newTimePicked = '${newTime.hour}:${newTime.minute} ${newTime.period == DayPeriod.am ? 'am' : 'pm'}';
            //             });
            //           }
            //         },
            //       ),
            //     )),
            ListTile(
                dense: true,
                title: const Text('Price for the request : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SliderWidget(
                      min: 0,
                      max: 500,
                      divisions: 25,
                      onChange: (value) {
                        setState(() {
                          price = value.toString();
                        });
                      }),
                )),
            ListTile(
              dense: true,
              title: Text('Description : ', style: TextStyle(fontSize: 16, color: Color(0xffF1F1F1))),
              subtitle: Padding(
                  padding: const EdgeInsets.all(8.0), child: textFieldRequest(controller: _instructionsController, maxLines: 25, maxLength: 820)),
            ),
            const SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }
}
