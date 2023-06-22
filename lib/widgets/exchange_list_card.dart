import 'package:flutter/material.dart';
import 'package:sumday/providers/loginProvider.dart';
import 'package:sumday/screens/exchange_diary.dart';
import 'package:sumday/utils/variables.dart';

class ExchangeListCard extends StatelessWidget {
  final int idx;
  final String id;
  final String title;
  final int numberOfPeople;
  final String currentWriter;
  final Color color;
  final String? thumbSource1;
  final String? thumbSource2;
  final String? thumbSource3;

  const ExchangeListCard({
    super.key,
    required this.idx,
    required this.id,
    required this.user,
    required this.title,
    required this.numberOfPeople,
    required this.currentWriter,
    required this.color,
    this.thumbSource1,
    this.thumbSource2,
    this.thumbSource3,
  });

  final UserInformation? user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExchangeDiary(idx: idx),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              Text(
                "$numberOfPeople명 참여중",
                style: const TextStyle(color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${user?.name ?? "누렁이"} 작성중",
                    style: const TextStyle(color: Colors.white),
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
                                color: color,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          thumbSource1?.isNotEmpty ?? false
                              ? SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: const Image(
                                    image: AssetImage(
                                        'assets/images/test/test_image_000.jpg'),
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          thumbSource2?.isNotEmpty ?? false
                              ? SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                  ),
                                )
                              : ClipRRect(
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
                          thumbSource3?.isNotEmpty ?? false
                              ? SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor(),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                  ),
                                )
                              : ClipRRect(
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
    );
  }
}
