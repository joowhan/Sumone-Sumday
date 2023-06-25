//ai_resultDiary.dart
import 'package:flutter/material.dart';
import 'package:sumday/screens/ai_writeDiary.dart';
import 'dart:convert';
import 'package:openai_dalle_wrapper/openai_dalle_wrapper.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

const apiKey = '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';
const apiUrl = 'https://api.openai.com/v1/completions';

final FirebaseAuth _auth = FirebaseAuth.instance;

// 이곳에서 로그인된 사용자의 uid를 가져옵니다.
final User? user = _auth.currentUser;
final uid = user?.uid;

class GenerateDiary extends StatefulWidget {
  // const GenerateDiary({Key? key}) : super(key: key);
  final List<UserForm> dataList;

  const GenerateDiary({super.key, required this.dataList});
  @override
  State<GenerateDiary> createState() => _GenerateDiaryState();
}

class _GenerateDiaryState extends State<GenerateDiary> {
  List<String> diaryTexts = [];
  List<String> diaryImageURLs = [];
  String? diaryImageURL;
  String? imageUuid; // 클래스 레벨에서 imageUuid 선언

  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    // 페이지 컨트롤러 초기화
    _pageController = PageController();
  }

  @override
  void dispose() {
    // 페이지 컨트롤러 제거
    _pageController.dispose();
    super.dispose();
  }

// void printContents() {
//   diaryTexts.forEach((text) {
//     print(text);
//   });

//   diaryImageURLs.forEach((url) {
//     print(url);
//   });
// }
  Future<void> generateAllContents() async {
    diaryImageURLs.clear();
    diaryTexts.clear();
    await Future.forEach(widget.dataList, (UserForm data) async {
      String textPrompt =
          '${data.userState} ${data.activity} ${data.relation} ${data.location}';
      print(textPrompt);
      String summaryInEnglish = await generateSummary(textPrompt);

      final openai = OpenaiDalleWrapper(apiKey: apiKey);
      String diaryImageURL = await openai
          .generateImage(summaryInEnglish + ", a painting of illustration");
      diaryImageURLs.add(diaryImageURL); // 생성된 이미지 URL을 리스트에 추가

      String diaryText = await translateToKorean(summaryInEnglish);
      diaryTexts.add(diaryText); // 생성된 일기 내용을 리스트에 추가
    });
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
        'prompt': "Please make it into one sentence in English : " '$prompt',
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
        'prompt': "Please write it in a Korean diary format : '$text' ",
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

  // Future<void> saveImageToFirebaseStorage(
  //     String? imageUrl, String? uid, String? uuid) async {
  //   final response = await http.get(Uri.parse(imageUrl!));
  //   final Uint8List imageBytes = response.bodyBytes;

  //   final imageRef =
  //   FirebaseStorage.instance.ref().child('/images/$uid/$uuid.png');
  //   await imageRef.putData(imageBytes);
  // }

  String generateUuid() {
    var uuid = Uuid();
    return uuid.v1();
  }

  Future<void> save_local(String url) async {
    var response = await http.get(Uri.parse(url));
    final Uint8List bytes = response.bodyBytes;

    Directory dir = await getApplicationDocumentsDirectory();
    String fileName = generateUuid();
    String filePath = '${dir.path}/$fileName.png';

    File file = File(filePath);
    await file.writeAsBytes(bytes);
    print('이미지 저장 경로: $filePath');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: generateAllContents(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        // 데이터 로드가 완료되었다면
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                DateFormat('MMdd_hha').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 32,
                  color: Color(0xff363636),
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  print('back');
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black38,
                ),
              ),
              
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 40.0),
              child: PageView.builder(
                controller: _pageController,
                itemCount: diaryImageURLs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 300,
                          child: Image.network(diaryImageURLs[index]),
                        ),
                        SizedBox(
                          height: 8,
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
                                    '${widget.dataList[index].location}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xfff4c758),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22))),
                                onPressed: () {
                                  
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
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '#${widget.dataList[index].userState}#${widget.dataList[index].activity}#${widget.dataList[index].relation}#${widget.dataList[index].location}',
                                    style: TextStyle(
                                        fontSize: 18, color: Color(0xff888888)),
                                  ),
                                  Text(
                                    diaryTexts[index],
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Color(0xffFBE8B8),
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
