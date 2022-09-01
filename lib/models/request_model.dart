import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  RequestModel({
    this.id,
    this.userId,
    this.userName,
    this.endLocation,
    this.headline,
    this.instructions,
    this.startLocation,
    this.time,
  });

  factory RequestModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data();
    return RequestModel(
        id: json?['id'] ?? '',
        userId: json?["userId"] ?? '',
        userName: json?["userName"] ?? '',
        headline: json?["headline"] ?? '',
        endLocation: json?['endLocation'] ?? '',
        startLocation: json?['startLocation'] ?? '',
        instructions: json?['instructions'] ?? '',
        time: json?['time'] ?? '');
  }

  factory RequestModel.fromJson(String source) => RequestModel.fromMap(json.decode(source));

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'],
      endLocation: map['endLocation'],
      headline: map['headline'],
      instructions: map['instructions'],
      startLocation: map['startLocation'],
      time: map['time'],
    );
  }

  String? endLocation;
  String? headline;
  String? id;
  String? instructions;
  String? startLocation;
  String? time;
  String? userId;
  String? userName;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RequestModel &&
        other.id == id &&
        other.userId == userId &&
        other.userName == userName &&
        other.endLocation == endLocation &&
        other.headline == headline &&
        other.instructions == instructions &&
        other.startLocation == startLocation &&
        other.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        userName.hashCode ^
        endLocation.hashCode ^
        headline.hashCode ^
        instructions.hashCode ^
        startLocation.hashCode ^
        time.hashCode;
  }

  @override
  String toString() {
    return 'RequestModel(id: $id, userId: $userId, userName: $userName, endLocation: $endLocation, headline: $headline, instructions: $instructions, startLocation: $startLocation, time: $time)';
  }

  RequestModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? endLocation,
    String? headline,
    String? instructions,
    String? startLocation,
    String? time,
  }) {
    return RequestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      endLocation: endLocation ?? this.endLocation,
      headline: headline ?? this.headline,
      instructions: instructions ?? this.instructions,
      startLocation: startLocation ?? this.startLocation,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'endLocation': endLocation,
      'headline': headline,
      'instructions': instructions,
      'startLocation': startLocation,
      'time': time,
    };
  }

  String toJson() => json.encode(toMap());
}
