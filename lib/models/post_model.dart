class PostModel {
  String? uId;
  String? postText;
  String? postImage;
  String? postDateTime;

  PostModel({
    this.uId,
    this.postText,
    this.postImage,
    this.postDateTime,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    postText = json['postText'];
    postImage = json['postImage'];
    postDateTime = json['postDateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'postText': postText,
      'postImage': postImage,
      'postDateTime': postDateTime,
    };
  }
}
