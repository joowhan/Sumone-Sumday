import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sumday/models/comment_model.dart';
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
    List<ExchangeDiaryListModel> loadedDiaries = []; // db에서 불러온 일기 내용
    List<String> loadedDocIds = []; // db에서 불러온 일기의 id

    for (var i = 0; i < snapshot.docs.length; i++) {
      final data = snapshot.docs[i].data() as Map<String, dynamic>?;
      final diary = ExchangeDiaryListModel.fromJson(data!);
      loadedDiaries = [...loadedDiaries, diary];
      loadedDocIds = [...loadedDocIds, snapshot.docs[i].id];
    }
    // db에서 불러온 데이터를 Provider에 저장
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
    diaryList = [...diaryList, newDiary];
    docIds = [...docIds, doc.id];
    notifyListeners();
  }

  // 일기를 일기장에 추가
  Future<void> addDiary(ExchangeDiaryModel diary, String docId) async {
    final diaryObject = diary.toJson();
    final docRef = db.collection('exchangeDiaryList').doc(docId);
    final snapshot = await docRef.get();
    List<dynamic>? existingDiaries = snapshot.data()?['diaryList'];
    if (existingDiaries == null) {
      existingDiaries = [diaryObject];
    } else {
      existingDiaries = [...existingDiaries, diaryObject];
    }

    docRef.update({'diaryList': existingDiaries});
    diaryList[docIds.indexWhere((element) => element == docId)].diaryList =
        existingDiaries;
    notifyListeners();
  }

  // participants에 사용자 추가
  Future<void> addParticipants(String docId, String uid) async {
    final index = docIds.indexWhere((element) => element == docId);
    final docRef = db.collection('exchangeDiaryList').doc(docId);
    final snapshot = await docRef.get();
    List<dynamic>? existingParticipants = snapshot.data()?['participants'];

    if (existingParticipants == null) {
      existingParticipants = [uid];
    } else {
      existingParticipants = [...existingParticipants, uid];
    }

    docRef.update({'participants': existingParticipants});
    diaryList[index].participants = existingParticipants;
    notifyListeners();
  }

  // diaryList > comments에 댓글 추가
  Future<void> addComments(
      String docId, int diaryIndex, CommentModel comment) async {
    final index = docIds.indexWhere((element) => element == docId);
    final docRef = db.collection('exchangeDiaryList').doc(docId);
    final snapshot = await docRef.get();
    final commentData = comment.toJson();
    List<dynamic>? existingDiaries = snapshot.data()?['diaryList'];
    List<dynamic>? existingComments = existingDiaries![diaryIndex]['comments'];

    if (existingComments == null) {
      existingComments = [commentData];
    } else {
      existingComments = [...existingComments, commentData];
    }

    existingDiaries[diaryIndex]['comments'] = existingComments;
    docRef.update({'diaryList': existingDiaries});
    diaryList[index].diaryList = existingDiaries;
    notifyListeners();
  }

  // 일기 작성 완료시 작성 차례를 다음 순서로 변경
  Future<void> setOrder(String docId, int order) async {
    final index = docIds.indexWhere((element) => element == docId);
    final docRef = db.collection('exchangeDiaryList').doc(docId);
    docRef.update({'order': order});
    diaryList[index].order = order;
    notifyListeners();
  }

  // Delete
  Future<void> deleteDiaryList(String docId) async {
    final index = docIds.indexWhere((element) => element == docId);
    if (index >= 0) {
      db.collection('exchangeDiaryList').doc(docId).delete();
      diaryList.removeAt(index);
      docIds.removeAt(index);
      notifyListeners();
    }
  }
}
