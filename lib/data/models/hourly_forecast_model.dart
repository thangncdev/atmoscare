import '../../domain/entities/hourly_forecast_entity.dart';

/// Model cho dự báo theo giờ
class HourlyForecastModel extends HourlyForecastEntity {
  const HourlyForecastModel({
    required super.time,
    required super.icon,
    required super.temperature,
    required super.rainChance,
  });

  factory HourlyForecastModel.fromJson(Map<String, dynamic> json) {
    return HourlyForecastModel(
      time: json['time'] as String,
      icon: json['icon'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      rainChance: json['rainChance'] as int,
    );
  }
}

