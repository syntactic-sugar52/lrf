import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lrf/constants/constants.dart';

class ChatPage extends StatefulWidget {
  final String postId;
  const ChatPage({super.key, required this.postId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageTextController = TextEditingController(); //controller prop for TextField. to use it to clear the textfield after pressing send.
  final _auth = FirebaseAuth.instance;
  String? messageText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                // _auth.signOut();
                Navigator.pop(context);
                // messageStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: kAppBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(
              postId: widget.postId,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              // decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      // decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      messageTextController.clear();
                      //Implement send functionality.
                      //collection - name in the db
                      FirebaseFirestore.instance
                          .collection('posts')
                          .doc()
                          .collection('replies')
                          .add({'text': messageText, 'sender': _auth.currentUser!.displayName});
                    },
                    child: const Text(
                      'Send',
                      // style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  final String postId;
  MessageStream({super.key, required this.postId});
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        //display messages from database
        stream: FirebaseFirestore.instance.collection('posts').doc(postId).collection('replies').snapshots(),
        builder: (context, snapshot) {
          //if snapshot has no data then return a center widget with a circularprogressindicator or a modal
          if (!snapshot.hasData) {
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.greenAccent,
                ),
              ),
            );
          }
          //reversed- changes the order of the text messages
          final messages = snapshot.data!.docs.reversed;
          List<Widget> messageWidgets = [];
          messageWidgets = messages.map(
            (message) {
              Map m = message.data() as Map;
              final messageText = m['text'];
              final messageSender = m['name'];
              final currentUser = _auth.currentUser!.displayName;
              final messageBubble = MessageBubble(
                sender: messageSender,
                text: messageText,
                isMe: currentUser == messageSender,
              );

              return messageBubble;
            },
          ).toList();

          return Expanded(
            child: ListView(
              reverse: true, //sticks to the bottom of yhe page so users can see messages from the bottom
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageWidgets,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.text, required this.sender, required this.isMe});
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            sender,
            style: const TextStyle(fontSize: 12.0, color: Colors.white),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : const BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.white : Colors.greenAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.black45 : Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
