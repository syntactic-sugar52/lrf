import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lrf/constants/constants.dart';
import 'package:lrf/services/database.dart';

class ChatPage extends StatefulWidget {
  final snap;
  const ChatPage({super.key, required this.snap});

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
        title: Text('⚡️Chat'),
        backgroundColor: kAppBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(
              snap: widget.snap,
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
                      final response = Database().startMessage(
                          userId: widget.snap['postOwnerId'], peerID: widget.snap['senderUid'], content: messageText.toString().trim(), read: true);
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
  final snap;
  MessageStream({
    super.key,
    required this.snap,
  });
  final _auth = FirebaseAuth.instance;

  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode ? '${userID}_$peerID' : '${peerID}_$userID';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        //display messages from database
        // stream: FirebaseFirestore.instance.collectionGroup(getConversationID(snap['postOwnerId'], snap['senderUid'])).snapshots(),
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

      List<Widget> messageWidgets = [];

      final messages = snapshot.data!.docs;
      messageWidgets = messages.map(
        (message) {
          final messageText = message.get('lastMessage')['content'];
          final messageSender = message.get('lastMessage')['idTo'];
          final currentUser = _auth.currentUser!.uid;
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
      ));
    });
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.text,
    required this.sender,
    required this.isMe,
  });
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
            color: isMe ? Colors.white : Colors.green,
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
