import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumday/models/comment_model.dart';

class ExchangeDiaryModel {
  String diaryId;
  List<CommentModel> comments;
  Timestamp createdAt;

  ExchangeDiaryModel({
    required this.diaryId,
    required this.comments,
    required this.createdAt,
  });

  ExchangeDiaryModel.fromJson(Map<String, dynamic> json)
      : diaryId = json["diaryId"],
        comments = json["comments"],
        createdAt = json["createdAt"];

  Map<String, Object?> toJson() => {
        'diaryId': diaryId,
        'comments': comments,
        'createdAt': createdAt,
      };
}
