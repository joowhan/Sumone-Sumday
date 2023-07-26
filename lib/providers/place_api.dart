import 'dart:convert';
import 'package:background_fetch/background_fetch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';

// ignore: unused_import
import 'dart:async';

import 'package:sumday/models/place_model.dart';
import 'package:sumday/models/weather_model.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
// github 업로드 위해 빈 문자열로 치환함
const kakaoApiKey = "";
const googleApiKey = "";
const openWeatherApiKey = "";

const coordinationUnit = 1800; // 반경 약 50m를 동일 좌표로 취급

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

void _saveLocation(uid, taskId) async {
  var currentLocation = await getLocation();
  var weather =
      await getWeather(currentLocation.latitude, currentLocation.longitude);
  int latitude = (currentLocation.latitude * coordinationUnit).round();
  int longitude = (currentLocation.longitude * coordinationUnit).round();
  final locationRef = FirebaseFirestore.instance.collection("location");

  // 오늘 06:00부터 현재시각까지의 데이터를 가져오는 쿼리
  var utcNow = DateTime.now();
  var now = utcNow.add(const Duration(hours: 9)); // UTC +9이므로 9시간을 더해서 가져와야함
  DateTime today = DateTime(now.year, now.month, now.day, 6);
  Timestamp todayTimestamp = Timestamp.fromDate(today);
  final exists = await locationRef
      .where("uid", isEqualTo: uid)
      .where("timestamp", isGreaterThan: todayTimestamp)
      .where("latitude", isEqualTo: latitude)
      .where("longitude", isEqualTo: longitude)
      .get();

  // 해당 위치가 이미 DB에 기록되어있다면 count를 1 증가 시김
  if (exists.docs.isNotEmpty) {
    FirebaseFirestore.instance
        .collection("location")
        .doc(exists.docs[0].id)
        .update({'count': FieldValue.increment(1)});

    return;
    // 해당 위치가 기록되어있지 않다면 DB에 새로 추가
  } else {
    var timestamp = Timestamp.now();
    var places = await getPlace(latitude, longitude);
    var placeList = [];
    var placeId = [];
    for (var place in places) {
      // 부동산, 주유소, 교통, 50m 밖, 중복 장소는 제외
      if ((place.placeCategoryName.contains("부동산") ||
              place.placeCategoryName.contains("교통") ||
              place.placeCategoryName.contains("우체통") ||
              place.placeCategoryName.contains("아파트") ||
              place.placeCategoryName.contains("유치원") ||
              place.placeCategoryName.contains("어린이집") ||
              place.placeCategoryName.contains("인력") ||
              place.placeCategoryName.contains("건설") ||
              place.placeCategoryName.contains("마케팅") ||
              place.placeCategoryName.contains("주차장") ||
              place.placeCategoryName.contains("인테리어") ||
              place.placeCategoryName.contains("가구") ||
              place.placeCategoryName.contains("화장실") ||
              place.placeCategoryName.contains("주유소") ||
              place.placeCategoryName.contains("전기차") ||
              place.placeCategoryName.contains("단체") ||
              place.placeCategoryName.contains("협회") ||
              place.placeCategoryName.contains("관리") ||
              place.placeCategoryName.contains("인쇄") ||
              place.placeCategoryName.contains("기업") ||
              place.placeCategoryName.contains("소프트웨어") ||
              place.placeCategoryName.contains("전문대행") ||
              place.placeCategoryName.contains("학원") ||
              placeId.contains(place.placeId)) ==
          false) {
        placeList.add(place.toJson());
        placeId.add(place.placeId);
      }
    }

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
      'place': placeList,
    });
  }
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

  _saveLocation(uid, taskId);

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
  _saveLocation(uid, taskId);

  BackgroundFetch.finish(taskId);
}

