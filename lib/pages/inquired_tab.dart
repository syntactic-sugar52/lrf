import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lrf/pages/comments_page.dart';
import 'package:lrf/services/database.dart';

class InquiredTabPage extends StatelessWidget {
  const InquiredTabPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collectionGroup('inquiryItems').snapshots(),
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
                  SizedBox(
                    height: 15,
                  ),
                  snapshot.data!.docs[index]['isAccepted'] == true &&
                          snapshot.data!.docs[index]['senderUid'].toString() == FirebaseAuth.instance.currentUser!.uid
                      ? Container(
                          color: Colors.blueGrey.shade600,
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Column(
                              children: [
                                Text(snapshot.data!.docs[index]['text'].toString()),
                              ],
                            ),
                            trailing: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CommentsPage(
                                                snap: snapshot.data!.docs[index],
                                              )));
                                },
                                child: Text('Chat')),
                            subtitle: Column(
                              children: [
                                Text('Owner of Post: '),
                                Text(snapshot.data!.docs[index]['title'].toString()),
                                Text(' has invited you to chat!'),
                              ],
                            ),
                          ),
                        )
                      : const Expanded(
                          child: Text('Nothing here'),
                        )
                ]));
      },
    );
  }
}
