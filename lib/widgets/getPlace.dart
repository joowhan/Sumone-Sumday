import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumday/models/location_model.dart';
import 'package:sumday/providers/place_api.dart';
import 'package:sumday/providers/place_provider.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class PlaceTest extends StatefulWidget {
  const PlaceTest({super.key});
  @override
  State<PlaceTest> createState() => _PlaceTestState();
}

class _PlaceTestState extends State<PlaceTest> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future? _tasks;
  final User? user = auth.currentUser;
  late String uid;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      uid = user!.uid;
    } else {
      uid = 'guest';
    }
    _tasks = PlaceData(uid: uid).getPlaceData();
  }

  Future _initPlace() async {
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
      dataList.add({
        "weather": doc["weather"],
        "temp": doc["temp"],
        "humidity": doc["humidity"],
        "description": doc["weather_description"],
        "timestamp": doc["timestamp"],
        "place": await getPlace(doc["latitude"], doc["longitude"]),
      });
    }
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (snapshot.data[index]["place"].length > 0)
                                Column(
                                  children: [
                                    Text(snapshot.data[index]["weather"]),
                                    Text("${snapshot.data[index]["temp"]}"),
                                    Text(snapshot.data[index]["description"]),
                                    for (var place in snapshot.data[index]
                                    ["place"])
                                      Column(
                                        children: [
                                          Text(place.placeName),
                                          Text(place.placeAddress),
                                          Text(place.placeCategoryName),
                                          Text(place.placeCategoryGroupName),

                                        ],
                                      ),
                                  ],
                                ),
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
                future: _tasks),
          ],
        ),
      ),
    );
  }
}
