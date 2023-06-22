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

  void toggleFavorite(/* Diary diary,  */ int index) async {
    // final idx = diaries.indexOf(diary);
    diaries[index].favorite = !diaries[index].favorite;

    await db.collection("diary").doc(docNames[index]).update({
      "favorite": diaries[index].favorite,
    });
    notifyListeners();
  }

  // 일기 배열에 추가
  void addDiary(int index, Diary diary, String? docName) async {
    diaries.insert(index, diary);
    var docName0 = await saveDiary(diary, docName);

    docNames.insert(index, docName0);
    notifyListeners();
  }

  // 일기 배열에서 삭제
  void removeDiary(int index) async {
    diaries.removeAt(index);

    await db.collection("diary").doc(docNames[index]).delete();
    docNames.removeAt(index);

    notifyListeners();
  }

  // 일기 하나만 파베에 저장
  Future<String> saveDiary(Diary diary, String? docName) async {
    if (docName == null) {
      DocumentReference documentReference =
          await db.collection("diary").add(diary.toJson());
      docName = documentReference.id;
    } else {
      await db.collection("diary").doc().set(diary.toJson());
    }

    return docName;
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
