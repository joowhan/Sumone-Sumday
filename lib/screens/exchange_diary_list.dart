import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/loginProvider.dart';
import 'package:sumday/utils/variables.dart';

class ExchangeDiaryList extends StatefulWidget {
  const ExchangeDiaryList({super.key});

  @override
  State<ExchangeDiaryList> createState() => _ExchangeDiaryListState();
}

class _ExchangeDiaryListState extends State<ExchangeDiaryList> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<LoginProvider>(context);
    final user = userData.userInformation;
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user?.name ?? "누렁이",
                            style: TextStyle(
                              fontSize: 36,
                              color: AppColors.fontSecondaryColor(),
                            ),
                          ),
                          const Text(
                            "님의",
                            style: TextStyle(fontSize: 36),
                          ),
                        ],
                      ),
                      const Text(
                        "교환일기장",
                        style: TextStyle(
                          fontSize: 36,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.add_box_outlined,
                  size: 80,
                  color: AppColors.fontSecondaryColor(),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/exchangeDiary');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "KT Aivle School 3기!",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      const Text("4명 참여중"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${user?.name ?? "누렁이"} 작성중",
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor(),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/images/test/test_image_000.jpg'),
                                      width: 40,
                                      height: 40,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/images/test/test_image_001.jpg'),
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/images/test/test_image_002.jpg'),
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
