// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:sumday/models/location_model.dart';
// import 'package:sumday/providers/place_api.dart';
// final FirebaseAuth auth = FirebaseAuth.instance;
// class PlaceTest extends StatefulWidget {
//   const PlaceTest({super.key});
//   @override
//   State<PlaceTest> createState() => _PlaceTestState();
// }
// class _PlaceTestState extends State<PlaceTest> {
//   FirebaseFirestore db = FirebaseFirestore.instance;
//   final User? user = auth.currentUser;
//   late final ref;
//   late String uid;
//   late Future<List<dynamic>> place;
//   @override
//   void initState() {
//     super.initState();
//     if (user != null) {
//       uid = user!.uid;
//     } else {
//       uid = 'guest';
//     }
//     initPlace();
//   }
//   Future<void> initPlace() async {
//     ref = db
//         .collection("location")
//         .withConverter(
//         fromFirestore: LocationModel.fromFirestore,
//         toFirestore: (LocationModel location, _) => location.toFirestore())
//         .where("uid", isEqualTo: uid);
//     final snap = await ref.get();
//     final List<QueryDocumentSnapshot> docs = snap.docs;
//     place = getPlace(docs[0]["latitude"], docs[0]["longitude"]);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             FutureBuilder(
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return Text(snapshot.data.toString());
//                   } else {
//                     return const CircularProgressIndicator();
//                   }
//                 },
//                 future: place),
//           ],
//         ),
//       ),
//     );
//   }
// }