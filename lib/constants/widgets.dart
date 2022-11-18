// type: 0 - default(alert) , 1 - change log
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:lrf/constants/constants.dart';

void showAlert(
    {required context,
    IconData? titleIcon,
    required String title,
    required Widget messageBody,
    String? textButton1,
    Function()? onPressedButton1,
    String? textButton2,
    Function()? onPressedButton2,
    String? textButton3,
    Function()? onPressedButton3}) {
  showDialog<void>(
    context: context,
    //barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
        title: Row(
          children: [
            titleIcon != null
                ? Row(children: [
                    Icon(titleIcon, color: Colors.black, size: 25.0),
                    const SizedBox(width: 10.0),
                  ])
                : Container(),
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        backgroundColor: Colors.white,
        contentTextStyle: const TextStyle(color: Colors.black, fontSize: 17.0),
        content: messageBody,
        actionsPadding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
        actions: <Widget>[
          textButton1 != null && onPressedButton1 != null
              ? TextButton(
                  onPressed: onPressedButton1,
                  child: Text(
                    textButton1,
                    style: const TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                )
              : TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
          textButton2 != null && onPressedButton2 != null
              ? TextButton(
                  onPressed: onPressedButton2,
                  child: Text(
                    textButton2,
                    style: const TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                )
              : const SizedBox(),
          textButton3 != null && onPressedButton3 != null
              ? TextButton(
                  onPressed: onPressedButton3,
                  child: Text(
                    textButton3,
                    style: const TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                )
              : const SizedBox(),
        ],
      );
    },
  );
}

SimpleDialogOption buildSimpleDialogOption(Function() onPressed, String text) {
  return SimpleDialogOption(
    onPressed: onPressed,
    child: Row(
      children: [
        const Icon(Icons.flag),
        Expanded(
            child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        )),
      ],
    ),
  );
}

PopupMenuItem buildPopupMenuItem(String title, IconData iconData, int position) {
  return PopupMenuItem(
    value: position,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(
          iconData,
          color: Colors.black,
        ),
        Text(title),
      ],
    ),
  );
}

Widget buildCollapsedImgDetails() {
  return Container();
}

buildInnerCard(
  Color color,
  double height,
  Widget child,
) {
  return Card(
    child: SizedBox(
        height: height,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
          ),
          child: child,
        )).asGlass(),
  );
}

Widget buildCollapsedBody(String title, BuildContext context) {
  return buildInnerCard(
    kWhite,
    MediaQuery.of(context).size.height / 6,
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

buildExpandedBody() {
  return Container();
}

buildTabs(String tab) {
  return Tab(child: Text(tab));
}
