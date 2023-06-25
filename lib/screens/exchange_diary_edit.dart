import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumday/models/exchange_diary_model.dart';
import 'package:sumday/providers/exchange_diary_list_provider.dart';
import 'package:sumday/screens/exchange_diary_detail.dart';
import 'package:sumday/utils/variables.dart';
import 'package:sumday/widgets/appbar.dart';

class ExchangeDiaryEditPage extends StatefulWidget {
  const ExchangeDiaryEditPage(
      {super.key, required this.idx, required this.diary});

  final int idx;
  final ExchangeDiaryModel diary;

  @override
  State<ExchangeDiaryEditPage> createState() => _ExchangeDiaryEditPageState();
}

class _ExchangeDiaryEditPageState extends State<ExchangeDiaryEditPage> {
  final locationController = TextEditingController();
  final contentController = TextEditingController();
  final tagControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationController.text = widget.diary.tags[3];
    contentController.text = widget.diary.content;
    tagControllers[0].text = widget.diary.tags[0];
    tagControllers[1].text = widget.diary.tags[1];
    tagControllers[2].text = widget.diary.tags[2];

    locationController.addListener(() {
      setState(() {
        widget.diary.tags[3] = locationController.text;
      });
    });
    contentController.addListener(() {
      setState(() {
        widget.diary.content = contentController.text;
      });
    });
    tagControllers[0].addListener(() {
      setState(() {
        widget.diary.tags[0] = tagControllers[0].text;
      });
    });
    tagControllers[1].addListener(() {
      setState(() {
        widget.diary.tags[1] = tagControllers[1].text;
      });
    });
    tagControllers[2].addListener(() {
      setState(() {
        widget.diary.tags[2] = tagControllers[2].text;
      });
    });
  }

  @override
  void dispose() {
    locationController.dispose();
    contentController.dispose();
    tagControllers[0].dispose();
    tagControllers[1].dispose();
    tagControllers[2].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diaryListProvider = Provider.of<ExchangeDiaryListProvider>(context);
    final diaryList = diaryListProvider.diaryList;
    final docIds = diaryListProvider.docIds;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        title: "교환일기 작성",
        appBar: AppBar(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColorBackground(),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "일기를 자유롭게 수정해보세요!",
                    style: TextStyle(
                      color: AppColors.fontSecondaryColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              "assets/${widget.diary.photos}",
                              width: 185,
                              height: 185,
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 280,
                                child: TextField(
                                  controller: locationController,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.diary.tags[3] = value;
                                    });
                                  },
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    icon: Icon(
                                      Icons.place,
                                      size: 36,
                                    ),
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.tag,
                                  size: 36, color: Colors.grey),
                              for (int idx in [0, 1, 2])
                                SizedBox(
                                  width: 90,
                                  height: 50,
                                  child: TextField(
                                    controller: tagControllers[idx],
                                    onChanged: (value) {
                                      setState(() {
                                        widget.diary.tags[idx] = value;
                                      });
                                    },
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(2.0),
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.all(4.0),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                          const Column(
                            children: [],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 330,
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                          onChanged: (value) {
                            setState(() {
                              widget.diary.content = value;
                            });
                          },
                          minLines: 1,
                          maxLines: 30,
                          controller: contentController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, isCollapsed: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: AppColors.primaryColor(),
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10)),
                        onPressed: () {
                          final tags = [
                            tagControllers[0].text,
                            tagControllers[1].text,
                            tagControllers[2].text,
                            locationController.text
                          ];
                          final diary = ExchangeDiaryModel(
                              owner: widget.diary.owner,
                              diaryId: widget.diary.diaryId,
                              content: contentController.text,
                              photos: widget.diary.photos,
                              tags: tags,
                              comments: [],
                              createdAt: Timestamp.now());
                          Provider.of<ExchangeDiaryListProvider>(context,
                                  listen: false)
                              .addDiary(diary, docIds[widget.idx]);
                          var order = diaryList[widget.idx].order;
                          var nextOrder = (order + 1) %
                              diaryList[widget.idx].participants.length;
                          Provider.of<ExchangeDiaryListProvider>(context,
                                  listen: false)
                              .setOrder(docIds[widget.idx], nextOrder);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExchangeDiaryDetail(
                                        idx: widget.idx,
                                        diaryId: widget.diary.diaryId,
                                        content: widget.diary.content,
                                        photo: widget.diary.photos,
                                        location: widget.diary.tags[3],
                                        tags: widget.diary.tags.sublist(0, 3),
                                        date: widget.diary.createdAt.toDate(),
                                        comments: const [],
                                        writer: widget.diary.owner,
                                      )));
                        },
                        child: const Text("작성"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
