import 'package:flutter/material.dart';

/// Helper để lấy tên ngày đã được localize
class DayNameHelper {
  /// Xác định có phải tiếng Việt không từ Locale
  static bool _isVietnamese(Locale? locale) {
    if (locale == null) return true; // Default to Vietnamese
    return locale.languageCode == 'vi';
  }

  /// Lấy tên "Hôm nay" / "Today"
  static String getToday(Locale? locale) {
    return _isVietnamese(locale) ? 'Hôm nay' : 'Today';
  }

  /// Lấy tên "Ngày mai" / "Tomorrow"
  static String getTomorrow(Locale? locale) {
    return _isVietnamese(locale) ? 'Ngày mai' : 'Tomorrow';
  }

  /// Lấy tên ngày trong tuần dựa trên weekday (1 = Monday, 7 = Sunday)
  static String getDayOfWeek(int weekday, Locale? locale) {
    final isVietnamese = _isVietnamese(locale);
    
    if (isVietnamese) {
      const days = ['Chủ nhật', 'Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm', 'Thứ sáu', 'Thứ bảy'];
      return days[weekday % 7];
    } else {
      const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
      return days[weekday % 7];
    }
  }
}

