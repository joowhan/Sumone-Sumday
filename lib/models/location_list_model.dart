/*
* backgorund fetch로 새롭게 저장된 데이터를 위한 model
* class model 형식으로 불러옴
* 이때 사전에 정의한 place_model 형태로 place를 불러올 것
* */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumday/models/place_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocationListModel {
  int count;
  List<VisitedPlaceModel> places;
  Timestamp timestamp;
  String weather;
  String weather_description;

  LocationListModel({
    required this.count,
    required this.places,
    required this.timestamp,
    required this.weather,
    required this.weather_description,
  });

  LocationListModel.fromJson(Map<String, dynamic> json)
      : count = json['count'],
        places = json["place"],
        timestamp = json["timestamp"],
        weather = json["weather"],
        weather_description = json["weather_description"];
  Map<String, Object?> toJson() => {
        'count': count,
        'place': places,
        'timestamp': timestamp,
        'weather': weather,
        'weather_description': weather_description,
      };
}

Future<void> fetchLocationList() async {

}


//