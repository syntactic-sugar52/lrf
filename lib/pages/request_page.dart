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
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Scrollbar(
          child: ListView(shrinkWrap: true, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'POST',
                      style: TextStyle(color: Colors.greenAccent),
                    ))
              ],
            ),
            const ListTile(dense: true, leading: Text('Location Start Point : ', style: TextStyle(fontSize: 16, color: Colors.white))),
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
                  cursorColor: Colors.grey,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
                  maxLines: 1,
                  cursorColor: Colors.grey,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black26,
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
            ),
            const ListTile(dense: true, leading: Text('Location End Point : ', style: TextStyle(fontSize: 16, color: Colors.white))),
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
                  cursorColor: Colors.grey,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black26,
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
                  maxLines: 1,
                  cursorColor: Colors.grey,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black26,
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
            ),
            ListTile(
                dense: true,
                leading: const Text('Time to accomplish request : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                title: TextButton(
                  onPressed: () async {
                    // Call when you want to show the time picker
                    final TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialEntryMode: TimePickerEntryMode.input,
                      initialTime: const TimeOfDay(hour: 7, minute: 15),
                    );
                  },
                  child: const Text(
                    'Add Time',
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                )),
            const ListTile(
              dense: true,
              leading: Text('Price for the request : ', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            ListTile(dense: true, title: SliderFb3(min: 0, max: 500, divisions: 25, onChange: (_) {})),
            const ListTile(
              dense: true,
              leading: Text('Instructions : ', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const ListTile(
              dense: true,
              title: TextField(
                maxLines: 20,
                cursorColor: Colors.grey,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
          ]),
        ),
      ),
    );
  }
}

class SliderFb3 extends StatefulWidget {
  final double min;
  final double max;
  final double initialValue;
  final bool showMinMaxText;
  final int divisions;
  final Color accentColor;
  final Function(double) onChange;
  final LinearGradient gradient;
  final TextStyle minMaxTextStyle;
  const SliderFb3(
      {required this.min,
      required this.max,
      required this.divisions,
      required this.onChange,
      this.initialValue = 20.0,
      this.accentColor = Colors.white,
      this.gradient = const LinearGradient(colors: [
        Colors.blueGrey,
        Colors.grey,
      ]),
      this.showMinMaxText = true,
      this.minMaxTextStyle = const TextStyle(fontSize: 14),
      Key? key})
      : super(key: key);

  @override
  _SliderFb3State createState() => _SliderFb3State();
}

class _SliderFb3State extends State<SliderFb3> {
  late double _currentSliderValue;
  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 52,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), gradient: widget.gradient),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.5, right: 15.5),
        child: Row(
          children: [
            Text(
              '${widget.min.toInt()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: widget.accentColor,
                  inactiveTrackColor: widget.accentColor.withAlpha(35),
                  trackShape: const RoundedRectSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbShape: CustomSliderThumbCircle(
                    thumbRadius: 20,
                    min: widget.min,
                    max: widget.max,
                  ),
                  thumbColor: widget.gradient.colors[0],
                  overlayColor: widget.gradient.colors[0].withAlpha(32),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                  tickMarkShape: const RoundSliderTickMarkShape(),
                  activeTickMarkColor: widget.gradient.colors[0],
                  inactiveTickMarkColor: widget.accentColor,
                  valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: widget.gradient.colors[0],
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  min: widget.min,
                  max: widget.max,
                  value: _currentSliderValue,
                  divisions: widget.divisions,
                  onChanged: (value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                    widget.onChange(value);
                  },
                ),
              ),
            ),
            Text(
              '${widget.max.toInt()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Credits to @Ankit Chowdhury
class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final double min;
  final double max;

  const CustomSliderThumbCircle({
    required this.thumbRadius,
    this.min = 20.0,
    this.max = 2000.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Colors.white //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: thumbRadius * .8,
        fontWeight: FontWeight.w700,
        color: sliderTheme.thumbColor, //Text Color of Value on Thumb
      ),
      text: getValue(value),
    );

    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter = Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}
