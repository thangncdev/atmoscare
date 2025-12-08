import 'package:flutter/material.dart';

/// Helper để xử lý AQI
class AQIHelper {
  /// Xác định có phải tiếng Việt không từ Locale
  static bool _isVietnamese(Locale? locale) {
    if (locale == null) return true; // Default to Vietnamese
    return locale.languageCode == 'vi';
  }

  /// Get AQI status từ giá trị AQI
  static String getAQIStatus(int aqi, {Locale? locale}) {
    final isVietnamese = _isVietnamese(locale);
    if (isVietnamese) {
      if (aqi <= 50) return 'Tốt';
      if (aqi <= 100) return 'Trung bình';
      if (aqi <= 150) return 'Kém cho nhóm nhạy cảm';
      if (aqi <= 200) return 'Kém';
      if (aqi <= 300) return 'Rất kém';
      return 'Nguy hại';
    } else {
      if (aqi <= 50) return 'Good';
      if (aqi <= 100) return 'Moderate';
      if (aqi <= 150) return 'Unhealthy for Sensitive Groups';
      if (aqi <= 200) return 'Unhealthy';
      if (aqi <= 300) return 'Very Unhealthy';
      return 'Hazardous';
    }
  }

  /// Get AQI recommendation
  static String getAQIRecommendation(int aqi, {Locale? locale}) {
    final isVietnamese = _isVietnamese(locale);
    if (isVietnamese) {
      if (aqi <= 50) {
        return 'Chất lượng không khí tốt, an toàn cho mọi hoạt động ngoài trời';
      }
      if (aqi <= 100) {
        return 'Chất lượng không khí chấp nhận được cho hầu hết mọi người';
      }
      if (aqi <= 150) {
        return 'Nhóm nhạy cảm nên hạn chế hoạt động ngoài trời kéo dài';
      }
      if (aqi <= 200) {
        return 'Mọi người có thể bị ảnh hưởng sức khỏe, hạn chế ra ngoài';
      }
      if (aqi <= 300) {
        return 'Cảnh báo sức khỏe nghiêm trọng, tránh ra ngoài';
      }
      return 'Cảnh báo khẩn cấp, ở trong nhà và đóng cửa sổ';
    } else {
      if (aqi <= 50) {
        return 'Air quality is good, safe for all outdoor activities';
      }
      if (aqi <= 100) {
        return 'Air quality is acceptable for most people';
      }
      if (aqi <= 150) {
        return 'Sensitive groups should limit prolonged outdoor activity';
      }
      if (aqi <= 200) {
        return 'Everyone may begin to experience health effects';
      }
      if (aqi <= 300) {
        return 'Health alert: everyone may experience serious health effects';
      }
      return 'Health warning of emergency conditions';
    }
  }

  /// Get pollutant status
  static String getPollutantStatus(double value, String name, {Locale? locale}) {
    // Simplified status based on common thresholds
    // In real app, you'd have specific thresholds for each pollutant
    final isVietnamese = _isVietnamese(locale);
    if (isVietnamese) {
      if (value < 50) return 'Tốt';
      if (value < 100) return 'Trung bình';
      return 'Kém';
    } else {
      if (value < 50) return 'Good';
      if (value < 100) return 'Moderate';
      return 'Poor';
    }
  }
}

