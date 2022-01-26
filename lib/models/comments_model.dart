import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModel {
  String? text;
  Timestamp? created;
  String? uId;

  CommentsModel({
    this.text,
    this.created,
    this.uId,
  });
  CommentsModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    created = json['Timestamp'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'created': created,
      'uId': uId,
    };
  }
}
