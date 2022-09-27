import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:location/location.dart';
import 'package:lrf/helper/ui_helper.dart';

import 'package:lrf/pages/widgets/home/card_widget.dart';
import 'package:lrf/pages/widgets/home/card_widget.dart';

class FeedPage extends StatefulWidget {
  final User user;
  const FeedPage({Key? key, required this.user}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<String> docId = [];
  Location location = Location();

//todo: change to service enabled instead

  @override
  void initState() {
    super.initState();
  }

  // @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // todo: add shimmer loading effect
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (ctx, index) => Center(
            child: ExpandableTheme(
                data: const ExpandableThemeData(
                  iconColor: Colors.lightGreenAccent,
                  useInkWell: true,
                ),
                child: Card2(
                  snap: snapshot.data!.docs[index].data(),
                  user: widget.user,
                )),
          ),
        );
      },
    );
  }
}
