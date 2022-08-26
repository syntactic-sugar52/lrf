import 'package:flutter/material.dart';
import 'package:lrf/pages/widgets/request/slider_widget.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

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

// scrollbar
  final ScrollController _scrollController = ScrollController();

// text controllers for textfield
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _headlineController = TextEditingController();
  final TextEditingController _locationStartController = TextEditingController();
  final TextEditingController _locationEndController = TextEditingController();
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

          // scrollbarOrientation: ScrollbarOrientation.bottom,
          controller: _scrollController,
          interactive: true,
          // scrollbarOrientation: ScrollbarOrientation.top,
          child: ListView(shrinkWrap: true, scrollDirection: Axis.vertical, controller: _scrollController, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'POST',
                      style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.w800),
                    )),
              ],
            ),
            ListTile(dense: true, leading: Text('Headline : ', style: TextStyle(fontSize: 16, color: Colors.white))),
            ListTile(
              dense: true,
              title: Padding(
                padding: const EdgeInsets.only(left: 9, right: 5),
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
                      borderSide: BorderSide(color: Colors.blue),
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
            const ListTile(dense: true, leading: Text('Location Start Point : ', style: TextStyle(fontSize: 16, color: Colors.white70))),
            // SizedBox(
            //   height: 70,
            //   child: Card(
            //     child: ExpansionTile(
            //       title: Text(
            //         'Location Start Point',
            //         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            //       ),
            //       children: <Widget>[
            //         SingleChildScrollView(
            //           child: Container(
            //             height: 80,
            //             width: 120,
            //             child: OpenStreetMapSearchAndPick(
            //                 center: LatLong(23, 89),
            //                 buttonColor: Colors.blue,
            //                 buttonText: 'Set Current Location',
            //                 onPicked: (pickedData) {
            //                   print(pickedData.latLong.latitude);
            //                   print(pickedData.latLong.longitude);
            //                   print(pickedData.address);
            //                 }),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // const ListTile(
            //   dense: true,
            //   leading: Text(
            //     'Address',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   title: Padding(
            //     padding: EdgeInsets.only(left: 9, right: 5),
            //     child: TextField(
            //       autofocus: true,
            //       maxLines: 1,
            //       cursorColor: Colors.grey,
            //       style: TextStyle(color: Colors.white),
            //       decoration: InputDecoration(
            //         filled: true,
            //         fillColor: Colors.transparent,
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(15.0)),
            //           borderSide: BorderSide(
            //             width: 2.0,
            //           ),
            //         ),
            //         enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.blueGrey),
            //         ),
            //         focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.blue),
            //         ),
            //         errorBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.redAccent),
            //         ),
            //         focusedErrorBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.orangeAccent),
            //         ),
            //         disabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // const ListTile(
            //   dense: true,
            //   leading: Text(
            //     'City        ',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   title: Padding(
            //     padding: EdgeInsets.only(left: 5, right: 5),
            //     child: TextField(
            //       maxLines: 1,
            //       autofocus: true,
            //       cursorColor: Colors.grey,
            //       style: TextStyle(color: Colors.white),
            //       decoration: InputDecoration(
            //         filled: true,
            //         fillColor: Colors.transparent,
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(15.0)),
            //           borderSide: BorderSide(
            //             width: 2.0,
            //           ),
            //         ),
            //         enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.blueGrey),
            //         ),
            //         focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.blue),
            //         ),
            //         errorBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.redAccent),
            //         ),
            //         focusedErrorBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.orangeAccent),
            //         ),
            //         disabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            const ListTile(dense: true, leading: Text('Location End Point : ', style: TextStyle(fontSize: 16, color: Colors.white70))),
            const ListTile(
              dense: true,
              leading: Text(
                'Address',
                style: TextStyle(color: Colors.white),
              ),
              title: Padding(
                padding: EdgeInsets.only(left: 9, right: 5),
                child: TextField(
                  maxLines: 1,
                  autofocus: true,
                  cursorColor: Colors.grey,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
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
                      borderSide: BorderSide(color: Colors.blue),
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
            const ListTile(
              dense: true,
              leading: Text(
                'City        ',
                style: TextStyle(color: Colors.white),
              ),
              title: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  maxLines: 1,
                  cursorColor: Colors.grey,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
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
                      borderSide: BorderSide(color: Colors.blue),
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
              leading: const Text('Time to accomplish request : ', style: TextStyle(fontSize: 16, color: Colors.white70)),
              title: TextButton(
                  onPressed: () async {
                    //                       // Call to show the time picker
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
                  child: Text(
                    // change text to show time picked when user picks a time
                    timePicked ? newTimePicked : 'ADD TIME',
                    style: TextStyle(color: timePicked ? Colors.lightBlueAccent : Colors.grey.shade300, fontWeight: FontWeight.w700),
                  )),
            ),
            const ListTile(
              dense: true,
              leading: Text('Price for the request : ', style: TextStyle(fontSize: 16, color: Colors.white70)),
            ),
            ListTile(
                dense: true,
                title: PhysicalModel(
                    color: Colors.transparent, elevation: 12.0, child: SliderWidget(min: 0, max: 500, divisions: 25, onChange: (_) {}))),
            const ListTile(
              dense: true,
              leading: Text('Instructions : ', style: TextStyle(fontSize: 16, color: Colors.white70)),
            ),
            ListTile(
              dense: true,
              title: TextField(
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
                    borderSide: BorderSide(color: Colors.blue),
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
    _scrollController.dispose();
  }
}
