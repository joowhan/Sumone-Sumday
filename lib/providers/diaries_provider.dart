import 'package:sumday/models/diary_data.dart';
import 'package:sumday/models/diary_model.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class DiariesProvider with ChangeNotifier {
  List<Diary> diaries = DiariesRepository.loadDiaries();

  void toggleFavorite(Diary diary) {
    final index = diaries.indexOf(diary);
    diaries[index].favorite = !diaries[index].favorite;
    notifyListeners();
  }

  void addDiary(Diary diary, int index) {
    diaries.insert(index, diary);
    notifyListeners();
  }

  void removeDiary(Diary diary, int index) {
    // diaries.remove(diary);
    diaries.removeAt(index);
    notifyListeners();
  }
}
