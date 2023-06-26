import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumday/models/comment_model.dart';

class ExchangeDiaryModel {
  String owner;
  String diaryId;
  String content;
  String photos;
  List<String> tags;
  List<CommentModel> comments;
  Timestamp createdAt;

  ExchangeDiaryModel({
    required this.owner,
    required this.diaryId,
    required this.content,
    required this.photos,
    required this.tags,
    required this.comments,
    required this.createdAt,
  });

  ExchangeDiaryModel.fromJson(Map<String, dynamic> json)
      : owner = json["owner"],
        diaryId = json["diaryId"],
        content = json["content"],
        photos = json["photos"],
        tags = json["tags"],
        comments = json["comments"],
        createdAt = json["createdAt"];

  Map<String, Object?> toJson() => {
        'owner': owner,
        'diaryId': diaryId,
        'content': content,
        'photos': photos,
        'tags': tags,
        'comments': comments,
        'createdAt': createdAt,
      };
}
