import 'package:cloud_firestore/cloud_firestore.dart';

class ExchangeDiaryListModel {
  String title;
  String owner;
  List<dynamic> participants;
  List<dynamic> diaryList;
  String hexColor;
  int order;
  Timestamp createdAt;

  ExchangeDiaryListModel({
    required this.title,
    required this.owner,
    required this.participants,
    required this.diaryList,
    required this.hexColor,
    required this.order,
    required this.createdAt,
  });

  ExchangeDiaryListModel.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        owner = json["owner"],
        participants = json["participants"],
        diaryList = json["diaryList"],
        hexColor = json["hexColor"],
        order = json["order"],
        createdAt = json["createdAt"];

  Map<String, Object?> toJson() => {
        'title': title,
        'owner': owner,
        'participants': participants,
        'diaryList': diaryList,
        'hexColor': hexColor,
        'order': order,
        'createdAt': createdAt,
      };
}
