import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sumday/models/exchange_diary_list_model.dart';
import 'package:sumday/providers/exchange_diary_list_provider.dart';
import 'package:sumday/providers/loginProvider.dart';
import 'package:sumday/utils/variables.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:sumday/widgets/exchange_list_card.dart';

class ExchangeDiaryList extends StatefulWidget {
  const ExchangeDiaryList({super.key});

  @override
  State<ExchangeDiaryList> createState() => _ExchangeDiaryListState();
}

class _ExchangeDiaryListState extends State<ExchangeDiaryList> {
  Color _currentColor = Colors.blue;

  void changeColor(Color color) {
    setState(() {
      _currentColor = color;
    });
  }

  var isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<ExchangeDiaryListProvider>(context).fetchDiaryList();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<LoginProvider>(context);
    final user = userData.userInformation;
    final diaryList = Provider.of<ExchangeDiaryListProvider>(context);
    final diaries = diaryList.diaryList;
    final docIds = diaryList.docIds;

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
                IconButton(
                  iconSize: 80,
                  icon: Icon(
                    Icons.add_box_outlined,
                    size: 80,
                    color: AppColors.fontSecondaryColor(),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (
                        BuildContext context,
                      ) {
                        final titleController = TextEditingController();
                        return StatefulBuilder(
                          builder: (context, setNewState) {
                            return SingleChildScrollView(
                              child: AlertDialog(
                                content: Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.chevron_left),
                                        ),
                                        const Text("교환일기장 만들기"),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: _currentColor,
                                      ),
                                      child: TextField(
                                        controller: titleController,
                                        onChanged: (value) {
                                          setNewState(() {});
                                        },
                                        decoration: const InputDecoration(
                                          hintText: "제목을 입력해주세요",
                                          hintStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          isCollapsed: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: 30,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        ColorPicker(
                                          width: 35,
                                          height: 35,
                                          borderRadius: 5,
                                          spacing: 8,
                                          runSpacing: 8,
                                          columnSpacing: 24,
                                          color: Colors.white,
                                          enableShadesSelection: false,
                                          selectedColorIcon: Icons.check,
                                          onColorChanged: (Color color) {
                                            setNewState(() {
                                              _currentColor = color;
                                            });
                                          },
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            String title =
                                                titleController.text.trim();
                                            if (title.isNotEmpty) {
                                              Provider.of<ExchangeDiaryListProvider>(
                                                      context,
                                                      listen: false)
                                                  .addDiaryList(
                                                      ExchangeDiaryListModel(
                                                          title: title,
                                                          owner: user!.uid,
                                                          participants: [
                                                            user.uid
                                                          ],
                                                          diaryList: [],
                                                          hexColor: ColorToHex(
                                                                  _currentColor)
                                                              .hex,
                                                          order: 0,
                                                          createdAt:
                                                              Timestamp.now()));
                                            }
                                            Navigator.pop(context);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(titleController.text
                                                        .trim()
                                                        .isNotEmpty
                                                    ? AppColors.primaryColor()
                                                    : AppColors
                                                        .backgroundGreyColor()),
                                          ),
                                          child: Text(
                                            "생성",
                                            style: TextStyle(
                                                color: (titleController.text
                                                        .trim()
                                                        .isNotEmpty)
                                                    ? Colors.black
                                                    : Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 50,
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
