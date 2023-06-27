import 'package:cloud_firestore/cloud_firestore.dart';

class RLocationModel {
  final int latitude;
  final int longitude;
  final double temp;
  final String weather;
  final List<dynamic> places;
  final int count;
  final Timestamp timestamp;

  // named construcer
  RLocationModel.fromJson(Map<String, dynamic> json)
      : latitude = json["latitude"],
        longitude = json["longitude"],
        temp = json["temp"],
        weather = json["weather"],
        places = json["place"],
        count = json["count"],
        timestamp = json["timestamp"];

  Map<String, Object?> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'temp': temp,
      'weather': weather,
      'place': places,
      'count': count,
      'timestamp': timestamp,
    };
  }

  factory RLocationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return RLocationModel.fromJson(data!);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'temp': temp,
      'weather': weather,
      'place': places,
      'count': count,
      'timestamp': timestamp,
    };
  }
}
