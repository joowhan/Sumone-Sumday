import 'package:intl/intl.dart';

class LocationModel {
  final String datetime =
      DateFormat("yy/MM/dd HH:mm:ss").format(DateTime.now());
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
}
