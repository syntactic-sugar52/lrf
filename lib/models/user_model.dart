import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name, email, uid, address, photoURL, createdAt;
  UserModel({
    this.uid,
    this.email,
    this.name,
    this.photoURL,
    this.createdAt,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshot["displayName"],
      uid: snapshot["id"],
      email: snapshot["email"],
      photoURL: snapshot["photoUrl"],
      createdAt: snapshot["createdAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "uid": uid,
        "email": email,
        "photoUrl": photoURL,
        "createdAt": createdAt,
      };

  // Location related
  double? latitude, longitude;
  Map get location => {'latitude': latitude, 'longitude': longitude};
}
