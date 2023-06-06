import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumday/models/location_model.dart';
import 'package:sumday/providers/place_api.dart';

class PlaceData {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String uid;

  PlaceData({required this.uid});

  Future<List<dynamic>> getPlaceData() async {
    final ref = db
        .collection("location")
        .withConverter(
            fromFirestore: LocationModel.fromFirestore,
            toFirestore: (LocationModel location, _) => location.toFirestore())
        .where("uid", isEqualTo: uid);
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
    return dataList;
  }
}
