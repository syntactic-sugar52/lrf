import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';

class CommentTree extends StatelessWidget {
  final snap;
  const CommentTree({super.key, required this.snap});

  buildCommentTree() {
    bool childcomment = false;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: CommentTreeWidget<Comment, Comment>(
            Comment(avatar: snap.data()['profilePic'], userName: snap.data()['name'], content: '${snap.data()['text']} '),
            [
              Comment(avatar: snap.data()['profilePic'], userName: snap.data()['name'], content: '${snap.data()['text']} '),
              // Comment(avatar: 'null', userName: 'null', content: 'null'),
            ],
            treeThemeData: TreeThemeData(lineColor: Colors.green[500]!, lineWidth: 3),

            avatarRoot: (context, data) => PreferredSize(
              preferredSize: const Size.fromRadius(18),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(snap.data()['profilePic'].toString()),
                  ),
                ],
              ),
            ),

            // avatarRoot: (context, data) => PreferredSize(
            //   child: CircleAvatar(
            //     radius: 18,
            //     backgroundColor: Colors.grey,
            //     // backgroundImage: AssetImage('assets/avatar_2.png'),
            //   ),
            //   preferredSize: Size.fromRadius(18),
            // ),
            avatarChild: (context, data) => PreferredSize(
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey,
                // backgroundImage: AssetImage('assets/avatar_1.png'),
              ),
              preferredSize: Size.fromRadius(12),
            ),
            contentChild: (context, data) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '',
                          style: Theme.of(context).textTheme.caption?.copyWith(fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${data.content}',
                          style: Theme.of(context).textTheme.caption?.copyWith(fontWeight: FontWeight.w300, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey[700], fontWeight: FontWeight.bold),
                    child: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Text('Like'),
                          SizedBox(
                            width: 24,
                          ),
                          Text('Reply'),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
            contentRoot: (context, data) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.userName.toString(),
                          style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${data.content}',
                          style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.w300, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey[700], fontWeight: FontWeight.bold),
                    child: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Text('Like'),
                          SizedBox(
                            width: 24,
                          ),
                          Text('Reply'),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildCommentTree();
  }
}
