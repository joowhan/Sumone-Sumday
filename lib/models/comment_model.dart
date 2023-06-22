import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String owner;
  String content;
  Timestamp createdAt;

  CommentModel({
    required this.owner,
    required this.content,
    required this.createdAt,
  });

  CommentModel.fromJson(Map<String, dynamic> json)
      : owner = json["owner"],
        content = json["content"],
        createdAt = json["createdAt"];

  Map<String, Object?> toJson() => {
        'owner': owner,
        'content': content,
        'createdAt': createdAt,
      };
}
