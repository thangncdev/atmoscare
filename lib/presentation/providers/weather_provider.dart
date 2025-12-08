import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/hourly_forecast_entity.dart';
import '../../domain/entities/daily_forecast_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../data/repositories/weather_repository_impl.dart';

/// Provider cho WeatherRepository
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl();
});

/// Provider cho thời tiết hiện tại
final currentWeatherProvider =
    FutureProvider<WeatherEntity>((ref) async {
  final repository = ref.watch(weatherRepositoryProvider);
  return await repository.getCurrentWeather();
});

/// Provider cho dự báo theo giờ
final hourlyForecastProvider =
    FutureProvider<List<HourlyForecastEntity>>((ref) async {
  final repository = ref.watch(weatherRepositoryProvider);
  return await repository.getHourlyForecast();
});

/// Provider cho dự báo theo ngày
final dailyForecastProvider =
    FutureProvider<List<DailyForecastEntity>>((ref) async {
  final repository = ref.watch(weatherRepositoryProvider);
  return await repository.getDailyForecast();
});

