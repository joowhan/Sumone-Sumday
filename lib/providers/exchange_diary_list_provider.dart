import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sumday/models/exchange_diary_list_model.dart';
import 'package:sumday/models/exchange_diary_model.dart';

class ExchangeDiaryListProvider with ChangeNotifier {
  List<ExchangeDiaryListModel> diaryList = [];
  List<String> docIds = [];
  String? uid;
  bool isLoad = false;

  final db = FirebaseFirestore.instance;

  void setUid() {
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  // Read
  Future<void> fetchDiaryList() async {
    setUid();
    final QuerySnapshot snapshot = await db
        .collection('exchangeDiaryList')
        .where("participants", arrayContains: uid)
        .get();
    List<ExchangeDiaryListModel> loadedDiaries = [];
    List<String> loadedDocIds = [];

    for (var i = 0; i < snapshot.docs.length; i++) {
      final data = snapshot.docs[i].data() as Map<String, dynamic>?;
      final diary = ExchangeDiaryListModel.fromJson(data!);
      // loadedDiaries.add(diary);
      // loadedDocIds.add(snapshot.docs[i].id);
      loadedDiaries = [...loadedDiaries, diary];
      loadedDocIds = [...loadedDocIds, snapshot.docs[i].id];
    }
    diaryList = loadedDiaries;
    docIds = loadedDocIds;
    isLoad = true;
    notifyListeners();
  }

  // Create
  Future<void> addDiaryList(ExchangeDiaryListModel diary) async {
    final doc = await db.collection('exchangeDiaryList').add(diary.toJson());
    final newDiary = ExchangeDiaryListModel(
      title: diary.title,
      owner: diary.owner,
      participants: diary.participants,
      diaryList: diary.diaryList,
      hexColor: diary.hexColor,
      order: diary.order,
      createdAt: diary.createdAt,
    );
    // diaryList.add(newDiary);
    // docIds.add(doc.id);
    diaryList = [...diaryList, newDiary];
    docIds = [...docIds, doc.id];
    notifyListeners();
  }

  // 일기를 일기장에 추가
  Future<void> addDiary(ExchangeDiaryModel diary, String docId) async {
    final diaryObject = diary.toJson();
    final docRef = db.collection('exchangeDiaryList').doc(docId);
    final snapshot = await docRef.get();
    List<dynamic>? existingDiaries = snapshot.data()?['diaries'];

    if (existingDiaries == null) {
      existingDiaries = [diaryObject];
    } else {
      // existingDiaries.add(diaryObject);
      existingDiaries = [...existingDiaries, diaryObject];
    }

    await docRef.update({'diaries': existingDiaries});
    notifyListeners();
  }

  // Update
  Future<void> updateDiaryList(
      ExchangeDiaryListModel diary, String docId) async {
    final index =
        diaryList.indexWhere((element) => element.title == diary.title);
    if (index >= 0) {
      await db
          .collection('exchangeDiaryList')
          .doc(docId)
          .update(diary.toJson());
      diaryList[index] = diary;
      notifyListeners();
    }
  }

  // participants에 사용자 추가
  Future<void> addParticipants(String docId, String uid) async {
    final index = diaryList.indexWhere((element) => element == docId);
    final docRef = db.collection('exchangeDiaryList').doc(docId);
    final snapshot = await docRef.get();
    List<dynamic>? existingParticipants = snapshot.data()?['participants'];

    if (existingParticipants == null) {
      existingParticipants = [uid];
    } else {
      existingParticipants = [...existingParticipants, uid];
    }

    await docRef.update({'participants': existingParticipants});
    diaryList[index].participants = existingParticipants;
    notifyListeners();
  }

  // Delete
  Future<void> deleteDiaryList(String docId) async {
    final index = docIds.indexWhere((element) => element == docId);
    if (index >= 0) {
      await db.collection('exchangeDiaryList').doc(docId).delete();
      diaryList.removeAt(index);
      docIds.removeAt(index);
      notifyListeners();
    }
  }
}
