import '../entities/weather_entity.dart';
import '../entities/hourly_forecast_entity.dart';
import '../entities/daily_forecast_entity.dart';
import '../entities/aqi_entity.dart';

/// Repository interface cho thời tiết
abstract class WeatherRepository {
  Future<WeatherEntity> getCurrentWeather();
  Future<List<HourlyForecastEntity>> getHourlyForecast();
  Future<List<DailyForecastEntity>> getDailyForecast();
}

/// Repository interface cho chất lượng không khí
abstract class AQIRepository {
  Future<AQIEntity> getCurrentAQI();
  Future<bool> getAQIAlertEnabled();
  Future<void> setAQIAlertEnabled(bool enabled);
}

