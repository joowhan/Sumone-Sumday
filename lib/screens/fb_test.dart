import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sumday/models/rdiary_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sumday/providers/diaries_provider.dart';

class FBTest extends StatefulWidget {
  const FBTest({super.key});

  @override
  State<FBTest> createState() => _FBTestState();
}

class _FBTestState extends State<FBTest> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DiariesProvider>(builder: (context, diariesProvider, _) {
      List<Diary> diaries = diariesProvider.diaries;

      return Scaffold(
        appBar: AppBar(
          title: Text("Appbar Test"),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                diariesProvider.printDocNames();
              },
              child: Text('Click'),
            ),
          ],
        ),
      );
    });
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
