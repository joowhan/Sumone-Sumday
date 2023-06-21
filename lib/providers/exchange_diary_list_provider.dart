import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sumday/models/exchange_diary_list_model.dart';

class ExchangeDiaryListProvider with ChangeNotifier {
  List<ExchangeDiaryListModel> diaries = [];
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
    final List<ExchangeDiaryListModel> loadedDiaries = [];
    final List<String> loadedDocIds = [];

    for (var i = 0; i < snapshot.docs.length; i++) {
      final data = snapshot.docs[i].data() as Map<String, dynamic>?;
      final diary = ExchangeDiaryListModel.fromJson(data!);
      loadedDiaries.add(diary);
      loadedDocIds.add(snapshot.docs[i].id);
    }
    diaries = loadedDiaries;
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
      hexColor: diary.hexColor,
      order: diary.order,
      createdAt: diary.createdAt,
    );
    diaries.add(newDiary);
    docIds.add(doc.id);
    notifyListeners();
  }

  // Update
  Future<void> updateDiaryList(
      ExchangeDiaryListModel diary, String docId) async {
    final index = diaries.indexWhere((element) => element.title == diary.title);
    if (index >= 0) {
      await db
          .collection('exchangeDiaryList')
          .doc(docId)
          .update(diary.toJson());
      diaries[index] = diary;
      notifyListeners();
    }
  }

  // Delete
  Future<void> deleteDiaryList(String docId) async {
    final index = docIds.indexWhere((element) => element == docId);
    if (index >= 0) {
      await db.collection('exchangeDiaryList').doc(docId).delete();
      diaries.removeAt(index);
      docIds.removeAt(index);
      notifyListeners();
    }
  }
}
