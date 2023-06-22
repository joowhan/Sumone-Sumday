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

const apiKey = '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';
const apiUrl = 'https://api.openai.com/v1/completions';



final FirebaseAuth _auth = FirebaseAuth.instance;

// 이곳에서 로그인된 사용자의 uid를 가져옵니다.
final User? user = _auth.currentUser;
final uid = user?.uid;

class GenerateDiary extends StatefulWidget {
  // const GenerateDiary({Key? key}) : super(key: key);
  final UserForm data;
  GenerateDiary({required this.data});
  @override
  State<GenerateDiary> createState() => _GenerateDiaryState();
}

class _GenerateDiaryState extends State<GenerateDiary> {
  String? diaryText;
  String? diaryImageURL;
  String? imageUuid;  // 클래스 레벨에서 imageUuid 선언
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
    String textPrompt = '${widget.data.userState} ${widget.data.activity} ${widget.data.relation} ${widget.data.location}';
    String summaryInEnglish = await generateSummary(textPrompt);

    final openai = OpenaiDalleWrapper(apiKey: apiKey);
    diaryImageURL = await openai.generateImage(summaryInEnglish + ", a painting of illustration");

    String translatedText = await translateToKorean(summaryInEnglish);
    diaryText = translatedText;

  }
  Future<String> generateSummary(String prompt) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'},
      body: jsonEncode({
        "model": "text-davinci-003",
        'prompt': "Please make it into one sentence in English : " '$prompt' ,
        'max_tokens': 1000,
        'temperature': 0,
        'top_p': 1,
        'frequency_penalty': 0,
        'presence_penalty': 0
      }),
    );

    Map<String, dynamic> newresponse = jsonDecode(utf8.decode(response.bodyBytes));
    //print(newresponse['choices'][0]['text'].trim());
    return newresponse['choices'][0]['text'].trim();
  }
  Future<String> translateToKorean(String text) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'},
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

    Map<String, dynamic> newresponse = jsonDecode(utf8.decode(response.bodyBytes));
    //print(newresponse['choices'][0]['text'].trim());
    return newresponse['choices'][0]['text'].trim();
  }
Future<void> saveImageToFirebaseStorage(String? imageUrl, String? uid, String? uuid) async {
    final response = await http.get(Uri.parse(imageUrl!));
    final Uint8List imageBytes = response.bodyBytes;

    final imageRef = FirebaseStorage.instance.ref().child('/images/$uid/$uuid.png');
    await imageRef.putData(imageBytes);
  }
  Future<void> saveDiaryToFirestore() async {
  final db = FirebaseFirestore.instance;

  final User? user = _auth.currentUser;
  late String uid;
  if (user != null) {
    uid = user.uid;
  } else {
    uid = 'guest';
  }
  DateTime date = DateTime.now(); 
  List<String> tags = [widget.data.userState, widget.data.activity, widget.data.relation, widget.data.location];
  String context = diaryText!;
  String photos = imageUuid!+'.png';
  bool favorite = false;

  await db.collection("diary").doc().set(
    {
      "userID": uid, 
      "date": date,
      "tags": tags,
      "context": context,
      "photos": photos,
      "favorite": favorite,
    },
  );
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
                    onPressed: () async {
                      print('save');
                      var uuid = Uuid();
                      imageUuid = uuid.v1();
                      saveImageToFirebaseStorage(diaryImageURL, uid, imageUuid); // 스토리지 이미지 저장
                      saveDiaryToFirestore(); //일기 저장 
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
                      Text(
                        DateFormat('y년 M월 d일 a h:mm').format(DateTime.now().toLocal()),
                        style: TextStyle(
                          color: Colors.black38,
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        '#${widget.data.userState}#${widget.data.activity}#${widget.data.relation}#${widget.data.location}',
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