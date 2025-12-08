import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/hourly_forecast_entity.dart';
import '../../domain/entities/daily_forecast_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../models/weather_model.dart';
import '../models/hourly_forecast_model.dart';
import '../models/daily_forecast_model.dart';

/// Implementation của WeatherRepository sử dụng mock JSON
class WeatherRepositoryImpl implements WeatherRepository {
  @override
  Future<WeatherEntity> getCurrentWeather() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/current_weather.json');
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return WeatherModel.fromJson(json);
    } catch (e) {
      throw Exception('Failed to load current weather: $e');
    }
  }

  @override
  Future<List<HourlyForecastEntity>> getHourlyForecast() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/hourly_forecast.json');
      final Map<String, dynamic> json = jsonDecode(jsonString);
      final List<dynamic> hourlyList = json['hourly'] as List;
      return hourlyList
          .map((e) => HourlyForecastModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load hourly forecast: $e');
    }
  }

  @override
  Future<List<DailyForecastEntity>> getDailyForecast() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/daily_forecast.json');
      final Map<String, dynamic> json = jsonDecode(jsonString);
      final List<dynamic> dailyList = json['daily'] as List;
      return dailyList
          .map((e) => DailyForecastModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load daily forecast: $e');
    }
  }
}

