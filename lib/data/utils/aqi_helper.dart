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

  /// Get AQI recommendations (multiple recommendations)
  static List<String> getAQIRecommendation(int aqi, {Locale? locale}) {
    final isVietnamese = _isVietnamese(locale);
    if (isVietnamese) {
      if (aqi <= 50) {
        return [
          'Chất lượng không khí lý tưởng cho hoạt động ngoài trời',
          'Mở cửa sổ để thông gió tự nhiên',
          'Tận hưởng các hoạt động thể thao ngoài trời',
        ];
      }
      if (aqi <= 100) {
        return [
          'Có thể hoạt động ngoài trời bình thường',
          'Nhóm nhạy cảm nên theo dõi sức khỏe',
          'Hạn chế hoạt động quá mức trong thời gian dài',
        ];
      }
      if (aqi <= 150) {
        return [
          'Nhóm nhạy cảm nên hạn chế hoạt động ngoài trời',
          'Đóng cửa sổ nếu có người nhạy cảm trong nhà',
          'Sử dụng máy lọc không khí trong nhà',
        ];
      }
      if (aqi <= 200) {
        return [
          'Hạn chế hoạt động ngoài trời kéo dài',
          'Đeo khẩu trang khi ra ngoài',
          'Bật máy lọc không khí trong nhà',
        ];
      }
      if (aqi <= 300) {
        return [
          'Tránh hoạt động ngoài trời',
          'Đeo khẩu trang N95 khi cần thiết ra ngoài',
          'Đóng kín cửa sổ và sử dụng máy lọc không khí',
        ];
      }
      return [
        'Ở trong nhà và đóng kín cửa sổ',
        'Sử dụng máy lọc không khí liên tục',
        'Tránh mọi hoạt động ngoài trời',
      ];
    } else {
      if (aqi <= 50) {
        return [
          'Ideal air quality for outdoor activities',
          'Open windows for natural ventilation',
          'Enjoy outdoor sports activities',
        ];
      }
      if (aqi <= 100) {
        return [
          'Sensitive groups should monitor health',
          'Normal outdoor activities are acceptable',
          'Limit excessive activity over extended periods',
        ];
      }
      if (aqi <= 150) {
        return [
          'Sensitive groups should limit outdoor activity',
          'Close windows if sensitive people are indoors',
          'Use air purifier indoors',
        ];
      }
      if (aqi <= 200) {
        return [
          'Limit prolonged outdoor activity',
          'Wear a mask when going outside',
          'Turn on air purifier indoors',
        ];
      }
      if (aqi <= 300) {
        return [
          'Avoid outdoor activities',
          'Wear N95 mask when necessary to go outside',
          'Close windows tightly and use air purifier',
        ];
      }
      return [
        'Stay indoors and close windows tightly',
        'Use air purifier continuously',
        'Avoid all outdoor activities',
      ];
    }
  }

  /// Get pollutant status dựa trên ngưỡng cụ thể cho từng loại pollutant
  static String getPollutantStatus(double value, String name, {Locale? locale}) {
    final isVietnamese = _isVietnamese(locale);
    
    switch (name) {
      case 'PM2.5':
        return _getPM25Status(value, isVietnamese);
      case 'PM10':
        return _getPM10Status(value, isVietnamese);
      case 'CO':
        return _getCOStatus(value, isVietnamese);
      case 'NO₂':
        return _getNO2Status(value, isVietnamese);
      case 'SO₂':
        return _getSO2Status(value, isVietnamese);
      case 'O₃':
        return _getO3Status(value, isVietnamese);
      default:
        return isVietnamese ? 'Tốt' : 'Good';
    }
  }

  /// PM2.5 status
  static String _getPM25Status(double value, bool isVietnamese) {
    if (value <= 12.0) {
      return isVietnamese ? 'Tốt' : 'Good';
    } else if (value <= 35.4) {
      return isVietnamese ? 'Trung bình' : 'Moderate';
    } else if (value <= 55.4) {
      return isVietnamese ? 'Không tốt' : 'Unhealthy for Sensitive';
    } else if (value <= 150.4) {
      return isVietnamese ? 'Xấu' : 'Unhealthy';
    } else if (value <= 250.4) {
      return isVietnamese ? 'Rất xấu' : 'Very Unhealthy';
    } else {
      return isVietnamese ? 'Nguy hại' : 'Hazardous';
    }
  }

  /// PM10 status
  static String _getPM10Status(double value, bool isVietnamese) {
    if (value <= 54) {
      return isVietnamese ? 'Tốt' : 'Good';
    } else if (value <= 154) {
      return isVietnamese ? 'Trung bình' : 'Moderate';
    } else if (value <= 254) {
      return isVietnamese ? 'Không tốt' : 'Unhealthy for Sensitive';
    } else if (value <= 354) {
      return isVietnamese ? 'Xấu' : 'Unhealthy';
    } else if (value <= 424) {
      return isVietnamese ? 'Rất xấu' : 'Very Unhealthy';
    } else {
      return isVietnamese ? 'Nguy hại' : 'Hazardous';
    }
  }

  /// CO status
  static String _getCOStatus(double value, bool isVietnamese) {
    if (value <= 5000) {
      return isVietnamese ? 'Tốt' : 'Good';
    } else if (value <= 10000) {
      return isVietnamese ? 'Trung bình' : 'Moderate';
    } else if (value <= 14000) {
      return isVietnamese ? 'Không tốt' : 'Unhealthy for Sensitive';
    } else if (value <= 17000) {
      return isVietnamese ? 'Xấu' : 'Unhealthy';
    } else if (value <= 34000) {
      return isVietnamese ? 'Rất xấu' : 'Very Unhealthy';
    } else {
      return isVietnamese ? 'Nguy hại' : 'Hazardous';
    }
  }

  /// NO₂ status
  static String _getNO2Status(double value, bool isVietnamese) {
    if (value <= 100) {
      return isVietnamese ? 'Tốt' : 'Good';
    } else if (value <= 188) {
      return isVietnamese ? 'Trung bình' : 'Moderate';
    } else if (value <= 677) {
      return isVietnamese ? 'Không tốt' : 'Unhealthy for Sensitive';
    } else if (value <= 1220) {
      return isVietnamese ? 'Xấu' : 'Unhealthy';
    } else if (value <= 2340) {
      return isVietnamese ? 'Rất xấu' : 'Very Unhealthy';
    } else {
      return isVietnamese ? 'Nguy hại' : 'Hazardous';
    }
  }

  /// SO₂ status
  static String _getSO2Status(double value, bool isVietnamese) {
    if (value <= 91) {
      return isVietnamese ? 'Tốt' : 'Good';
    } else if (value <= 196) {
      return isVietnamese ? 'Trung bình' : 'Moderate';
    } else if (value <= 485) {
      return isVietnamese ? 'Không tốt' : 'Unhealthy for Sensitive';
    } else if (value <= 797) {
      return isVietnamese ? 'Xấu' : 'Unhealthy';
    } else if (value <= 1585) {
      return isVietnamese ? 'Rất xấu' : 'Very Unhealthy';
    } else {
      return isVietnamese ? 'Nguy hại' : 'Hazardous';
    }
  }

  /// O₃ status
  static String _getO3Status(double value, bool isVietnamese) {
    if (value <= 108) {
      return isVietnamese ? 'Tốt' : 'Good';
    } else if (value <= 140) {
      return isVietnamese ? 'Trung bình' : 'Moderate';
    } else if (value <= 170) {
      return isVietnamese ? 'Không tốt' : 'Unhealthy for Sensitive';
    } else if (value <= 210) {
      return isVietnamese ? 'Xấu' : 'Unhealthy';
    } else if (value <= 400) {
      return isVietnamese ? 'Rất xấu' : 'Very Unhealthy';
    } else {
      return isVietnamese ? 'Nguy hại' : 'Hazardous';
    }
  }

  /// Calculate US AQI from PM2.5 concentration (μg/m³)
  /// Based on US EPA AQI calculation formula
  static int calculateAQIFromPM25(double pm25) {
    if (pm25 <= 0) return 0;
    
    // AQI breakpoints for PM2.5 (US EPA standard)
    if (pm25 <= 12.0) {
      // AQI 0-50 (Good)
      return ((50 - 0) / (12.0 - 0.0) * (pm25 - 0.0) + 0).round().clamp(0, 50);
    } else if (pm25 <= 35.4) {
      // AQI 51-100 (Moderate)
      return ((100 - 51) / (35.4 - 12.1) * (pm25 - 12.1) + 51).round().clamp(51, 100);
    } else if (pm25 <= 55.4) {
      // AQI 101-150 (Unhealthy for Sensitive Groups)
      return ((150 - 101) / (55.4 - 35.5) * (pm25 - 35.5) + 101).round().clamp(101, 150);
    } else if (pm25 <= 150.4) {
      // AQI 151-200 (Unhealthy)
      return ((200 - 151) / (150.4 - 55.5) * (pm25 - 55.5) + 151).round().clamp(151, 200);
    } else if (pm25 <= 250.4) {
      // AQI 201-300 (Very Unhealthy)
      return ((300 - 201) / (250.4 - 150.5) * (pm25 - 150.5) + 201).round().clamp(201, 300);
    } else {
      // AQI 301+ (Hazardous)
      return ((500 - 301) / (500.4 - 250.5) * (pm25 - 250.5) + 301).round().clamp(301, 500);
    }
  }
}

