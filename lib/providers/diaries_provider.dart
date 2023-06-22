import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumday/models/rdiary_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class DiariesProvider with ChangeNotifier {
  List<Diary> diaries = <Diary>[];
  List<String> docNames = [];
  bool isLoad = false;
  String? _userID;
  int _numOfDiaries = 0;

  final db = FirebaseFirestore.instance;

  String get userID => _userID!;
  int get numOfDiaries => _numOfDiaries;

  void init() {
    setUserID();
    loadAllDiaries();
  }

  void setUserID() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    _userID = auth.currentUser?.uid;
  }

  void toggleFavorite(/* Diary diary,  */ int index) async {
    // final idx = diaries.indexOf(diary);
    diaries[index].favorite = !diaries[index].favorite;

    await db.collection("diary").doc(docNames[index]).update({
      "favorite": diaries[index].favorite,
    });
    notifyListeners();
  }

  // 일기 배열 추가
  // docName : 일반적으로 저장할 때는 null 주면 됨, 삭제 복구할 때는 값 줘야함
  void addDiary(int index, Diary diary, String? docName) async {
    print(index);
    diaries.insert(index, diary);
    var _docName = await _saveDiary(diary, docName);

    docNames.insert(index, _docName);
    _numOfDiaries++;
    notifyListeners();
  }

  // 일기 배열에서 삭제
  void removeDiary(int index) async {
    diaries.removeAt(index);

    await db.collection("diary").doc(docNames[index]).delete();
    docNames.removeAt(index);
    _numOfDiaries--;
    notifyListeners();
  }

  // 일기 하나만 파베에 저장
  Future<String> _saveDiary(Diary diary, String? docName) async {
    if (docName == null) {
      DocumentReference documentReference =
          await db.collection("diary").add(diary.toJson());
      docName = documentReference.id;
    } else {
      await db.collection("diary").doc(docName).set(diary.toJson());
    }

    return docName;
  }

  // 일기 파베에서 로딩
  void loadAllDiaries() async {
    if (!isLoad) {
      isLoad = true; // 아래 작업들이 비동기 : 아래에 있으면 여러번 이 함수 실행 됨
      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('diary')
          .where("userID", isEqualTo: _userID)
          .get();

      for (var doc in snapshot.docs) {
        docNames.add(doc.id);
        diaries.add(Diary.fromJson(doc.data()));
        _numOfDiaries++;
      }
      // diaries = snapshot.docs.map((e) => Diary.fromJson(e.data())).toList();
    }
  }

  Future<List<String>> saveImage(List<String> imgUrls) async {
    List<String> fileNames = [];

    for (var imgUrl in imgUrls) {
      final response = await http.get(Uri.parse(imgUrl));
      final Uint8List imageBytes = response.bodyBytes;
      final uuid = Uuid().v1();
      final fileName = '$uuid.png';

      final imageRef = FirebaseStorage.instance.ref().child(fileName);
      await imageRef.putData(imageBytes);
      fileNames.add(fileName);
    }

    return fileNames;
  }
}
