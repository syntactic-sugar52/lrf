import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lrf/pages/chat_page.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat.yMMMd().format(
                    snap.data()['datePublished'].toDate(),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Divider(
                  color: Colors.green,
                ),
                ListTile(
                    tileColor: Colors.blueGrey.shade900,
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            snap.data()['profilePic'],
                          ),
                          radius: 14,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(snap.data()['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    subtitle: Text(
                      ' ${snap.data()['text']}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ChatPage(
                          //               snap: snap.data(),
                          //             )));
                        },
                        icon: const Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.lightGreenAccent,
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
