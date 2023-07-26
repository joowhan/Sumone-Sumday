import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumday/models/rdiary_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

class DiariesProvider with ChangeNotifier {
  List<Diary> diaries = <Diary>[];
  List<String> docNames = [];
  bool isLoad = false;
  String? _userID;
  int _numOfDiaries = 0;

  final db = FirebaseFirestore.instance;

  String get userID => _userID!;
  int get numOfDiaries => _numOfDiaries;

  String generateUuid() {
    return const Uuid().v1();
  }

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

  // 일기 추가
  // docName : 일반적으로 저장할 때는 null 주면 됨, 삭제 복구할 때는 값 줘야함
  Future<String> addDiary(int index, Diary diary, String? docName) async {
    diaries.insert(index, diary);
    var docName0 = await _saveDiary(diary, docName);

    docNames.insert(index, docName0);
    _numOfDiaries++;
    notifyListeners();
    return docName0;
  }

  // 일기 업데이트
  // docName : 일반적으로 저장할 때는 null 주면 됨, 삭제 복구할 때는 값 줘야함
  Future<String> updateDiary(int index, Diary diary, String? docName) async {
    diaries[index] = diary;
    var docName0 = await _saveDiary(diary, docName);

    docNames[index] = docName0;
    notifyListeners();
    return docName0;
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

  // 파베에 이미지 저장
  Future<List<String>> saveImageToFirebase(List<String> imgUrls) async {
    List<String> fileNames = [];

    for (var imgUrl in imgUrls) {
      final response = await http.get(Uri.parse(imgUrl));
      final Uint8List imageBytes = response.bodyBytes;
      final uuid = generateUuid();
      final fileName = '$uuid.png';

      final imageRef = FirebaseStorage.instance.ref().child(fileName);
      await imageRef.putData(imageBytes);
      fileNames.add(fileName);
    }

    return fileNames;
  }

  // 내부 저장소에 이미지 저장
  Future<void> saveImageToStorage(String url) async {
    var response = await http.get(Uri.parse(url));
    final Uint8List bytes = response.bodyBytes;
    final uuid = generateUuid();

    Directory dir = await getApplicationDocumentsDirectory();
    String filePath = '${dir.path}/$uuid.png';

    File file = File(filePath);
    await file.writeAsBytes(bytes);
    print('이미지 저장 경로: $filePath');
  }
}
