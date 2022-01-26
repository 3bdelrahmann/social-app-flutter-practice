import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModel {
  String? text;
  Timestamp? created;
  String? uId;
  String? uName;

  CommentsModel({
    this.text,
    this.created,
    this.uId,
    this.uName,
  });
  CommentsModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    created = json['created'];
    uId = json['uId'];
    uName = json['uName'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'created': created,
      'uId': uId,
      'uName': uName,
    };
  }
}
