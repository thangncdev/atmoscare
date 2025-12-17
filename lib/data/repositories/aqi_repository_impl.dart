import 'package:atmoscare/constants/location.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/aqi_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../models/aqi_model.dart';
import '../utils/aqi_helper.dart';
import '../utils/time_formatter.dart';

/// Implementation của AQIRepository sử dụng Open-Meteo Air Quality API
class AQIRepositoryImpl implements AQIRepository {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://air-quality-api.open-meteo.com/v1/air-quality';
  static const String _aqiAlertKey = 'aqi_alert_enabled';
  
  // Default location: Ho Chi Minh City
  

  @override
  Future<AQIEntity> getCurrentAQI({LocationEntity? location, Locale? locale}) async {
    try {
      final lat = location?.latitude ?? LocationConstants.defaultPosition.latitude;
      final lon = location?.longitude ?? LocationConstants.defaultPosition.longitude;
      final locationName = location?.shortDisplayName ?? '';

      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'current': 'european_aqi,us_aqi,pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone,ammonia',
          'timezone': 'auto',
        },
      );

      final data = response.data as Map<String, dynamic>;
      final current = data['current'] as Map<String, dynamic>;
      final currentUnits = data['current_units'] as Map<String, dynamic>;

      // Use European AQI (EAQI) as primary, fallback to US AQI
      final aqi = (current['us_aqi'] ?? current['european_aqi']) as int;
      final status = AQIHelper.getAQIStatus(aqi, locale: locale);
      final recommendations = AQIHelper.getAQIRecommendation(aqi, locale: locale);

      // Build pollutants list
      final pollutants = <PollutantEntity>[];
      
      if (current['pm10'] != null) {
        pollutants.add(
          PollutantModel(
            name: 'PM10',
            value: (current['pm10'] as num).toDouble(),
            unit: currentUnits['pm10'] as String? ?? 'μg/m³',
            status: AQIHelper.getPollutantStatus(
              (current['pm10'] as num).toDouble(),
              'PM10',
              locale: locale,
            ),
          ),
        );
      }

      if (current['pm2_5'] != null) {
        pollutants.add(
          PollutantModel(
            name: 'PM2.5',
            value: (current['pm2_5'] as num).toDouble(),
            unit: currentUnits['pm2_5'] as String? ?? 'μg/m³',
            status: AQIHelper.getPollutantStatus(
              (current['pm2_5'] as num).toDouble(),
              'PM2.5',
              locale: locale,
            ),
          ),
        );
      }

      if (current['carbon_monoxide'] != null) {
        pollutants.add(
          PollutantModel(
            name: 'CO',
            value: (current['carbon_monoxide'] as num).toDouble(),
            unit: currentUnits['carbon_monoxide'] as String? ?? 'μg/m³',
            status: AQIHelper.getPollutantStatus(
              (current['carbon_monoxide'] as num).toDouble(),
              'CO',
              locale: locale,
            ),
          ),
        );
      }

      if (current['nitrogen_dioxide'] != null) {
        pollutants.add(
          PollutantModel(
            name: 'NO₂',
            value: (current['nitrogen_dioxide'] as num).toDouble(),
            unit: currentUnits['nitrogen_dioxide'] as String? ?? 'μg/m³',
            status: AQIHelper.getPollutantStatus(
              (current['nitrogen_dioxide'] as num).toDouble(),
              'NO₂',
              locale: locale,
            ),
          ),
        );
      }

      if (current['sulphur_dioxide'] != null) {
        pollutants.add(
          PollutantModel(
            name: 'SO₂',
            value: (current['sulphur_dioxide'] as num).toDouble(),
            unit: currentUnits['sulphur_dioxide'] as String? ?? 'μg/m³',
            status: AQIHelper.getPollutantStatus(
              (current['sulphur_dioxide'] as num).toDouble(),
              'SO₂',
              locale: locale,
            ),
          ),
        );
      }

      if (current['ozone'] != null) {
        pollutants.add(
          PollutantModel(
            name: 'O₃',
            value: (current['ozone'] as num).toDouble(),
            unit: currentUnits['ozone'] as String? ?? 'μg/m³',
            status: AQIHelper.getPollutantStatus(
              (current['ozone'] as num).toDouble(),
              'O₃',
              locale: locale,
            ),
          ),
        );
      }

      // Parse update time
      String updateTime;
      try {
        final timeStr = current['time'] as String?;
        if (timeStr != null) {
          updateTime = TimeFormatter.formatISO8601ToHourMinute(timeStr);
        } else {
          updateTime = 'N/A';
        }
      } catch (e) {
        updateTime = 'N/A';
      }

      return AQIModel(
        aqi: aqi,
        status: status,
        location: locationName,
        updateTime: updateTime,
        pollutants: pollutants,
        recommendations: recommendations,
      );
    } catch (e) {
      throw Exception('Failed to load AQI data: $e');
    }
  }

  @override
  Future<bool> getAQIAlertEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_aqiAlertKey) ?? false;
  }

  @override
  Future<void> setAQIAlertEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_aqiAlertKey, enabled);
  }
}

