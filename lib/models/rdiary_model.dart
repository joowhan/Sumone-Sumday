import 'package:flutter/material.dart';

class Diary {
  String userID, context;
  DateTime date;
  List<String> tags, photos;
  bool favorite;

  Diary({
    required this.userID,
    required this.date,
    required this.tags,
    required this.photos,
    required this.context,
    required this.favorite,
  });

  Diary.fromJson(Map<String, dynamic> json)
      : userID = json['userID'],
        date = json['date'].toDate(),
        tags = json['tags'].cast<String>(),
        context = json["context"],
        photos = json["photos"].cast<String>(),
        favorite = json['favorite'];

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "date": date,
        "tags": tags,
        "context": context,
        "photos": photos,
        "favorite": favorite,
      };
}
