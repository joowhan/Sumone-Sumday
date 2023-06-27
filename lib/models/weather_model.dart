class WeatherModel {
  final double temp;
  final int humidity;
  final String weather;
  final String description;

  // named construcer
  WeatherModel.fromJson(Map<String, dynamic> json)
      : temp = double.parse(json['main']['temp'].toString()),
        humidity = json['main']['humidity'],
        weather = json['weather'][0]['main'],
        description = json['weather'][0]['description'];

  Map<String, Object?> toJson() {
    return {
      'temp': temp,
      'humidity': humidity,
      'weather': weather,
      'description': description,
    };
  }
}
