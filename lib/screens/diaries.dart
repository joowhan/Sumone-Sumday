import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumday/models/diary_model.dart';
import 'package:sumday/models/diary_model.dart';
import 'package:sumday/models/diary_data.dart';
import 'package:sumday/screens/diaries.dart';
import 'package:sumday/widgets/diary_card.dart';

class Diaries extends StatefulWidget {
  const Diaries({Key? key}) : super(key: key);

  @override
  State<Diaries> createState() => _DiariesState();
}

class _DiariesState extends State<Diaries> {
  List<Diary> diaries = DiariesRepository.loadDiaries();

  @override
  Widget build(BuildContext context) {
    print(diaries.length);

    return ListView.builder(
      itemCount: diaries.length,
      itemBuilder: (context, index) {
        final diary = diaries[index];

        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            setState(() {
              diaries.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$diary 삭제됨'),
                action: SnackBarAction(
                  label: '취소',
                  onPressed: () {
                    setState(() {
                      diaries.insert(index, diary);
                    });
                  },
                ),
              ),
            );
          },
          background: Container(
            alignment: Alignment.centerRight,
            color: Colors.red,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                // size: 26,
              ),
            ),
          ),
          child: DiaryCard(
            assetName: diary.assetName,
            tags: diary.tags,
            date: diary.date,
            favorite: diary.favorite,
          ),
        );
      },
    );
  }
}
