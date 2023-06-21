import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/diaries_provider.dart';
import 'package:sumday/models/diary_model.dart';
import 'package:sumday/widgets/diary_card.dart';

class Diaries extends StatelessWidget {
  const Diaries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DiariesProvider>(
      builder: (context, diariesProvider, _) {
        List<Diary> diaries = diariesProvider.diaries;

        return ListView.builder(
          itemCount: diaries.length,
          itemBuilder: (context, index) {
            final diary = diaries[index];

            void favoriteClickHandler() {
              diariesProvider.toggleFavorite(diary);
            }

            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                diariesProvider.removeDiary(diary, index);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$diary 삭제됨'),
                    action: SnackBarAction(
                      label: '취소',
                      onPressed: () {
                        diariesProvider.addDiary(diary, index);
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
