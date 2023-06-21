import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FBTest extends StatefulWidget {
  const FBTest({super.key});

  @override
  State<FBTest> createState() => _FBTestState();
}

class _FBTestState extends State<FBTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appbar Test"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              // var pushData = TestSet(
              //     A: 'this is test input',
              //     B: 10,
              //     C: DateTime.now(),
              //     D: <String>['test1', 'test2', 'test3', 'test4']);
              // db.collection("firebase_test").add(pushData.getMap()).then(
              //       (DocumentReference doc) =>
              //           print('DocumentSnapshot added with ID: ${doc.id}'),
              //     );
              // print('DocumentSnapshot added with ID: ${pushData}');
              print('do this!');
              final db = FirebaseFirestore.instance;
              await db.collection("cars").doc().set(
                {
                  "brand": "Genesis22222",
                  "name": "G80",
                  "price": 7000,
                },
              );
            },
            child: Text('Click'),
          ),
        ],
      ),
    );
  }
}

class TestSet {
  String A;
  int B;
  DateTime C;
  List<String> D;

  TestSet({
    required this.A,
    required this.B,
    required this.C,
    required this.D,
  });

  Map<String, dynamic> getMap() {
    return <String, dynamic>{
      "A": A,
      "B": B,
      "C": C,
      "D": D,
    };
  }
}
