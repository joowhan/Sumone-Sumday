import 'package:flutter/material.dart';
import 'package:sumday/utils/variables.dart';
import 'package:sumday/widgets/appbar.dart';

class ExchangeDiaryDetail extends StatefulWidget {
  const ExchangeDiaryDetail({super.key});

  @override
  State<ExchangeDiaryDetail> createState() => _ExchangeDiaryDetailState();
}

class _ExchangeDiaryDetailState extends State<ExchangeDiaryDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "일기 제목",
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
                            const Row(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  size: 32,
                                ),
                                Text(
                                  "비안빈",
                                  style: TextStyle(
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
                        const ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image(
                            image: AssetImage(
                                'assets/images/test/test_image_001.jpg'),
                            width: double.maxFinite,
                            height: 185,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          // 향후 스타일 추가하겠음
                          children: [
                            Text("#스타벅스"),
                            Text("#커피"),
                            Text("#아메리카노"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "2021.09.01 (화)",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.fontDarkGreyColor(),
                              ),
                            ),
                            Text(
                              "by. 이주현",
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    child: Text("오늘 스타벅스에서 미팅을 했당 ㅋ.ㅋ 오늘 날씨는 맑았고 어쩌구 저쩌구"),
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
