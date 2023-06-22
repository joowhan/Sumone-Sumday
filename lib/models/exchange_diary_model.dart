import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumday/models/comment_model.dart';

class ExchangeDiaryModel {
  String title;
  String content;
  String owner;
  String imageUrl;
  List<String> hashTags;
  String placeName;
  List<CommentModel> comments;
  Timestamp createdAt;

  ExchangeDiaryModel({
    required this.title,
    required this.content,
    required this.owner,
    required this.imageUrl,
    required this.hashTags,
    required this.placeName,
    required this.comments,
    required this.createdAt,
  });

  ExchangeDiaryModel.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        content = json["content"],
        owner = json["owner"],
        imageUrl = json["imageUrl"],
        hashTags = json["hashTags"],
        placeName = json["placeName"],
        comments = json["comments"],
        createdAt = json["createdAt"];

  Map<String, Object?> toJson() => {
        'title': title,
        'content': content,
        'owner': owner,
        'imageUrl': imageUrl,
        'hastTags': hashTags,
        'placeName': placeName,
        'comments': comments,
        'createdAt': createdAt,
      };
}
