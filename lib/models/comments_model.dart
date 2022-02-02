import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModel {
  String? text;
  Timestamp? created;
  String? uId;
  String? uName;
  String? uImage;

  CommentsModel({
    this.text,
    this.created,
    this.uId,
    this.uName,
    this.uImage,
  });
  CommentsModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    created = json['created'];
    uId = json['uId'];
    uName = json['uName'];
    uImage = json['uImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'created': created,
      'uId': uId,
      'uName': uName,
      'uImage': uImage,
    };
  }
}
