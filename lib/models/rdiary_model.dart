import 'package:flutter/material.dart';

class Diary {
  final int userID, diaryID;
  DateTime date;
  final List<String> tags, photos;
  String context;
  bool favorite;

  Diary({
    required this.userID,
    required this.diaryID,
    required this.date,
    required this.tags,
    required this.photos,
    required this.context,
    required this.favorite,
  });
}
