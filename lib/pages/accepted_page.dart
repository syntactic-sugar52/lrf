import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lrf/pages/widgets/accepted/search_input.dart';
import 'package:lrf/pages/widgets/comment_card.dart';

class AcceptedPage extends StatefulWidget {
  const AcceptedPage({Key? key}) : super(key: key);

  @override
  State<AcceptedPage> createState() => _AcceptedPageState();
}

class _AcceptedPageState extends State<AcceptedPage> {
  final GlobalKey expansionTileKey = GlobalKey();

  bool showRequest = false;

  bool _isLoading = false;
  final _searchController = TextEditingController();

  SizedBox sizedBox(double height, double width) => SizedBox(
        height: height,
        width: width,
      );

//todo: add notifications so they can choose which user will they accept

  @override
  Widget build(BuildContext context) {
    // final docId = FirebaseFirestore.instance.collection('posts').doc().;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: StreamBuilder(
        // stream: FirebaseFirestore.instance.collection('posts').doc(docId).collection('replies').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
    );
  }
}
