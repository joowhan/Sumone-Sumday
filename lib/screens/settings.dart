import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/loginProvider.dart';
import 'package:sumday/widgets/setting_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<LoginProvider>(context);
    final user = userData.userInformation;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffFBE8B8),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                children: [
                  SettingContainerText(
                    title: "닉네임",
                    information: user?.name ?? "누렁이",
                  ),
                  const SettingContainerColor(
                    title: "테마색상 변경",
                    color: Color(0xffFADDDC),
                  ),
                  const SettingContainerText(
                    title: "폰트 변경",
                    information: "Noto Sans KR",
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: const Column(
                children: [
                  SettingContainerText(
                    title: "금지 장소",
                  ),
                  SettingContainerText(
                    title: "주제 개수",
                    information: "3",
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: const Column(
                children: [
                  SettingContainerText(
                    title: "백업",
                  ),
                  SettingContainerText(
                    title: "회원 탈퇴",
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: const Column(
                children: [
                  SettingContainerText(
                    title: "이용약관",
                  ),
                  SettingContainerText(
                    title: "문의하기",
                  ),
                  SettingContainerText(
                    title: "개인정보 관리",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
