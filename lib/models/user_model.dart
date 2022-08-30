import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? email;
  String? name;
  String? profileImg;
  String? createdAt;

  String? rating;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.profileImg,
    this.createdAt,
    this.rating,
  });
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImg,
    String? createdAt,
    String? rating,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImg: profileImg ?? this.profileImg,
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImg': profileImg,
      'createdAt': createdAt,
      'rating': rating,
    };
  }

  UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"],
        email = doc.data()!["email"];
  // salary = doc.data()!["salary"],
  // address = Address.fromMap(doc.data()!["address"]),
  // employeeTraits = doc.data()?["employeeTraits"] == null
  // ? null
  // : doc.data()?["employeeTraits"].cast<String>();

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      profileImg: map['profileImg'],
      createdAt: map['createdAt'],
      rating: map['rating'],
    );
  }
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
}
