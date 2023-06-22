import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/exchange_diary_list_provider.dart';
import 'package:sumday/providers/loginProvider.dart';
import 'package:sumday/screens/exchange_diary_setting.dart';
import 'package:sumday/utils/variables.dart';
import 'package:sumday/widgets/appbar.dart';
import 'package:sumday/widgets/exchange_diary_card.dart';

class ExchangeDiary extends StatefulWidget {
  final int idx;
  const ExchangeDiary({super.key, required this.idx});

  @override
  State<ExchangeDiary> createState() => _ExchangeDiaryState();
}

class _ExchangeDiaryState extends State<ExchangeDiary> {
  // 일기장 제목 등은 프로바이더에서 받아온다고 생각하고 일단은 하드코딩 함
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<LoginProvider>(context);
    final user = userData.userInformation;
    final diaryListProvider = Provider.of<ExchangeDiaryListProvider>(context);
    final diaryList = diaryListProvider.diaryList;
    final docIds = diaryListProvider.docIds;
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
        child: SingleChildScrollView(
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
                    child: Column(
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
                                horizontal: 25, vertical: 10),
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
                                      onPressed: () {},
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
                          )
                        ]
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Row(
                //   children: [
                // 어떻게 구현해야 할 지 몰라 일단 주석처리 합니다.
                // Text(
                //   "2023.05",
                //   style: TextStyle(
                //     color: AppColors.fontGreyColor(),
                //   ),
                // ),
                // const SizedBox(
                //   width: 10,
                // ),
                // Flexible(
                //   child: Container(
                //     height: 2,
                //     color: AppColors.fontGreyColor(),
                //   ),
                // ),
                // ],
                // ),
                for (int i = 0; i < diaryList[widget.idx].diaryList.length; i++)
                  ExchangeDiaryCard(
                    idx: i,
                    diaryId: docIds[widget.idx][i],
                    tags: diaryList[widget.idx].diaryList[i].hashTags,
                    date: diaryList[widget.idx].diaryList[i].createdAt,
                    writer: diaryList[widget.idx].diaryList[i].owner,
                    thumbSource: diaryList[widget.idx].diaryList[i].imageUrl,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
