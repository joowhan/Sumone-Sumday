import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/loginProvider.dart';
import 'package:sumday/utils/variables.dart';
import 'package:sumday/widgets/appbar.dart';
import 'package:sumday/widgets/exchange_diary_card.dart';

class ExchangeDiary extends StatefulWidget {
  final String id;
  const ExchangeDiary({super.key, required this.id});

  @override
  State<ExchangeDiary> createState() => _ExchangeDiaryState();
}

class _ExchangeDiaryState extends State<ExchangeDiary> {
  // 일기장 제목 등은 프로바이더에서 받아온다고 생각하고 일단은 하드코딩 함
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<LoginProvider>(context);
    final user = userData.userInformation;
    return Scaffold(
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
                    const Text(
                      "KT Aivle School 3기!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/exchangeDiary/setting');
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
                    color: AppColors.primaryColorLighter(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${user?.name ?? "누렁이"}님",
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "2023.05",
                      style: TextStyle(
                        color: AppColors.fontGreyColor(),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Container(
                        height: 2,
                        color: AppColors.fontGreyColor(),
                      ),
                    ),
                  ],
                ),
                ExchangeDiaryCard(
                  diaryId: "pzc1lokeYTPlwi5ukp40",
                  tags: const ["서울숲", "산책", "해피"],
                  date: DateTime.now(),
                  writer: "이주현",
                  thumbSource: "이게 무슨값이 될지 모르겠네요",
                ),
                ExchangeDiaryCard(
                    diaryId: "hello",
                    tags: const ["스타벅스", "커피", "맑음"],
                    date: DateTime.utc(2023, 6, 15),
                    writer: "강승진",
                    thumbSource: "솰라솰라")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
