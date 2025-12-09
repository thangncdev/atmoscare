import 'package:flutter/material.dart';

/// Helper để chuyển đổi độ gió thành tên hướng gió
class WindDirectionHelper {
  /// Xác định có phải tiếng Việt không từ Locale
  static bool _isVietnamese(Locale? locale) {
    if (locale == null) return true; // Default to Vietnamese
    return locale.languageCode == 'vi';
  }

  /// Chuyển đổi độ gió (0-360) thành tên hướng gió
  /// 0° = Bắc, 90° = Đông, 180° = Nam, 270° = Tây
  static String getWindDirectionFromDegrees(double degrees, {Locale? locale}) {
    final isVietnamese = _isVietnamese(locale);
    
    // Normalize degrees to 0-360
    final normalizedDegrees = degrees % 360;
    
    // Chia thành 16 hướng (mỗi hướng 22.5 độ)
    // Hoặc có thể dùng 8 hướng chính (mỗi hướng 45 độ)
    // Tôi sẽ dùng 8 hướng chính cho đơn giản
    
    if (isVietnamese) {
      // 8 hướng chính
      if (normalizedDegrees >= 337.5 || normalizedDegrees < 22.5) {
        return 'Bắc';
      } else if (normalizedDegrees >= 22.5 && normalizedDegrees < 67.5) {
        return 'Đông Bắc';
      } else if (normalizedDegrees >= 67.5 && normalizedDegrees < 112.5) {
        return 'Đông';
      } else if (normalizedDegrees >= 112.5 && normalizedDegrees < 157.5) {
        return 'Đông Nam';
      } else if (normalizedDegrees >= 157.5 && normalizedDegrees < 202.5) {
        return 'Nam';
      } else if (normalizedDegrees >= 202.5 && normalizedDegrees < 247.5) {
        return 'Tây Nam';
      } else if (normalizedDegrees >= 247.5 && normalizedDegrees < 292.5) {
        return 'Tây';
      } else if (normalizedDegrees >= 292.5 && normalizedDegrees < 337.5) {
        return 'Tây Bắc';
      }
    } else {
      // English
      if (normalizedDegrees >= 337.5 || normalizedDegrees < 22.5) {
        return 'North';
      } else if (normalizedDegrees >= 22.5 && normalizedDegrees < 67.5) {
        return 'Northeast';
      } else if (normalizedDegrees >= 67.5 && normalizedDegrees < 112.5) {
        return 'East';
      } else if (normalizedDegrees >= 112.5 && normalizedDegrees < 157.5) {
        return 'Southeast';
      } else if (normalizedDegrees >= 157.5 && normalizedDegrees < 202.5) {
        return 'South';
      } else if (normalizedDegrees >= 202.5 && normalizedDegrees < 247.5) {
        return 'Southwest';
      } else if (normalizedDegrees >= 247.5 && normalizedDegrees < 292.5) {
        return 'West';
      } else if (normalizedDegrees >= 292.5 && normalizedDegrees < 337.5) {
        return 'Northwest';
      }
    }
    
    // Fallback (không bao giờ đến đây nhưng để an toàn)
    return isVietnamese ? 'Bắc' : 'North';
  }
}

