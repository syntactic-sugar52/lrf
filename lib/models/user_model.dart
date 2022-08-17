import 'dart:convert';

class UserModel {
  String? id;
  String? phoneNumber;
  String? profileImg;
  String? createdAt;
  String? magicToken;
  String? rating;

  UserModel({
    this.id,
    this.phoneNumber,
    this.profileImg,
    this.createdAt,
    this.magicToken,
    this.rating,
  });
  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? profileImg,
    String? createdAt,
    String? magicToken,
    String? rating,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImg: profileImg ?? this.profileImg,
      createdAt: createdAt ?? this.createdAt,
      magicToken: magicToken ?? this.magicToken,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'profileImg': profileImg,
      'createdAt': createdAt,
      'magicToken': magicToken,
      'rating': rating,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      phoneNumber: map['phoneNumber'],
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
    return 'UserModel(id: $id, phoneNumber: $phoneNumber, profileImg: $profileImg, createdAt: $createdAt, magicToken: $magicToken, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.phoneNumber == phoneNumber &&
        other.profileImg == profileImg &&
        other.createdAt == createdAt &&
        other.magicToken == magicToken &&
        other.rating == rating;
  }

  @override
  int get hashCode {
    return id.hashCode ^ phoneNumber.hashCode ^ profileImg.hashCode ^ createdAt.hashCode ^ magicToken.hashCode ^ rating.hashCode;
  }
}
