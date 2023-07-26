import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sumday/screens/ai_writeDiary.dart';
import 'package:openai_dalle_wrapper/openai_dalle_wrapper.dart';

class GenerateProvider with ChangeNotifier {
  List<UserForm>? _dataList;
  List<bool>? _isTextGen;
  List<bool>? _isImageGen;
  List<String>? _enSummary;
  List<String>? _koSummary;
  List<String>? _imageUrl;

  // 배포를 위해 API 키 지웠습니다.
  final String apiKey = 'YOUR_API_KEY';
  final String apiUrl = 'https://api.openai.com/v1/completions';

  int? _diaryIndex;

  int _pageValue = 1;
  double _sliderValue = 1;

  void setPageValue(int value) {
    _pageValue = value;
    notifyListeners();
  }

  void setSliderValue(double value) {
    _sliderValue = value;
    notifyListeners();
  }

  int get PageValue => _pageValue;
  double get sliderValue => _sliderValue;

  List<bool>? get isTextGen => _isTextGen;
  List<bool>? get isPhotoGen => _isImageGen;
  int? get getDiaryIndex => _diaryIndex;

  void init(List<UserForm> data, int diaryIndex) {
    _dataList = data;
    var length = data.length;
    _isTextGen =
        List<bool>.generate(length, (int index) => false, growable: false);
    _isImageGen =
        List<bool>.generate(length, (int index) => false, growable: false);
    _enSummary =
        List<String>.generate(length, (int index) => '', growable: false);
    _koSummary =
        List<String>.generate(length, (int index) => '', growable: false);
    _imageUrl =
        List<String>.generate(length, (int index) => '', growable: false);
    _diaryIndex = diaryIndex;
  }

  void _setTextGen(int index) {
    _isTextGen?[index] = true;
    notifyListeners();
  }

  void _setImageGen(int index) {
    _isImageGen?[index] = true;
    notifyListeners();
  }

  void _setEnSummary(int index, String text) {
    _enSummary?[index] = text;
    notifyListeners();
  }

  void _setKoSummary(int index, String text) {
    _koSummary?[index] = text;
    notifyListeners();
  }

  void _setImgUrl(int index, String url) {
    _imageUrl?[index] = url;
    notifyListeners();
  }

  bool isGenComplete(int index) {
    return _isTextGen![index] && _isImageGen![index];
  }

  String getPrompt(UserForm data) {
    return '${data.userState} ${data.activity} ${data.relation} ${data.location} ${data.category}';
  }

  String getKoSummary(int index) {
    return _koSummary![index];
  }

  String getImageUrl(int index) {
    return _imageUrl![index];
  }

  UserForm getUserData(int index) {
    return _dataList![index];
  }

  int getLastPage() {
    return _dataList!.length;
  }

  // void reset() {
  //   _isTextGen = null;
  //   _isImageGen = null;
  //   _enSummary = null;
  //   _koSummary = null;
  //   _imageUrl = null;
  //   notifyListeners();
  // }

  Future<void> generateSummary(int index) async {
    if (_isTextGen![index]) return;

    var data = _dataList![index];
    var prompt = getPrompt(data);

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

    var eSummary = newresponse['choices'][0]['text'].trim();
    var kSummary = await _translateToKorean(eSummary);

    _setEnSummary(index, eSummary);
    _setKoSummary(index, kSummary);
    _setTextGen(index);
  }

  Future<void> generateContents(int index) async {
    if (!_isTextGen![index]) {
      await generateSummary(index);
    }

    if (!_isImageGen![index]) {
      final openai = OpenaiDalleWrapper(apiKey: apiKey);
      String url = await openai
          .generateImage("${_enSummary![index]}, a painting of illustration");
      _setImgUrl(index, url);
      _setImageGen(index);
    }
  }

  Future<String> _translateToKorean(String text) async {
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
}
