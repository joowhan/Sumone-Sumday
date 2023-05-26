import 'dart:convert';
import 'package:background_fetch/background_fetch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: unused_import
import 'dart:async';

import 'package:sumday/models/location_model.dart';
import 'package:sumday/models/visited_place_model.dart';

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

Future<Position> getLocation() async {
  var currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);
  return currentPosition;
}

void _onBackgroundFetch(String taskId) async {
  print("[BackgroundFetch] Event received $taskId");
  var currentLocation = await getLocation();

  final locationRef = FirebaseFirestore.instance
      .collection("location")
      .withConverter<LocationModel>(
        fromFirestore: (snapshot, _) =>
            LocationModel.fromJson(snapshot.data()!),
        toFirestore: (location, _) => location.toJson(),
      );
  locationRef.add(LocationModel.fromJson({
    'latitude': currentLocation.latitude,
    'longitude': currentLocation.longitude,
    'speed': currentLocation.speed,
  }));

  var places =
      await getPlacesKakao(currentLocation.latitude, currentLocation.longitude);
  var timestamp = Timestamp.now();
  var weather =
      await getWeather(currentLocation.latitude, currentLocation.longitude);
  for (VisitedPlaceModel place in places) {
    final places = FirebaseFirestore.instance.collection("place");
    places.add({
      'place_id': place.placeId,
      'distance': place.distance,
      'place_name': place.placeName,
      'place_address': place.placeAddress,
      'place_category_name': place.placeCategoryName,
      'place_categoty_group_code': place.placeCategoryGroupCode,
      'place_category_group_name': place.placeCategoryGroupName,
      'timestamp': timestamp,
      'weather': weather,
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
  var currentLocation = await getLocation();

  final locationRef = FirebaseFirestore.instance
      .collection("location")
      .withConverter<LocationModel>(
        fromFirestore: (snapshot, _) =>
            LocationModel.fromJson(snapshot.data()!),
        toFirestore: (location, _) => location.toJson(),
      );
  locationRef.add(LocationModel.fromJson({
    'latitude': currentLocation.latitude,
    'longitude': currentLocation.longitude,
    'speed': currentLocation.speed,
  }));

  var places =
      await getPlacesKakao(currentLocation.latitude, currentLocation.longitude);
  var timestamp = Timestamp.now();
  var weather =
      await getWeather(currentLocation.latitude, currentLocation.longitude);
  for (VisitedPlaceModel place in places) {
    final places = FirebaseFirestore.instance.collection("place");
    places.add({
      'place_id': place.placeId,
      'distance': place.distance,
      'place_name': place.placeName,
      'place_address': place.placeAddress,
      'place_category_name': place.placeCategoryName,
      'place_categoty_group_code': place.placeCategoryGroupCode,
      'place_category_group_name': place.placeCategoryGroupName,
      'timestamp': timestamp,
      'weather': weather,
    });
  }
  BackgroundFetch.finish(taskId);
}

// KAKAO REST API

class Place {
  final Map<String, dynamic> meta;
  final List<Map<String, dynamic>> documents;

  Place({
    required this.meta,
    required this.documents,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      meta: json['meta'],
      documents: json['documents'],
    );
  }

  void printPlace() {
    print("meta: $meta");
    print("documents: $documents");
  }
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
    "OL7",
    "SW8",
    "BK9",
    "CT1",
    "AG2",
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
        "$baseUrl?category_group_code=$categoryGroupCode&x=$longitude&y=$latitude&radius=5&sort=distance");
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
            print(document);
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
Future<Map<String, dynamic>> getWeather(var latitude, var longitude) async {
  var key = "944c738ce4a56b8e700b1a95bd3fc1af";
  var baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  var url = Uri.parse(
      '$baseUrl?lat=$latitude&lon=$longitude&appid=$key&units=metric&lang=kr');
  var response = await http.get(url);
  var json = await jsonDecode(response.body);

  return json;
}