// 좌표를 통해 사용자가 방문한 장소의 후보 리스트를 가져옴
Future<List<VisitedPlaceModel>> getPlace(var latitude, var longitude) async {
  var lat = latitude / coordinationUnit;
  var lon = longitude / coordinationUnit;

  var json = await getPlacesGoogle(lat, lon);
  var placeNames = [
    ...json['results'].map((e) {
      int spaceIndex = e['name'].toString().indexOf(" ");
      if (spaceIndex == -1) {
        return e['name'];
      } else {
        return e['name'].toString().substring(0, spaceIndex);
      }
    }).toList()
  ];
  var places = await getPlacesKakao(placeNames, lat, lon);
  return places;
}

// KaKao REST API

Future<List<VisitedPlaceModel>> getPlacesKakao(
    var placeNames, var latitude, var longitude) async {
  var key = kakaoApiKey;
  var baseUrl = "https://dapi.kakao.com/v2/local/search/keyword.json";
  List<VisitedPlaceModel> responses = [];
  // group_code 참조 : https://developers.kakao.com/docs/latest/ko/local/dev-guide#search-by-category-request-category-group-code

  // 정렬기준에는 accuracy와 distance가 있다는데 무슨 차이인지 모르겠음
  for (final placeName in placeNames) {
    var url = Uri.parse(
        "$baseUrl?query=$placeName&x=$longitude&y=$latitude&radius=500&sort=distance");

    final dio = Dio();

    Future<Response<dynamic>> getHttp() async {
      final response = await dio.get(
        url.toString(),
        options: Options(
          headers: {"Authorization": "KakaoAK $key"},
        ),
      );
      return response;
    }

    var response = await getHttp();
    if (response.statusCode == 200) {
      var jsons = response.data;
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
// Future<List<VisitedPlaceModel>> getPlacesKakao(
//     var latitude, var longitude) async {
//   var key = "kakaoApiKey";
//   var baseUrl = "https://dapi.kakao.com/v2/local/search/category.json";
//   List<VisitedPlaceModel> responses = [];
//   // group_code 참조 : https://developers.kakao.com/docs/latest/ko/local/dev-guide#search-by-category-request-category-group-code
//   var categoryGroupCodes = [
//     "MT1",
//     "CS2",
//     "PS3",
//     "SC4",
//     "AC5",
//     "PK6",
//     "SW8",
//     "BK9",
//     "CT1",
//     "PO3",
//     "AT4",
//     "AD5",
//     "FD6",
//     "CE7",
//     "HP8",
//     "PM9"
//   ];
//   // 정렬기준에는 accuracy와 distance가 있다는데 무슨 차이인지 모르겠음
//   for (final categoryGroupCode in categoryGroupCodes) {
//     var url = Uri.parse(
//         "$baseUrl?category_group_code=$categoryGroupCode&x=$longitude&y=$latitude&radius=100&sort=distance");
//     var response =
//         await http.get(url, headers: {"Authorization": "KakaoAK $key"});
//     if (response.statusCode == 200) {
//       var jsons = await jsonDecode(response.body);
//       if (jsons is! List) {
//         jsons = [jsons];
//       }
//       for (final json in jsons) {
//         if (json['documents'].length > 0) {
//           for (final document in json['documents']) {
//             responses.add(VisitedPlaceModel.fromJson(document));
//           }
//         }
//       }
//     }
//   }

//   return responses;
// }

// Google Place API
Future<dynamic> getPlacesGoogle(var latitude, var longitude) async {
  var key = googleApiKey;
  var baseUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
  var url = Uri.parse(
      // rankby parameter를 이용할 수 있는데, prominence(default)는 장소 인기도 중심, distance는 거리 중심
      '$baseUrl?location=$latitude,$longitude&radius=40&language=ko&key=$key');
  final dio = Dio();
  Future<Response<dynamic>> getHttp() async {
    final response = await dio.get(url.toString());
    return response;
  }

  final response = await getHttp();
  return response.data;
}

// Weather API
Future<WeatherModel> getWeather(var latitude, var longitude) async {
  var key = openWeatherApiKey;
  var baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  var url = Uri.parse(
      '$baseUrl?lat=$latitude&lon=$longitude&appid=$key&units=metric&lang=kr');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var json = await jsonDecode(response.body);
    return WeatherModel.fromJson(json);
  } else {
    throw Exception('${response.statusCode}');
  }
}
