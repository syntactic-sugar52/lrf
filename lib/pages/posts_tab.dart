import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lrf/constants/constants.dart';

import 'package:lrf/pages/comments_page.dart';
import 'package:lrf/pages/general_widgets.dart';
import 'package:lrf/services/database.dart';

class PostsTabPage extends StatefulWidget {
  const PostsTabPage({super.key});

  @override
  State<PostsTabPage> createState() => _PostsTabPageState();
}

class _PostsTabPageState extends State<PostsTabPage> {
  SizedBox sizedBox(double height, double width) => SizedBox(
        height: height,
        width: width,
      );
  final GlobalKey expansionTileKey = GlobalKey();
//todo: add notifications so they can choose which user will they accept
  _buildExpandableContent(String username, String profilePic, String text, dynamic snap) {
    List<Widget> columnContent = [];

    // for (String content in data.contents)
    columnContent.add(
      ExpansionTile(
        maintainState: true,
        controlAffinity: ListTileControlAffinity.trailing,
        tilePadding: const EdgeInsets.only(left: 50, right: 50),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profilePic),
            ),
            sizedBox(0, 5),
            Text(
              username,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
        trailing: Container(
          height: 35,
          width: 60,
          decoration: BoxDecoration(
            color: kAppBackgroundColor,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: const Center(
            child: Text(
              'Show',
              style: TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 1.0,
                    color: Colors.white,
                    offset: Offset(0.4, 0.2),
                  ),
                ],
              ),
            ),
          ),
        ),
        children: <Widget>[
          buildDescriptionContent(context: context, description: text, snap: snap),
        ],
      ),
    );

    return columnContent;
  }

  buildDescriptionContent({required String description, required BuildContext context, required dynamic snap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        padding: const EdgeInsets.all(18.0),
        width: double.infinity,
        color: kAppBackgroundColor,
        // color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sizedBox(10, 0),
            Text(description),
            sizedBox(50, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                customButton(
                    text: 'Accept',
                    onPressed: () async {
                      try {
                        String response =
                            await Database().updateInquiryRequest(isAccepted: true, postOwnerId: snap['postOwnerId'], docId: snap.reference.id);
                        if (response == 'success') {
                          if (mounted) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentsPage(
                                          snap: snap,
                                        )));
                          }
                        } else {
                          //     // todo: show error scaffold
                        }
                      } catch (e) {
                        print(e);
                        Future.error(e);
                      }
                    },
                    color: Colors.green.shade700),

                // todo: if declined, remove and alert user
                customButton(text: 'Decline', onPressed: () {}, color: Colors.pink),
              ],
            ),
            sizedBox(30, 0),
          ],
        ),
      ),
    );
  }

  buildPostTitle() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('inquiry').doc(FirebaseAuth.instance.currentUser!.uid).collection('inquiryItems').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
// todo: if same postId, needs to be within same title

        return ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Column(children: [
                  snapshot.data!.docs[index]['postOwnerId'] == FirebaseAuth.instance.currentUser!.uid
                      ? Card(
                          color: Colors.blueGrey.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ExpansionTile(
                            collapsedIconColor: Colors.black,
                            iconColor: Colors.black,
                            subtitle: Text(
                              DateFormat.yMMMd().format(
                                snapshot.data!.docs[index]['datePublished'].toDate(),
                              ),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
                            ),
                            title: Text(
                              snapshot.data!.docs[index]['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 15.0,
                              ),
                            ),
                            children: [
                              Column(
                                children: _buildExpandableContent(snapshot.data!.docs[index]['sender'], snapshot.data!.docs[index]['profilePic'],
                                    snapshot.data!.docs[index]['text'], snapshot.data!.docs[index]),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                ]));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [sizedBox(20, 0), buildPostTitle()],
      ),
    );
  }
}
