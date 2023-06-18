import 'package:flutter/material.dart';
import 'package:sumday/utils/variables.dart';
import 'package:sumday/widgets/appbar.dart';
import 'package:sumday/widgets/setting_widget.dart';

class ExchangeDiarySetting extends StatefulWidget {
  const ExchangeDiarySetting({super.key});

  @override
  State<ExchangeDiarySetting> createState() => _ExchangeDiarySettingState();
}

class _ExchangeDiarySettingState extends State<ExchangeDiarySetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "교환일기장 설정", appBar: AppBar()),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: AppColors.primaryColorBackground()),
          child: Column(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const Text(
                    "친구와 함께 작성해보세요!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Image(
                    image: AssetImage(
                      "assets/small_logo.png",
                    ),
                    width: 320,
                  ),
                  const Text(
                    "39Tx83hsW",
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: AppColors.primaryColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(200, 50)),
                    child: const Text("초대코드 복사하기"),
                  ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: const Column(
                  children: [
                    SettingContainerText(title: "멤버 관리"),
                    SettingContainerText(title: "일기장 관리"),
                    SettingContainerText(title: "일기장 나가기"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
