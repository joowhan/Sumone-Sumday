import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumday/models/diary_model.dart';
import 'package:intl/intl.dart';

import 'package:sumday/models/diary_model.dart';
import 'package:sumday/models/diary_data.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({Key? key}) : super(key: key);

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  List<Card> _buildGridCards(BuildContext context) {
    List<Diary> diaries = DiariesRepository.loadDiaries();

    String _formattedDate(DateTime time) =>
        DateFormat('yyyy-MM-dd').format(time);

    String _joinWithHash(List<String> list) {
      return list.map((item) => '#$item').join(' ');
    }

    if (diaries.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);

    return diaries.where((diary) => diary.favorite).map((diary) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 12 / 10,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4.5, 4.5, 4.5, 4.5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    // border: Border.all(
                    //   color: Colors.black,
                    //   width: 1.0,
                    // ),
                  ),
                  child: Image.asset(
                    'assets/${diary.assetName}',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 12.0),
                    Text(
                      _joinWithHash(diary.tags),
                      style: const TextStyle(
                          color: Color.fromARGB(0xff, 0x13, 0x67, 0x50),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      _formattedDate(diary.date),
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      // _joinWithHash('diary.tags'),
                      '여기는 일기 내용이 오는 곳이에요. 일기 내용은 나중에 디비에서 가져와야해요.',
                      style: TextStyle(
                          color: Colors.grey.shade900,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 4.5, 4.5, 0.0),
              child: Icon(
                diary.favorite ? Icons.favorite : Icons.favorite_border,
                color: diary.favorite ? Colors.red : null,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    print('hello');
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 3,
        // padding: const EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 2.5,
        children: _buildGridCards(context),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
