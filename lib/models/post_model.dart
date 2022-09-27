import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;

  final List upVote;
  final List downVote;
  final String postId;
  final DateTime datePublished;
  // final String postUrl;
  final String profImage;
  final String title;
  final String price;
  const Post(
      {required this.description,
      required this.uid,
      required this.username,
      required this.upVote,
      required this.downVote,
      required this.postId,
      required this.datePublished,
      // required this.postUrl,
      required this.profImage,
      required this.price,
      required this.title});

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        upVote: snapshot["upvote"],
        downVote: snapshot["downvote"],
        postId: snapshot["postId"],
        price: snapshot['price'],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        // postUrl: snapshot['postUrl'],
        title: snapshot['title'],
        profImage: snapshot['profImage']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "upVote": upVote,
        "downVote": downVote,
        "title": title,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        // 'postUrl': postUrl,
        'profImage': profImage,
        'price': price
      };
}
