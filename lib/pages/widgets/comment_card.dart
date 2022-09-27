import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lrf/pages/chat_page.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Row(
                //   // mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Text(
                //       DateFormat.yMMMd().format(
                //         snap.data()['datePublished'].toDate(),
                //       ),
                //       style: const TextStyle(
                //         fontSize: 12,
                //         fontWeight: FontWeight.w400,
                //       ),
                //     ),
                //   ],
                // ),
                // Divider(
                //   color: Colors.lightGreenAccent,
                // ),
                ListTile(
                  // shape: ListTileTheme,
                  tileColor: Colors.blueGrey.shade900,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          snap.data()['profilePic'],
                        ),
                        radius: 12,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(snap.data()['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  subtitle: Text(
                    ' ${snap.data()['text']}',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
