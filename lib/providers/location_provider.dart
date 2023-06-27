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

    final QuerySnapshot snapshot =
        await db.collection('location').where("uid", isEqualTo: uid).get();
    List<RLocationModel> loadedLocations = [];
    List<String> loadedDocIds = [];
    for (var i = 0; i < snapshot.docs.length; i++) {
      final data = snapshot.docs[i].data() as Map<String, dynamic>?;
      final location = RLocationModel.fromJson(data!);
      // loadedLocations.add(location);
      // loadedDocIds.add(snapshot.docs[i].id);
      loadedLocations = [...loadedLocations, location];
      loadedDocIds = [...loadedDocIds, snapshot.docs[i].id];
    }
    locationList = loadedLocations;
    docIds = loadedDocIds;
    isLoad = true;
    notifyListeners();
  }
}
