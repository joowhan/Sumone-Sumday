import 'package:sumday/models/rdiary_model.dart';
import 'package:sumday/providers/diaries_provider.dart';
import 'package:sumday/screens/ai_writeDiary.dart';
import 'package:sumday/widgets/DiarySlider.dart';
import 'package:sumday/widgets/ExpandablePageView.dart';
import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/generate_provider.dart';
import 'package:intl/intl.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

const apiKey = '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';
const apiUrl = 'https://api.openai.com/v1/completions';

class GenerateDiary extends StatefulWidget {
  final List<UserForm> dataList;
  int currPage = 1;

  const GenerateDiary({super.key, required this.dataList});

  @override
  State<GenerateDiary> createState() => _GenerateDiaryState();
}

class _GenerateDiaryState extends State<GenerateDiary> {
  @override
  void initState() {
    super.initState();

    final generateProvider =
        Provider.of<GenerateProvider>(context, listen: false);
    final diariesProvider =
        Provider.of<DiariesProvider>(context, listen: false);
    generateProvider.init(widget.dataList, diariesProvider.numOfDiaries);
    for (var i = 0; i < widget.dataList.length; i++) {
      generateProvider.generateContents(i);
    }
    print('init');
  }

  void pageHandler(int page) {
    setState(() {
      widget.currPage = page;
    });
  }

  String getTimeString() {
    final now = DateTime.now();
    final formatter = DateFormat('MMdd_hh(a)');
    final formatted = formatter.format(now);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    var _pages = List.generate(
        widget.dataList.length, (index) => DiaryContents(index: index));

    print(_pages);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xfffffdf8),
        appBar: AppBar(
          leading: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color(0xff475468),
                size: 16,
              ),
              onPressed: () {
                Navigator.pop(context);
                print('back button click');
                // Navigator.pop(context);
              },
            ),
          ),
          leadingWidth: 40,
          title: Text(
            getTimeString(),
            style: TextStyle(
              fontSize: 32,
              color: Color(0xff363636),
            ),
          ),
          shadowColor: Color(0xffffffff),
          elevation: .6,
          toolbarHeight: 68,
          backgroundColor: Colors.white,
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 1000),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: DiarySlider(maxRange: 3),
                ),
                Indexer(
                  alignment: Alignment.topCenter,
                  children: [
                    Indexed(
                      index: 2,
                      child: Container(
                        width: 104,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Color(0xfff4c758),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '1 / 3',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, 22),
                      child: Indexed(
                        index: 1,
                        child: ExpandablePageView(children: _pages),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiaryContents extends StatefulWidget {
  final int index;

  const DiaryContents({super.key, required this.index});

  @override
  State<DiaryContents> createState() => _DiaryContentsState();
}

class _DiaryContentsState extends State<DiaryContents> {
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GenerateProvider>(
      builder: (context, generateProvider, _) {
        return Consumer<DiariesProvider>(
          builder: (context, diariesProvider, _) {
            return Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: generateProvider.isGenComplete(widget.index)
                      ? Image.network(
                          generateProvider.getImageUrl(widget.index))
                      : CircularProgressIndicator(),
                ),
                Transform.translate(
                  offset: Offset(0, -14),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    size: 48, weight: 1),
                                Text(
                                  generateProvider
                                      .getUserData(widget.index)
                                      .getLocation(),
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xfff4c758),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22))),
                              onPressed: () {
                                if (diariesProvider.diaries.length !=
                                    generateProvider.getDiaryIndex) {}
                              },
                              child: Text(
                                '저장',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: Color(0xffc4c4c4), width: .6)),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  generateProvider
                                      .getUserData(widget.index)
                                      .getHashTags(),
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xff888888)),
                                ),
                                if (generateProvider.isTextGen![widget.index])
                                  Text(
                                    generateProvider.getKoSummary(widget.index),
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.black),
                                  ),
                                if (!generateProvider.isTextGen![widget.index])
                                  Text(
                                    '로딩중~',
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.grey.shade600),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
              ],
            );
          },
        );
      },
    );
  }
}
