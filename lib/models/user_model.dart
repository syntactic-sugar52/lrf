import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String photoURL;
  final String createdAt;
// final String location;
  final String rating;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.photoURL,
    required this.createdAt,
    required this.rating,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        name: snapshot["displayName"],
        uid: snapshot["id"],
        email: snapshot["email"],
        photoURL: snapshot["photoUrl"],
        createdAt: snapshot["createdAt"],
        rating: snapshot["rating"]);
  }

  Map<String, dynamic> toJson() => {"name": name, "uid": uid, "email": email, "photoUrl": photoURL, "rating": rating, "createdAt": createdAt};
}
