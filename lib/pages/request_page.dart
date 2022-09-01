import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lrf/data/data_store.dart';
import 'package:lrf/pages/general_widgets.dart';
import 'package:lrf/pages/widgets/request/slider_widget.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String endLocationValue = '';
  int length = 0;
  var locationData = {};
  String newTimePicked = '';
  String price = '';
  String startLocationValue = '';
//time picker
  bool timePicked = false;

  final TextEditingController _headlineController = TextEditingController();
// text controllers for textfield
  final TextEditingController _instructionsController = TextEditingController();

// scrollbar
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
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
        await DataStore().addRequest(
          id: idGenerator(),
          headline: _headlineController.text.trim(),
          instructions: _instructionsController.text.trim(),
          time: newTimePicked.trim(),
          startLocation: locationData.values.first.toString().trim(),
          endLocation: locationData.values.last.toString().trim(),
          price: price,
        );
      }
    } on PlatformException catch (e) {
      Future.error(e);
      rethrow;
    }
  }

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
                        Navigator.pushNamed(context, '/main');
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
              title: const Text('Headline : ', style: TextStyle(fontSize: 16, color: Colors.white)),
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
                    Navigator.pushNamed(context, '/pickLocation').then((value) {
                      setState(() {
                        locationData = value as Map<dynamic, dynamic>;
                      });
                    });
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
              title: const Text('Instructions : ', style: TextStyle(fontSize: 16, color: Colors.white70)),
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
}
