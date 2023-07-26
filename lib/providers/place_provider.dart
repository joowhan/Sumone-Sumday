import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumday/providers/place_api.dart';

class PlaceData {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String uid;

  PlaceData({required this.uid});

  Future<List<dynamic>> getPlaceData() async {
    var utcNow = DateTime.now();
    var now = utcNow.add(const Duration(hours: 9));
    DateTime today =
        DateTime(now.year, now.month, now.day, 6); //테스트용으로 06시 이후에 불러옴
    Timestamp todayTimestamp = Timestamp.fromDate(today);
    final ref = db
        .collection("location")
        .where("uid", isEqualTo: uid)
        .where("timestamp", isGreaterThan: todayTimestamp);
    final snap = await ref.get();
    final List<QueryDocumentSnapshot> docs = snap.docs;
    var dataList = [];

    for (QueryDocumentSnapshot doc in docs) {
      if (doc.exists == true) {
        dataList.add({
          "count": doc["count"],
          "weather": doc["weather"],
          "temp": doc["temp"],
          "humidity": doc["humidity"],
          "description": doc["weather_description"],
          "timestamp": doc["timestamp"],
          "place": await getPlace(doc["latitude"], doc["longitude"]),
        });
      }
    }
    dataList.sort(
      (a, b) => a["count"].compareTo(b["count"]),
    );
    var sortedDatalist =
        dataList.reversed.toList().sublist(0, min(3, dataList.length));
    sortedDatalist.sort((a, b) => a["timestamp"].compareTo(b["timestamp"]));
    return sortedDatalist;
  }
}
