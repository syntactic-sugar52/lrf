import 'dart:convert';

class UserModel {
  String? id;
  String? email;
  String? name;
  String? profileImg;
  String? createdAt;
  String? magicToken;
  String? rating;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.profileImg,
    this.createdAt,
    this.magicToken,
    this.rating,
  });
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImg,
    String? createdAt,
    String? magicToken,
    String? rating,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImg: profileImg ?? this.profileImg,
      createdAt: createdAt ?? this.createdAt,
      magicToken: magicToken ?? this.magicToken,
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
      'magicToken': magicToken,
      'rating': rating,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      profileImg: map['profileImg'],
      createdAt: map['createdAt'],
      magicToken: map['magicToken'],
      rating: map['rating'],
    );
  }
  String toJson() => json.encode(toMap());
  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, profileImg: $profileImg, createdAt: $createdAt, magicToken: $magicToken, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.profileImg == profileImg &&
        other.createdAt == createdAt &&
        other.magicToken == magicToken &&
        other.rating == rating;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ name.hashCode ^ profileImg.hashCode ^ createdAt.hashCode ^ magicToken.hashCode ^ rating.hashCode;
  }
}
