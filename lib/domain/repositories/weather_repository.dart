import 'package:flutter/material.dart';
import '../entities/weather_entity.dart';
import '../entities/hourly_forecast_entity.dart';
import '../entities/daily_forecast_entity.dart';
import '../entities/aqi_entity.dart';
import '../entities/location_entity.dart';

/// Repository interface cho thời tiết
abstract class WeatherRepository {
  Future<WeatherEntity> getCurrentWeather({LocationEntity? location, Locale? locale});
  Future<List<HourlyForecastEntity>> getHourlyForecast({LocationEntity? location, Locale? locale});
  Future<List<DailyForecastEntity>> getDailyForecast({LocationEntity? location, Locale? locale});
}


/// Repository interface cho chất lượng không khí
abstract class AQIRepository {
  Future<AQIEntity> getCurrentAQI({LocationEntity? location, Locale? locale});
  Future<bool> getAQIAlertEnabled();
  Future<void> setAQIAlertEnabled(bool enabled);
}

