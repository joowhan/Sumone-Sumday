import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  final double latitude;
  final double longitude;
  final double speed;

  // named construcer
  LocationModel.fromJson(Map<String, dynamic> json)
      : latitude = json["latitude"],
        longitude = json["longitude"],
        speed = json["speed"];

  Map<String, Object?> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
    };
  }

  factory LocationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return LocationModel.fromJson(data!);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
    };
  }
}
