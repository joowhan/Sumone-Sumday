import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sumday/models/location_model.dart';
import 'package:sumday/models/visited_place_model.dart';
import 'package:sumday/providers/place_api.dart';
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
  late String weather;
  late double temp;
  late int humidity;
  late String description;
  late Timestamp timestamp;
  List<VisitedPlaceModel>? place;
  @override
  void initState() {
    super.initState();
    if (user != null) {
      uid = user!.uid;
    } else {
      uid = 'guest';
    }
    _tasks = _initPlace();
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
    place = await getPlacesKakao(docs[0]["latitude"], docs[0]["longitude"]);
    return {
      "weather": snap.docs[0]["weather"],
      "temp": snap.docs[0]["temp"],
      "humidity": snap.docs[0]["humidity"],
      "description": snap.docs[0]["weather_description"],
      "timestamp": snap.docs[0]["timestamp"],
      "place": place
    };
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Text(snapshot.data!["place"][0].placeName),
                          Text(snapshot.data!["place"][0].placeAddress),
                          Text(snapshot.data!["place"][0].placeCategoryName),
                          Text(snapshot
                              .data!["place"][0].placeCategoryGroupName),
                          Text(snapshot.data!["weather"]),
                          Text(snapshot.data!["temp"].toString()),
                          Text(snapshot.data!["description"]),
                          Text(snapshot.data!["timestamp"].toString()),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                  future: _tasks),
            ],
          ),
        ),
      ),
    );
  }
}
// Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//   return ListView(
//     padding: const EdgeInsets.only(top: 20.0),
//     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//   );
// }
// Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
//   final record = LocationModel.fromSnapshot(data);
//   return Padding(
//     key: ValueKey(record.uid),
//     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//     child: Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(5.0),
//       ),
//       child: ListTile(
//         title: Text(record.uid),
//         trailing: Text(record.latitude.toString()),
//         onTap: () => print(record),
//       ),
//     ),
//   );
// }