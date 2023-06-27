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

  final String apiKey = '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';
  final String apiUrl = 'https://api.openai.com/v1/completions';

  List<bool>? get isTextGen => _isTextGen;
  List<bool>? get isPhotoGen => _isImageGen;

  void init(List<UserForm> data) {
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
    print(_dataList);
  }

  void _setTextGen(int index) {
    _isTextGen?[index] = true;
    print('11');
    notifyListeners();
  }

  void _setImageGen(int index) {
    _isImageGen?[index] = true;
    print('22');
    notifyListeners();
  }

  void _setEnSummary(int index, String text) {
    _enSummary?[index] = text;
    print('33');
    notifyListeners();
  }

  void _setKoSummary(int index, String text) {
    _koSummary?[index] = text;
    print('44');
    notifyListeners();
  }

  void _setImgUrl(int index, String url) {
    _imageUrl?[index] = url;
    print('55');
    notifyListeners();
  }

  bool isGenComplete(int index) {
    return _isTextGen![index] && _isImageGen![index];
  }

  String getPrompt(UserForm data) {
    return '${data.userState} ${data.activity} ${data.relation} ${data.location}';
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
    print('gen1');
    print('$_dataList');
    if (_isTextGen![index]) return;
    print('gen summ');

    var data = _dataList![index];
    var prompt = getPrompt(data);
    print('$prompt');

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
    print('ddd');
    var kSummary = await _translateToKorean(eSummary);
    print('bbb');
    _setEnSummary(index, eSummary);
    print('ccc');
    _setKoSummary(index, kSummary);
    _setTextGen(index);
  }

  Future<void> generateContents(int index) async {
    print('$_dataList');
    print('fealihulihjrf');
    if (!_isTextGen![index]) {
      await generateSummary(index);
    }
    print('gen Cont');

    if (!_isImageGen![index]) {
      final openai = OpenaiDalleWrapper(apiKey: apiKey);
      String url = await openai
          .generateImage(_enSummary![index] + ", a painting of illustration");
      print(url);
      _setImgUrl(index, url);
      _setImageGen(index);
    }
  }

  Future<String> _translateToKorean(String text) async {
    print('tto');
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
