import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/exchange_diary_list_provider.dart';
import 'package:sumday/providers/loginProvider.dart';
import 'package:sumday/utils/variables.dart';
import 'package:sumday/widgets/create_exchange_diary_list.dart';
import 'package:sumday/widgets/exchange_list_card.dart';

class ExchangeDiaryList extends StatefulWidget {
  const ExchangeDiaryList({super.key});

  @override
  State<ExchangeDiaryList> createState() => _ExchangeDiaryListState();
}

class _ExchangeDiaryListState extends State<ExchangeDiaryList> {
  // var isInit = true;

  // @override
  // void didChangeDependencies() {
  //   if (isInit) {
  //     Provider.of<ExchangeDiaryListProvider>(context).fetchDiaryList();
  //     Provider.of<DiariesProvider>(context).loadAllDiaries();
  //   }
  //   isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<LoginProvider>(context);
    final user = userData.userInformation;
    final diaryList = Provider.of<ExchangeDiaryListProvider>(context);
    final diaries = diaryList.diaryList;
    final docIds = diaryList.docIds;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SingleChildScrollView(
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
                            user?.name ?? "로딩중...",
                            style: TextStyle(
                              fontSize: 28,
                              color: AppColors.fontSecondaryColor(),
                            ),
                          ),
                          const Text(
                            "님의",
                            style: TextStyle(fontSize: 28),
                          ),
                        ],
                      ),
                      const Text(
                        "교환일기장",
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                createExchangeDiaryList(context, user),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, setNewState) {
                        final codeController = TextEditingController();
                        return AlertDialog(
                          content: Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: TextField(
                                  controller: codeController,
                                  decoration: const InputDecoration(
                                    hintText: "초대코드를 입력해주세요",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    isCollapsed: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 10,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    String inviteCode =
                                        codeController.text.trim();
                                    if (inviteCode.isNotEmpty) {
                                      Provider.of<ExchangeDiaryListProvider>(
                                              context,
                                              listen: false)
                                          .addParticipants(
                                              inviteCode, user!.uid);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: const Text("완료"))
                            ],
                          ),
                        );
                      });
                    });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "초대코드 입력하기",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.add),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            for (int i = 0; i < diaries.length; i++)
              Column(
                children: [
                  ExchangeListCard(
                    idx: i,
                    id: docIds[i],
                    user: user,
                    color: HexColor("#${diaries[i].hexColor}"),
                    title: diaries[i].title,
                    numberOfPeople: diaries[i].participants.length,
                    currentWriter: diaries[i].participants[diaries[i].order],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
