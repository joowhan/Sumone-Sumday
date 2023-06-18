import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/loginProvider.dart';
import 'package:sumday/utils/variables.dart';
import 'package:sumday/widgets/appbar.dart';

class ExchangeDiary extends StatefulWidget {
  const ExchangeDiary({super.key});

  @override
  State<ExchangeDiary> createState() => _ExchangeDiaryState();
}

class _ExchangeDiaryState extends State<ExchangeDiary> {
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
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGreyColor(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const Image(
                            image: AssetImage(
                                'assets/images/test/test_image_000.jpg'),
                            width: double.maxFinite,
                            height: 185,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // 추후에 리스트로 하나하나 불러와야 할 듯
                        const Row(
                          children: [
                            Text(
                              "#서울숲",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "#산책",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "#해피",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "2023년 5월 2일 (화)",
                              style: TextStyle(
                                color: AppColors.fontGreyColor(),
                              ),
                            ),
                            Text(
                              "by. 이주현",
                              style: TextStyle(
                                  color: AppColors.fontSecondaryColor()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGreyColor(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const Image(
                            image: AssetImage(
                                'assets/images/test/test_image_001.jpg'),
                            width: double.maxFinite,
                            height: 185,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.center,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // 추후에 리스트로 하나하나 불러와야 할 듯
                        const Row(
                          children: [
                            Text(
                              "#스타벅스",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "#커피",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "#맑음",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "2023년 5월 2일 (화)",
                              style: TextStyle(
                                color: AppColors.fontGreyColor(),
                              ),
                            ),
                            Text(
                              "by. 강승진",
                              style: TextStyle(
                                  color: AppColors.fontSecondaryColor()),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
