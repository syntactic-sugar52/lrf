import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  DataModel(
      {this.title,
      this.description,
      this.username,
      this.subAdminArea,
      this.profImage,
      this.contactEmail,
      this.contactNumber,
      this.datePublished,
      this.downVote,
      this.postId,
      this.upvote,
      this.userId});

  final String? contactEmail;
  final String? contactNumber;
  final Timestamp? datePublished;
  final String? description;
  final List? downVote;
  final String? postId;
  final String? profImage;
  final String? subAdminArea;
  final String? title;
  final List? upvote;
  final String? userId;
  final String? username;

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;

      return DataModel(
          profImage: dataMap['profImage'],
          title: dataMap['title'],
          description: dataMap['description'],
          subAdminArea: dataMap['subAdminArea'],
          contactEmail: dataMap['contactEmail'],
          contactNumber: dataMap['contactNumber'],
          datePublished: dataMap['datePublished'],
          userId: dataMap['userId'],
          postId: dataMap['postId'],
          upvote: dataMap['upVote'],
          downVote: dataMap['downVote'],
          username: dataMap['username']);
    }).toList();
  }
}
