import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.id,
    this.email,
    this.name,
    this.profileImg,
    this.createdAt,
    this.location,
    this.rating,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data();
    return UserModel(id: json?['id'] ?? '', name: json?["name"] ?? '', email: json?["email"] ?? '', rating: json?["rating"] ?? '');
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        email: map['email'],
        name: map['name'],
        profileImg: map['profileImg'],
        createdAt: map['createdAt'],
        rating: map['rating'],
        location: map['location']);
  }

  String? createdAt;
  String? email;
  String? id;
  String? location;
  String? name;
  String? profileImg;
  String? rating;

  // String toJson() => json.encode(toMap());
  // factory UserModel.fromJson(dynamic source) => UserModel.fromMap(json.decode(source));
  // @override
  // String toString() {
  //   return 'UserModel(id: $id, email: $email, name: $name, profileImg: $profileImg, createdAt: $createdAt, magicToken: $magicToken, rating: $rating)';
  // }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.profileImg == profileImg &&
        other.createdAt == createdAt &&
        other.rating == rating;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ name.hashCode ^ profileImg.hashCode ^ createdAt.hashCode ^ rating.hashCode;
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImg,
    String? createdAt,
    String? location,
    String? rating,
  }) {
    return UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        profileImg: profileImg ?? this.profileImg,
        createdAt: createdAt ?? this.createdAt,
        rating: rating ?? this.rating,
        location: location ?? this.location);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImg': profileImg,
      'location': location,
      'createdAt': createdAt,
      'rating': rating,
    };
  }
}
