import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:lrf/pages/widgets/request/home/card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> docId = [];

  Future getUsers() async {
    await FirebaseFirestore.instance.collection('request').get().then((snapshot) => snapshot.docs.forEach((element) {
          print(element.reference);
          docId.add(element.reference.id);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ExpandableTheme(
            data: const ExpandableThemeData(
              iconColor: Colors.lightGreenAccent,
              useInkWell: true,
            ),
            child: FutureBuilder(
                future: getUsers(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemBuilder: ((context, index) {
                      return Card2(
                        documentId: docId[index],
                      );
                    }),
                    itemCount: docId.length,
                    physics: const BouncingScrollPhysics(),
                  );
                })));
  }
}
