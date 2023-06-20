import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                                        TextButton(
                                          onPressed: () {
                                            String title =
                                                titleController.text.trim();
                                            if (title.isNotEmpty) {
                                              Navigator.pop(context);
                                            }
                                          },
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
                                          onPressed: () {},
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              AppColors.primaryColor(),
                                            ),
                                          ),
                                          child: Text(
                                            "생성",
                                            style: TextStyle(
                                              color: AppColors
                                                  .fontSecondaryColor(),
                                            ),
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
            ExchangeListCard(
              id: "iYG4AVt6EzzmKEzXsiji",
              user: user,
              color: Colors.red,
              title: "KT Aivle School 3기!",
              numberOfPeople: 4,
              currentWriter: user!.name,
            ),
          ],
        ),
      ),
    );
  }
}
