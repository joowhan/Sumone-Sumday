import 'dart:convert';
import 'package:background_fetch/background_fetch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: unused_import
import 'dart:async';

import 'package:sumday/models/place_model.dart';
import 'package:sumday/models/weather_model.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

// initiralize background fetch
Future<void> initLocationState() async {
  int status = await BackgroundFetch.configure(
    BackgroundFetchConfig(
      // 최소 시간이 15분임
      minimumFetchInterval: 15,
      stopOnTerminate: false,
      enableHeadless: true,
      startOnBoot: true,
      requiredNetworkType: NetworkType.ANY,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      // 아래는 필요 없을 수도 있음
      requiresDeviceIdle: false,
    ),
    _onBackgroundFetch,
    _onBackgroundFetchTimeout,
  );
}

// save location on db
Future<Position> getLocation() async {
  var currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);
  return currentPosition;
}

void _onBackgroundFetch(String taskId) async {
  print("[BackgroundFetch] Event received $taskId");
  final User? user = auth.currentUser;
  late String uid;
  if (user != null) {
    uid = user.uid;
  } else {
    uid = 'guest';
  }
  var currentLocation = await getLocation();
  var weather =
      await getWeather(currentLocation.latitude, currentLocation.longitude);
  double latitude = double.parse(currentLocation.latitude.toStringAsFixed(4));
  double longitude = double.parse(currentLocation.longitude.toStringAsFixed(4));
  final locationRef = FirebaseFirestore.instance.collection("location");

  // 오늘 06:00부터 현재시각까지의 데이터를 가져오는 쿼리
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day, 0); //테스트용으로 00시로세팅
  Timestamp todayTimestamp = Timestamp.fromDate(today);
  final exists = await locationRef
      .where("uid", isEqualTo: uid)
      .where("timestamp", isGreaterThan: todayTimestamp)
      .where("latitude", isEqualTo: latitude)
      .where("longitude", isEqualTo: longitude)
      .get();
  if (exists.docs.isNotEmpty) {
    FirebaseFirestore.instance
        .collection("location")
        .doc(exists.docs[0].id)
        .update({'count': FieldValue.increment(1)});
    BackgroundFetch.finish(taskId);
    return;
  } else {
    var timestamp = Timestamp.now();

    locationRef.add({
      'count': 1,
      'uid': uid,
      'latitude': latitude,
      'longitude': longitude,
      'speed': currentLocation.speed,
      'temp': weather.temp,
      'humidity': weather.humidity,
      'weather': weather.weather,
      'weather_description': weather.description,
      'timestamp': timestamp,
    });
  }

  BackgroundFetch.finish(taskId);
}

void _onBackgroundFetchTimeout(String taskId) async {
  print("[BackgroundFetch] TIMEOUT: $taskId");
  BackgroundFetch.finish(taskId);
}

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  var taskId = task.taskId;
  var timeout = task.timeout;

  if (timeout) {
    print('[BackgroundFetch] Headless task timed-out: $taskId');
    BackgroundFetch.finish(taskId);
    return;
  }

  print("[BackgroundFetch] Event received $taskId");
  final User? user = auth.currentUser;
  late String uid;
  if (user != null) {
    uid = user.uid;
  } else {
    uid = 'guest';
  }
  var currentLocation = await getLocation();
  var weather =
      await getWeather(currentLocation.latitude, currentLocation.longitude);
  double latitude = double.parse(currentLocation.latitude.toStringAsFixed(4));
  double longitude = double.parse(currentLocation.longitude.toStringAsFixed(4));
  final locationRef = FirebaseFirestore.instance.collection("location");

  // 오늘 06:00부터 현재시각까지의 데이터를 가져오는 쿼리
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day, 6);
  Timestamp todayTimestamp = Timestamp.fromDate(today);
  final exists = await locationRef
      .where("uid", isEqualTo: uid)
      .where("timestamp", isGreaterThan: todayTimestamp)
      .where("latitude", isEqualTo: latitude)
      .where("longitude", isEqualTo: longitude)
      .get();
  if (exists.docs.isNotEmpty) {
    FirebaseFirestore.instance
        .collection("location")
        .doc(exists.docs[0].id)
        .update({'count': FieldValue.increment(1)});
    BackgroundFetch.finish(taskId);
    return;
  } else {
    var timestamp = Timestamp.now();

    locationRef.add({
      'count': 1,
      'uid': uid,
      'latitude': latitude,
      'longitude': longitude,
      'speed': currentLocation.speed,
      'temp': weather.temp,
      'humidity': weather.humidity,
      'weather': weather.weather,
      'weather_description': weather.description,
      'timestamp': timestamp,
    });
  }

  BackgroundFetch.finish(taskId);
}

// get place by coordinate
Future<List<dynamic>> getPlace(var latitude, var longitude) async {
  var places = await getPlacesKakao(latitude, longitude);
  return places;
}

// KaKao REST API
Future<List<VisitedPlaceModel>> getPlacesKakao(
    var latitude, var longitude) async {
  var key = "916168db2740df8a80a776ae4751c981";
  var baseUrl = "https://dapi.kakao.com/v2/local/search/category.json";
  List<VisitedPlaceModel> responses = [];
  // group_code 참조 : https://developers.kakao.com/docs/latest/ko/local/dev-guide#search-by-category-request-category-group-code
  var categoryGroupCodes = [
    "MT1",
    "CS2",
    "PS3",
    "SC4",
    "AC5",
    "PK6",
    "SW8",
    "BK9",
    "CT1",
    "PO3",
    "AT4",
    "AD5",
    "FD6",
    "CE7",
    "HP8",
    "PM9"
  ];
  // 정렬기준에는 accuracy와 distance가 있다는데 무슨 차이인지 모르겠음
  for (final categoryGroupCode in categoryGroupCodes) {
    var url = Uri.parse(
        "$baseUrl?category_group_code=$categoryGroupCode&x=$longitude&y=$latitude&radius=100&sort=distance");
    var response =
        await http.get(url, headers: {"Authorization": "KakaoAK $key"});
    if (response.statusCode == 200) {
      var jsons = await jsonDecode(response.body);
      if (jsons is! List) {
        jsons = [jsons];
      }
      for (final json in jsons) {
        if (json['documents'].length > 0) {
          for (final document in json['documents']) {
            responses.add(VisitedPlaceModel.fromJson(document));
          }
        }
      }
    }
  }

  return responses;
}

// Google Place API
Future<http.Response> getPlacesGoogle(var latitude, var longitude) async {
  var key = "AIzaSyDo2dnIDCoU02BXMP6lR9sVSsXjJiJ7qsg";
  var baseUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
  var url = Uri.parse(
      // rankby parameter를 이용할 수 있는데, prominence(default)는 장소 인기도 중심, distance는 거리 중심
      '$baseUrl?location=$latitude,$longitude&radius=100&type=restaurant&language=ko&key=$key');
  var response = await http.get(url);
  return response;
}

// Weather API
Future<WeatherModel> getWeather(var latitude, var longitude) async {
  var key = "a01688e1c93e922e4bd07d6714e06468";
  var baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  var url = Uri.parse(
      '$baseUrl?lat=$latitude&lon=$longitude&appid=$key&units=metric&lang=kr');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var json = await jsonDecode(response.body);
    print(json);
    return WeatherModel.fromJson(json);
  } else {
    throw Exception('${response.statusCode}');
  }
}
