import 'package:flutter/material.dart';

class generalRequestWidgets extends ChangeNotifier {
  ListTile timeOfDayWidget({required Function() onPressed}) {
    return ListTile(
        dense: true,
        leading: const Text('Time to accomplish request : ', style: TextStyle(fontSize: 16, color: Colors.white70)),
        title: PhysicalModel(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
          elevation: 20.0,
          child: TextButton(
            onPressed: onPressed,
            child: Text('s  '
                // change text to show time picked when user picks a time
                // timePicked ? newTimePicked : 'ADD TIME',
                // style: TextStyle(color: timePicked ? Colors.greenAccent : Colors.grey.shade300, fontWeight: FontWeight.w700),
                ),
          ),
        ));
  }
}
