import 'package:flutter/material.dart';

/// Helper để map WMO weather code sang icon và description
class WeatherCodeMapper {
  /// Xác định có phải tiếng Việt không từ Locale
  static bool _isVietnamese(Locale? locale) {
    if (locale == null) return true; // Default to Vietnamese
    return locale.languageCode == 'vi';
  }
  /// Map weather code sang icon name
  static String getIconFromCode(int code) {
    switch (code) {
      case 0:
        return 'sunny';
      case 1:
      case 2:
        return 'partly_cloudy';
      case 3:
        return 'cloudy';
      case 45:
      case 48:
        return 'foggy';
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return 'rainy';
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return 'rainy';
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return 'snowy';
      case 95:
      case 96:
      case 99:
        return 'stormy';
      default:
        return 'cloudy';
    }
  }

  /// Map weather code sang description
  static String getDescriptionFromCode(int code, {Locale? locale}) {
    final isVietnamese = _isVietnamese(locale);
    if (isVietnamese) {
      switch (code) {
        case 0:
          return 'Trời quang';
        case 1:
          return 'Chủ yếu quang';
        case 2:
          return 'Nhiều mây';
        case 3:
          return 'U ám';
        case 45:
          return 'Sương mù';
        case 48:
          return 'Sương mù đóng băng';
        case 51:
          return 'Mưa phùn nhẹ';
        case 53:
          return 'Mưa phùn vừa';
        case 55:
          return 'Mưa phùn dày đặc';
        case 56:
          return 'Mưa phùn đóng băng nhẹ';
        case 57:
          return 'Mưa phùn đóng băng dày đặc';
        case 61:
          return 'Mưa nhẹ';
        case 63:
          return 'Mưa vừa';
        case 65:
          return 'Mưa nặng';
        case 66:
          return 'Mưa đóng băng nhẹ';
        case 67:
          return 'Mưa đóng băng nặng';
        case 71:
          return 'Tuyết nhẹ';
        case 73:
          return 'Tuyết vừa';
        case 75:
          return 'Tuyết nặng';
        case 77:
          return 'Hạt tuyết';
        case 80:
          return 'Mưa rào nhẹ';
        case 81:
          return 'Mưa rào vừa';
        case 82:
          return 'Mưa rào nặng';
        case 85:
          return 'Tuyết rào nhẹ';
        case 86:
          return 'Tuyết rào nặng';
        case 95:
          return 'Dông';
        case 96:
          return 'Dông với mưa đá';
        case 99:
          return 'Dông với mưa đá nặng';
        default:
          return 'Nhiều mây';
      }
    } else {
      switch (code) {
        case 0:
          return 'Clear sky';
        case 1:
          return 'Mainly clear';
        case 2:
          return 'Partly cloudy';
        case 3:
          return 'Overcast';
        case 45:
          return 'Fog';
        case 48:
          return 'Depositing rime fog';
        case 51:
          return 'Light drizzle';
        case 53:
          return 'Moderate drizzle';
        case 55:
          return 'Dense drizzle';
        case 56:
          return 'Light freezing drizzle';
        case 57:
          return 'Dense freezing drizzle';
        case 61:
          return 'Slight rain';
        case 63:
          return 'Moderate rain';
        case 65:
          return 'Heavy rain';
        case 66:
          return 'Light freezing rain';
        case 67:
          return 'Heavy freezing rain';
        case 71:
          return 'Slight snow';
        case 73:
          return 'Moderate snow';
        case 75:
          return 'Heavy snow';
        case 77:
          return 'Snow grains';
        case 80:
          return 'Slight rain showers';
        case 81:
          return 'Moderate rain showers';
        case 82:
          return 'Violent rain showers';
        case 85:
          return 'Slight snow showers';
        case 86:
          return 'Heavy snow showers';
        case 95:
          return 'Thunderstorm';
        case 96:
          return 'Thunderstorm with hail';
        case 99:
          return 'Heavy thunderstorm with hail';
        default:
          return 'Cloudy';
      }
    }
  }

  /// Map weather code sang condition (ngắn gọn)
  static String getConditionFromCode(int code) {
    switch (code) {
      case 0:
        return 'Clear';
      case 1:
      case 2:
        return 'Partly Cloudy';
      case 3:
        return 'Cloudy';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return 'Rainy';
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return 'Snowy';
      case 95:
      case 96:
      case 99:
        return 'Stormy';
      default:
        return 'Cloudy';
    }
  }
}

