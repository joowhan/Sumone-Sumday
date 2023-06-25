import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String ownerId;
  String ownerName;
  String ownerPhoto;
  String content;
  Timestamp createdAt;

  CommentModel({
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhoto,
    required this.content,
    required this.createdAt,
  });

  CommentModel.fromJson(Map<String, dynamic> json)
      : ownerId = json["ownerId"],
        ownerName = json["ownerName"],
        ownerPhoto = json["ownerPhoto"],
        content = json["content"],
        createdAt = json["createdAt"];

  Map<String, Object?> toJson() => {
        'ownerId': ownerId,
        'ownerName': ownerName,
        'ownerPhoto': ownerPhoto,
        'content': content,
        'createdAt': createdAt,
      };
}
