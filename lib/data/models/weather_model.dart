import '../../domain/entities/weather_entity.dart';

/// Model cho thông tin thời tiết (từ JSON)
class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.temperature,
    required super.feelsLike,
    required super.humidity,
    required super.windSpeed,
    required super.windDirection,
    required super.visibility,
    required super.rain,
    required super.pressure,
    required super.uvIndex,
    required super.condition,
    required super.description,
    required super.icon,
    required super.tempHigh,
    required super.tempLow,
    required super.sunrise,
    required super.sunset,
    required super.location,
    required super.country,
    required super.updateTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: json['humidity'] as int,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: json['windDirection'] as String,
      visibility: (json['visibility'] as num).toDouble(),
      rain: (json['rain'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
      uvIndex: json['uvIndex'] as int,
      condition: json['condition'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      tempHigh: (json['tempHigh'] as num).toDouble(),
      tempLow: (json['tempLow'] as num).toDouble(),
      sunrise: json['sunrise'] as String,
      sunset: json['sunset'] as String,
      location: json['location'] as String,
      country: json['country'] as String,
      updateTime: json['updateTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'visibility': visibility,
      'rain': rain,
      'pressure': pressure,
      'uvIndex': uvIndex,
      'condition': condition,
      'description': description,
      'icon': icon,
      'tempHigh': tempHigh,
      'tempLow': tempLow,
      'sunrise': sunrise,
      'sunset': sunset,
      'location': location,
      'country': country,
      'updateTime': updateTime,
    };
  }
}

