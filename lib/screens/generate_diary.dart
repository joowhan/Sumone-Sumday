//ai_resultDiary.dart
import 'package:flutter/material.dart';
import 'package:sumday/screens/ai_writeDiary.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:openai_dalle_wrapper/openai_dalle_wrapper.dart';
import 'package:http/http.dart' as http;

const apiKey = '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';
const apiUrl = 'https://api.openai.com/v1/completions';

class GenerateDiary extends StatefulWidget {
  // const GenerateDiary({Key? key}) : super(key: key);
  final List<UserForm> dataList;

  const GenerateDiary({super.key, required this.dataList});
  @override
  State<GenerateDiary> createState() => _GenerateDiaryState();
}

class _GenerateDiaryState extends State<GenerateDiary> {
  String? diaryText;
  String? diaryImageURL;
  @override
  // void initState() {
  //   super.initState();
  //   print('Location: ${widget.data.location}');
  //   print('Relation: ${widget.data.relation}');
  //   print('Activity: ${widget.data.activity}');
  //   print('User State: ${widget.data.userState}');
  // }
  void initState() {
    super.initState();
    generateContent();
  }

  Future<void> generateContent() async {
    String textPrompt =
        '${widget.dataList[0].userState} ${widget.dataList[0].activity} ${widget.dataList[0].relation} ${widget.dataList[0].location}';
    String summaryInEnglish = await generateSummary(textPrompt);

    final openai = OpenaiDalleWrapper(apiKey: apiKey);
    diaryImageURL = await openai
        .generateImage(summaryInEnglish + ", a painting of illustration");

    String translatedText = await translateToKorean(summaryInEnglish);
    diaryText = translatedText;
  }

  Future<String> generateSummary(String prompt) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        "model": "text-davinci-003",
        'prompt': "'$prompt' 를 50자 이내 영어 한 문장으로 요약해줘",
        'max_tokens': 1000,
        'temperature': 0,
        'top_p': 1,
        'frequency_penalty': 0,
        'presence_penalty': 0
      }),
    );

    Map<String, dynamic> newresponse =
        jsonDecode(utf8.decode(response.bodyBytes));
    //print(newresponse['choices'][0]['text'].trim());
    return newresponse['choices'][0]['text'].trim();
  }

  Future<String> translateToKorean(String text) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        "model": "text-davinci-003",
        'prompt': "'$text' 를 50자 이내 한국어 한 문장으로 요약해줘",
        'max_tokens': 1000,
        'temperature': 0,
        'top_p': 1,
        'frequency_penalty': 0,
        'presence_penalty': 0
      }),
    );

    Map<String, dynamic> newresponse =
        jsonDecode(utf8.decode(response.bodyBytes));
    //print(newresponse['choices'][0]['text'].trim());
    return newresponse['choices'][0]['text'].trim();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: generateContent(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        // 데이터 로드가 완료되었다면
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  print('back');
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black38,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      print('save');
                    },
                    icon: const Icon(
                      Icons.done,
                      color: Colors.black38,
                    ))
              ],
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 40.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '6월 6일 오후 4시',
                        style: TextStyle(
                          color: Colors.black38,
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        '#${widget.dataList[0].userState}#${widget.dataList[0].activity}#${widget.dataList[0].relation}#${widget.dataList[0].location}',
                        style: const TextStyle(
                          color: Colors.black38,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: diaryImageURL == null
                            ? const CircularProgressIndicator() // null이면 로딩 표시
                            : Image.network(diaryImageURL!), // null이 아니면 이미지 출력
                      ),
                      const Row(
                        children: [
                          Text(
                            '오늘의 날씨',
                            style: TextStyle(),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.sunny,
                            size: 15.0,
                          )
                        ],
                      ),
                      Container(
                        child: diaryText == null
                            ? const CircularProgressIndicator() // null이면 로딩 표시
                            : Text(
                                diaryText!,
                                style: const TextStyle(),
                              ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.image),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_reaction),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.text_fields),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_border),
                  label: '',
                ),
              ],
              // currentIndex: _selectedIndex,
              // selectedItemColor: Colors.white,
              // backgroundColor: Color(0xffF4C54F),
              // onTap: _onItemTapped,
            ),
          );
        }
        // 아직 로드 중이거나 오류가 발생했다면 로딩 화면을 표시
        else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
