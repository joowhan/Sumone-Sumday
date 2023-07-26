import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/diaries_provider.dart';
import 'package:sumday/models/rdiary_model.dart';
import 'package:sumday/widgets/diary_card.dart';

class Diaries extends StatefulWidget {
  const Diaries({Key? key}) : super(key: key);

  @override
  State<Diaries> createState() => _DiariesState();
}

class _DiariesState extends State<Diaries> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DiariesProvider>(
      builder: (context, diariesProvider, _) {
        List<Diary> diaries = diariesProvider.diaries;
        List<String> docNames = diariesProvider.docNames;

        return ListView.builder(
          itemCount: diaries.length,
          itemBuilder: (context, index) {
            final diary = diaries[index];
            final docName = docNames[index];

            void favoriteClickHandler() {
              diariesProvider.toggleFavorite(index);
            }

            return Dismissible(
              key: UniqueKey() /* Key(docName) */,
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                diariesProvider.removeDiary(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${index + 1}번 일기 삭제됨'),
                    action: SnackBarAction(
                      label: '취소',
                      onPressed: () {
                        diariesProvider.addDiary(index, diary, docName);
                      },
                    ),
                  ),
                );
              },
              background: Container(
                alignment: Alignment.centerRight,
                color: Colors.red,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              child: DiaryCard(
                diary: diary,
                favoriteClickHandler: favoriteClickHandler,
              ),
            );
          },
        );
      },
    );
  }
}
