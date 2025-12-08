import '../../domain/entities/daily_forecast_entity.dart';

/// Model cho dự báo theo ngày
class DailyForecastModel extends DailyForecastEntity {
  const DailyForecastModel({
    required super.day,
    required super.date,
    required super.icon,
    required super.description,
    required super.rainChance,
    required super.tempHigh,
    required super.tempLow,
  });

  factory DailyForecastModel.fromJson(Map<String, dynamic> json) {
    return DailyForecastModel(
      day: json['day'] as String,
      date: json['date'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
      rainChance: json['rainChance'] as int,
      tempHigh: (json['tempHigh'] as num).toDouble(),
      tempLow: (json['tempLow'] as num).toDouble(),
    );
  }
}

