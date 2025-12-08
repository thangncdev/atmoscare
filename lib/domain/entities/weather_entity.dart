/// Entity cho thông tin thời tiết hiện tại
class WeatherEntity {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String windDirection;
  final double visibility;
  final double pressure;
  final int uvIndex;
  final String condition;
  final String description;
  final String icon;
  final double tempHigh;
  final double tempLow;
  final String sunrise;
  final String sunset;
  final String location;
  final String updateTime;

  const WeatherEntity({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.visibility,
    required this.pressure,
    required this.uvIndex,
    required this.condition,
    required this.description,
    required this.icon,
    required this.tempHigh,
    required this.tempLow,
    required this.sunrise,
    required this.sunset,
    required this.location,
    required this.updateTime,
  });
}

