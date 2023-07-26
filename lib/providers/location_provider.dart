import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sumday/models/rlocation_model.dart';

class LocationProvider with ChangeNotifier {
  List<RLocationModel> locationList = [];
  List<String> docIds = [];
  String? uid;
  bool isLoad = false;

  final db = FirebaseFirestore.instance;

  void setUid() {
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  // Read
  Future<void> fetchLocationList() async {
    setUid();
    DateTime now = DateTime.now();
    DateTime today =
        DateTime(now.year, now.month, now.day - 1, 6); //전날 6시 이후로 저장된 위치만 가져옴
    Timestamp todayTimestamp = Timestamp.fromDate(today);
    final QuerySnapshot snapshot = await db
        .collection('location')
        .where("uid", isEqualTo: uid)
        .where("timestamp", isGreaterThanOrEqualTo: todayTimestamp)
        .get();
    List<RLocationModel> loadedLocations = [];
    List<String> loadedDocIds = [];
    for (var i = 0; i < snapshot.docs.length; i++) {
      final data = snapshot.docs[i].data() as Map<String, dynamic>?;
      final location = RLocationModel.fromJson(data!);
      loadedLocations = [...loadedLocations, location];
      loadedDocIds = [...loadedDocIds, snapshot.docs[i].id];
    }
    locationList = loadedLocations;
    docIds = loadedDocIds;
    isLoad = true;
    notifyListeners();
  }
}
