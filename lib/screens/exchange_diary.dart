import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumday/models/exchange_diary_list_model.dart';
import 'package:sumday/models/exchange_diary_model.dart';
import 'package:sumday/models/rdiary_model.dart';
import 'package:sumday/providers/diaries_provider.dart';
import 'package:sumday/providers/exchange_diary_list_provider.dart';
import 'package:sumday/providers/loginProvider.dart';
import 'package:sumday/screens/exchange_diary_edit.dart';
import 'package:sumday/screens/exchange_diary_setting.dart';
import 'package:sumday/utils/variables.dart';
import 'package:sumday/widgets/appbar.dart';
import 'package:sumday/widgets/exchange_diary_card.dart';
import 'package:sumday/widgets/exchange_diary_modal.dart';

class ExchangeDiary extends StatefulWidget {
  final int idx;
  const ExchangeDiary({super.key, required this.idx});

  @override
  State<ExchangeDiary> createState() => _ExchangeDiaryState();
}

class _ExchangeDiaryState extends State<ExchangeDiary> {
  var current = 0;
  void setCurrent(int index) {
    setState(() {
      current = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<LoginProvider>(context);
    final diaryListProvider = Provider.of<ExchangeDiaryListProvider>(context);
    final diariesProvider = Provider.of<DiariesProvider>(context);
    final user = userData.userInformation;
    final diaryList = diaryListProvider.diaryList;
    final docIds = diaryListProvider.docIds;
    final diaries = diariesProvider.diaries;
    final diariesDocIds = diariesProvider.docNames;
    final todayIdx = diaries.indexWhere((element) =>
        element.date.millisecondsSinceEpoch >
            DateTime.now()
                .subtract(const Duration(days: 1))
                .millisecondsSinceEpoch &&
        element.date.millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch);
    late String? todayDiaryId;
    if (todayIdx == -1) {
      todayDiaryId = null;
    } else {
      todayDiaryId = diariesDocIds[todayIdx];
    }

    // 일기 목록 렌더링하는 코드 (ListView)
    final items =
        List.generate(diaryList[widget.idx].diaryList.length, (index) {
      return ExchangeDiaryCard(
        idx: index,
        diaryId: docIds[widget.idx],
        tags: diaryList[widget.idx].diaryList[index]["tags"].sublist(1, 4),
        location: diaryList[widget.idx].diaryList[index]["tags"][0],
        content: diaryList[widget.idx].diaryList[index]["content"],
        date: diaryList[widget.idx].diaryList[index]["createdAt"].toDate(),
        writer: diaryList[widget.idx].diaryList[index]["owner"],
        photo: diaryList[widget.idx].diaryList[index]["photos"],
        comments: diaryList[widget.idx].diaryList[index]["comments"],
      );
    });
    late Diary? todayDiaries;
    // 오늘 작성한 일기를 불러오는 코드
    if (todayDiaryId == null) {
      todayDiaries = null;
    } else {
      var index =
          diariesDocIds.indexWhere((element) => element == todayDiaryId);
      todayDiaries = diaries[index];
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        title: "교환일기",
        appBar: AppBar(),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.exchangeBackGroudColor(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    diaryList[widget.idx].title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ExchangeDiarySetting(idx: widget.idx)));
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.fontGreyColor(),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (diaryList[widget.idx]
                                .participants[diaryList[widget.idx].order] !=
                            user!.uid) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${diaryList[widget.idx].participants[diaryList[widget.idx].order].toString().substring(0, 5)}님",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "작성중!",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Icon(
                                Icons.edit,
                                color: AppColors.fontSecondaryColor(),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "본인차례가 되면 작성할 수 있어요!",
                                style: TextStyle(
                                  color: AppColors.fontDarkGreyColor(),
                                ),
                              ),
                              Text(
                                "눈치주기",
                                style: TextStyle(
                                    color: AppColors.fontSecondaryColor()),
                              ),
                            ],
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "일기를 작성해보세요!",
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (todayDiaries != null) {
                                          showSelectDiaryModal(
                                              context,
                                              todayDiaries,
                                              todayDiaryId,
                                              docIds,
                                              diaryList);
                                        } else {
                                          // todo 일기 생성하는 페이지로 이동시키기
                                          showCreateDiaryModal(context);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.add_box_outlined,
                                        size: 50,
                                        color: AppColors.fontSecondaryColor(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return items[index];
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showCreateDiaryModal(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "아직 오늘 일기를 작성하지 않으셨어요.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "먼저 오늘의 일기를 작성해주세요!",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "작성하러 가기",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ))
              ],
            ),
          );
        });
  }

  Future<dynamic> showSelectDiaryModal(
      BuildContext context,
      Diary? todayDiaries,
      String? todayDiaryId,
      List<String> docIds,
      List<ExchangeDiaryListModel> diaryList) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "취소",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                TextButton(
                  onPressed: () {
                    final diary = ExchangeDiaryModel(
                      owner: todayDiaries!.userID,
                      diaryId: todayDiaryId!,
                      content: todayDiaries.context[current],
                      photos: todayDiaries.photos[current],
                      tags: todayDiaries.getCurrTags(current),
                      comments: [],
                      createdAt: Timestamp.now(),
                    );
                    Provider.of<ExchangeDiaryListProvider>(context,
                            listen: false)
                        .addDiary(diary, docIds[widget.idx]);
                    var order = diaryList[widget.idx].order;
                    var nextOrder =
                        (order + 1) % diaryList[widget.idx].participants.length;
                    Provider.of<ExchangeDiaryListProvider>(context,
                            listen: false)
                        .setOrder(docIds[widget.idx], nextOrder);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExchangeDiaryEditPage(
                          idx: widget.idx,
                          diary: diary,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "작성",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
            ExchangeDiaryModal(
              diaries: todayDiaries!,
              setCurrent: setCurrent,
            ),
          ],
        );
      },
    );
  }
}
