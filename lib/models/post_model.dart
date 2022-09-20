import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final danger;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final String title;
  final String price;
  const Post(
      {required this.description,
      required this.uid,
      required this.username,
      required this.danger,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.price,
      required this.title});

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        danger: snapshot["danger"],
        postId: snapshot["postId"],
        price: snapshot['price'],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        title: snapshot['title'],
        profImage: snapshot['profImage']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "danger": danger,
        "title": title,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'price': price
      };
}
