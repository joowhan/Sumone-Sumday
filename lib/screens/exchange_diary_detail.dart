import 'package:flutter/material.dart';
import 'package:sumday/utils/variables.dart';
import 'package:sumday/widgets/appbar.dart';

class ExchangeDiaryDetail extends StatelessWidget {
  final int idx;
  final String diaryId;
  final String content;
  final List<dynamic> comments;
  final List<dynamic> tags;
  final String location;
  final DateTime date;
  final String writer;
  final String photo;
  const ExchangeDiaryDetail({
    super.key,
    required this.idx,
    required this.diaryId,
    required this.content,
    required this.comments,
    required this.tags,
    required this.location,
    required this.date,
    required this.writer,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    const weekDayName = ["일", "월", "화", "수", "목", "금", "토"];
    final dateString =
        "${date.year}년 ${date.month}월 ${date.day}일 (${weekDayName[date.weekday]})";

    return Scaffold(
      appBar: MyAppBar(
        title: "${writer.substring(0, 5)}님의 일기",
        appBar: AppBar(),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.exchangeBackGroudColor(),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.backgroundGreyColor(),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.place_outlined,
                                  size: 32,
                                ),
                                Text(
                                  location,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: Image.asset(
                            "assets/$photo",
                            width: double.maxFinite,
                            height: 185,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          // 향후 스타일 추가하겠음
                          children: [
                            for (String tag in tags)
                              Text(
                                "#$tag  ",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dateString,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.fontDarkGreyColor(),
                              ),
                            ),
                            Text(
                              "by. ${writer.substring(0, 5)}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.fontSecondaryColor()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.backgroundGreyColor(),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    child: Text(content),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // 댓글 섹션
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.backgroundGreyColor(),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              // 댓글 쓴 사람 정보
                              children: [
                                const CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/test/test_image_000.jpg'),
                                  radius: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "강승진",
                                      style: TextStyle(
                                        color: AppColors.fontSecondaryColor(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      "잘됐다!",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 50,
                                ),
                                Text(
                                  "2021.09.01",
                                  style: TextStyle(
                                    color: AppColors.fontGreyColor(),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 250,
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send,
                        color: AppColors.fontGreyColor(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
