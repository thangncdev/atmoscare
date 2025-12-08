import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/aqi_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../models/aqi_model.dart';

/// Implementation của AQIRepository sử dụng mock JSON
class AQIRepositoryImpl implements AQIRepository {
  static const String _aqiAlertKey = 'aqi_alert_enabled';

  @override
  Future<AQIEntity> getCurrentAQI() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/aqi.json');
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return AQIModel.fromJson(json);
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

