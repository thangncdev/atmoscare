import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/entities/hourly_forecast_entity.dart';
import '../../domain/entities/daily_forecast_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../models/weather_model.dart';
import '../models/hourly_forecast_model.dart';
import '../models/daily_forecast_model.dart';
import '../utils/weather_code_mapper.dart';
import '../utils/time_formatter.dart';

/// Implementation của WeatherRepository sử dụng Open-Meteo API
class WeatherRepositoryImpl implements WeatherRepository {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  
  // Default location: Ho Chi Minh City
  static const double _defaultLatitude = 10.7546181;
  static const double _defaultLongitude = 106.3655737;

  @override
  Future<WeatherEntity> getCurrentWeather({LocationEntity? location, Locale? locale}) async {
    try {
      final lat = location?.latitude ?? _defaultLatitude;
      final lon = location?.longitude ?? _defaultLongitude;
      final locationName = location?.shortDisplayName ?? 'Hà Nội';

      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,is_day,weather_code,wind_speed_10m,precipitation,surface_pressure',
          'daily': 'weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max',
          'timeformat': 'unixtime',
          'timezone': 'auto',
          'forecast_days': 1,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final current = data['current'] as Map<String, dynamic>;
      final daily = data['daily'] as Map<String, dynamic>;
      final firstDayIndex = 0;

      final weatherCode = current['weather_code'] as int;
      final icon = WeatherCodeMapper.getIconFromCode(weatherCode);
      final description = WeatherCodeMapper.getDescriptionFromCode(weatherCode, locale: locale);
      final condition = WeatherCodeMapper.getConditionFromCode(weatherCode);

      // Get today's data from daily
      final tempHigh = (daily['temperature_2m_max'] as List)[firstDayIndex] as num;
      final tempLow = (daily['temperature_2m_min'] as List)[firstDayIndex] as num;
      final sunriseUnix = (daily['sunrise'] as List)[firstDayIndex] as int;
      final sunsetUnix = (daily['sunset'] as List)[firstDayIndex] as int;
      final uvIndex = ((daily['uv_index_max'] as List)[firstDayIndex] as num).toInt();

      return WeatherModel(
        temperature: (current['temperature_2m'] as num).toDouble(),
        feelsLike: (current['apparent_temperature'] as num).toDouble(),
        humidity: (current['relative_humidity_2m'] as num).toInt(),
        windSpeed: (current['wind_speed_10m'] as num).toDouble(),
        windDirection: 'Đông Bắc', // API doesn't provide direction, using default
        visibility: 10.0, // API doesn't provide visibility, using default
        pressure: (current['surface_pressure'] as num).toDouble(),
        uvIndex: uvIndex,
        condition: condition,
        description: description,
        icon: icon,
        tempHigh: tempHigh.toDouble(),
        tempLow: tempLow.toDouble(),
        sunrise: TimeFormatter.formatUnixTimeToHourMinute(sunriseUnix),
        sunset: TimeFormatter.formatUnixTimeToHourMinute(sunsetUnix),
        location: locationName,
        updateTime: TimeFormatter.formatUpdateTime(current['time'] as int),
      );
    } catch (e) {
      throw Exception('Failed to load current weather: $e');
    }
  }

  @override
  Future<List<HourlyForecastEntity>> getHourlyForecast({LocationEntity? location, Locale? locale}) async {
    try {
      final lat = location?.latitude ?? _defaultLatitude;
      final lon = location?.longitude ?? _defaultLongitude;

      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'hourly': 'temperature_2m,weather_code,precipitation,wind_speed_10m',
          'timeformat': 'unixtime',
          'timezone': 'auto',
          'forecast_days': 1,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final hourly = data['hourly'] as Map<String, dynamic>;
      final times = hourly['time'] as List;
      final temperatures = hourly['temperature_2m'] as List;
      final weatherCodes = hourly['weather_code'] as List;
      final precipitations = hourly['precipitation'] as List;

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final List<HourlyForecastEntity> forecasts = [];

      for (int i = 0; i < times.length && i < 24; i++) {
        final timeUnix = times[i] as int;
        final isNow = (timeUnix - now).abs() < 3600; // Within 1 hour
        
        final weatherCode = weatherCodes[i] as int;
        final icon = WeatherCodeMapper.getIconFromCode(weatherCode);
        
        // Calculate rain chance from precipitation (simplified)
        final precipitation = (precipitations[i] as num).toDouble();
        final rainChance = (precipitation * 10).clamp(0, 100).toInt();

        forecasts.add(
          HourlyForecastModel(
            time: TimeFormatter.formatHourlyTime(timeUnix, isNow: isNow),
            icon: icon,
            temperature: (temperatures[i] as num).toDouble(),
            rainChance: rainChance,
          ),
        );
      }

      return forecasts;
    } catch (e) {
      throw Exception('Failed to load hourly forecast: $e');
    }
  }

  @override
  Future<List<DailyForecastEntity>> getDailyForecast({LocationEntity? location, Locale? locale}) async {
    try {
      final lat = location?.latitude ?? _defaultLatitude;
      final lon = location?.longitude ?? _defaultLongitude;

      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
          'timeformat': 'unixtime',
          'timezone': 'auto',
          'forecast_days': 7,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final daily = data['daily'] as Map<String, dynamic>;
      final times = daily['time'] as List;
      final weatherCodes = daily['weather_code'] as List;
      final tempHighs = daily['temperature_2m_max'] as List;
      final tempLows = daily['temperature_2m_min'] as List;

      final List<DailyForecastEntity> forecasts = [];

      for (int i = 0; i < times.length; i++) {
        final timeUnix = times[i] as int;
        final date = DateTime.fromMillisecondsSinceEpoch(timeUnix * 1000);
        final weatherCode = weatherCodes[i] as int;
        final icon = WeatherCodeMapper.getIconFromCode(weatherCode);
        final description = WeatherCodeMapper.getDescriptionFromCode(weatherCode, locale: locale);

        forecasts.add(
          DailyForecastModel(
            day: _getDayName(date),
            date: _formatDate(date),
            icon: icon,
            description: description,
            rainChance: 0, // API doesn't provide daily rain chance
            tempHigh: (tempHighs[i] as num).toDouble(),
            tempLow: (tempLows[i] as num).toDouble(),
          ),
        );
      }

      return forecasts;
    } catch (e) {
      throw Exception('Failed to load daily forecast: $e');
    }
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final forecastDate = DateTime(date.year, date.month, date.day);
    
    if (forecastDate == today) {
      return 'Hôm nay';
    } else if (forecastDate == today.add(const Duration(days: 1))) {
      return 'Ngày mai';
    } else {
      return _formatDayOfWeek(date);
    }
  }

  String _formatDayOfWeek(DateTime date) {
    const days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return days[date.weekday % 7];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
}

