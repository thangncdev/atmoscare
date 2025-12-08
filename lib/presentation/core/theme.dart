import 'package:flutter/material.dart';

/// Theme cho ứng dụng AirCare
class AppTheme {
  // Màu chủ đạo - xanh ngọc
  static const Color primaryColor = Color(0xFF00BCD4); // Cyan
  static const Color primaryDark = Color(0xFF0097A7);
  static const Color primaryLight = Color(0xFFB2EBF2);

  // Màu AQI
  static const Color aqiGood = Color(0xFF4CAF50); // Xanh lá
  static const Color aqiModerate = Color(0xFFFFEB3B); // Vàng
  static const Color aqiUnhealthy = Color(0xFFFF9800); // Cam
  static const Color aqiVeryUnhealthy = Color(0xFFF44336); // Đỏ
  static const Color aqiHazardous = Color(0xFF9C27B0); // Tím

  // Màu nền
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;

  // Màu chữ
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
      ),
    );
  }

  /// Lấy màu AQI dựa trên giá trị
  static Color getAQIColor(int aqi) {
    if (aqi <= 50) return aqiGood;
    if (aqi <= 100) return aqiModerate;
    if (aqi <= 150) return aqiUnhealthy;
    if (aqi <= 200) return aqiVeryUnhealthy;
    return aqiHazardous;
  }

  /// Lấy màu gradient cho thanh AQI
  static List<Color> getAQIGradient() {
    return [
      aqiGood,
      aqiModerate,
      aqiUnhealthy,
      aqiVeryUnhealthy,
      aqiHazardous,
    ];
  }
}

