import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumday/models/rdiary_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiariesProvider with ChangeNotifier {
  List<Diary> diaries = <Diary>[];
  List<String> docNames = [];
  bool isLoad = false;
  String? userID;

  final db = FirebaseFirestore.instance;

  void setUserID() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    userID = auth.currentUser?.uid;
  }

  void printDocNames() {
    print(docNames);
  }

  void toggleFavorite(/* Diary diary,  */ int index) {
    // final idx = diaries.indexOf(diary);
    diaries[index].favorite = !diaries[index].favorite;
    notifyListeners();
  }

  // 일기 배열에 추가
  void addDiary(int index, Diary diary, String docName) {
    diaries.insert(index, diary);
    docNames.insert(index, docName);
    notifyListeners();
  }

  // 일기 배열에서 삭제
  void removeDiary(int index) {
    diaries.removeAt(index);
    docNames.removeAt(index);
    notifyListeners();
  }

  // 일기 하나만 파베에 저장
  void saveDiary(Diary diary) async {
    await db.collection("diary").doc().set(diary.toJson());
  }

  // 일기 파베에서 로딩
  void loadAllDiaries() async {
    if (!isLoad) {
      isLoad = true; // 아래 작업들이 비동기 : 아래에 있으면 여러번 이 함수 실행 됨
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await db.collection('diary').where("userID", isEqualTo: userID).get();

      for (var doc in snapshot.docs) {
        docNames.add(doc.id);
        diaries.add(Diary.fromJson(doc.data()));
      }
      // diaries = snapshot.docs.map((e) => Diary.fromJson(e.data())).toList();
    }
  }
}
