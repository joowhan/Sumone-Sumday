import 'package:flutter/material.dart';
class Diary {
  const Diary({
    required this.id,
    required this.date,
    required this.tags,
  });

  final int id;
  final DateTime date;
  final List<String> tags;

  String get assetName => 'sorry.png';
}

class Activity {
  final IconData icon;
  final String title;

  Activity(this.icon, this.title);
}

class Relation {
  final IconData icon;
  final String title;

  Relation(this.icon, this.title);
}