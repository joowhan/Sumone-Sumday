import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sumday/models/exchange_diary_list_model.dart';
import 'package:sumday/providers/exchange_diary_list_provider.dart';
import 'package:sumday/providers/loginProvider.dart';
import 'package:sumday/utils/variables.dart';

IconButton createExchangeDiaryList(
    BuildContext context, UserInformation? user) {
  return IconButton(
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
              Color currentColor = Colors.blue;

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
                          color: currentColor,
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
                                currentColor = color;
                              });
                            },
                          ),
                          OutlinedButton(
                            onPressed: () {
                              String title = titleController.text.trim();
                              if (title.isNotEmpty) {
                                Provider.of<ExchangeDiaryListProvider>(context,
                                        listen: false)
                                    .addDiaryList(ExchangeDiaryListModel(
                                        title: title,
                                        owner: user!.uid,
                                        participants: [user.uid],
                                        diaryList: [],
                                        hexColor: ColorToHex(currentColor).hex,
                                        order: 0,
                                        createdAt: Timestamp.now()));
                              }
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  titleController.text.trim().isNotEmpty
                                      ? AppColors.primaryColor()
                                      : AppColors.backgroundGreyColor()),
                            ),
                            child: Text(
                              "생성",
                              style: TextStyle(
                                  color:
                                      (titleController.text.trim().isNotEmpty)
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
  );
}
