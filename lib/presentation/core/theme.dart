import 'package:atmoscare/presentation/core/screen_util_helper.dart';
import 'package:flutter/material.dart';

/// Theme cho ứng dụng AirCare
/// Dựa trên design tokens từ CSS
class AppTheme {
  // Primary Colors - Sky & Teal (từ CSS)
  static const Color primary50 = Color(0xFFE0F7FF);
  static const Color primary100 = Color(0xFFB3E8FF);
  static const Color primary200 = Color(0xFF80D9FF);
  static const Color primary300 = Color(0xFF4DCAFF);
  static const Color primary400 = Color(0xFF26BEFF);
  static const Color primary500 = Color(0xFF00B2FF); // Primary
  static const Color primary600 = Color(0xFF00A3F0);
  static const Color primary700 = Color(0xFF008FD9);
  static const Color primary800 = Color(0xFF007BC2);
  static const Color primary900 = Color(0xFF00589E);

  // Teal Accent Colors (từ CSS)
  static const Color teal50 = Color(0xFFE0F9F4);
  static const Color teal100 = Color(0xFFB3F0E3);
  static const Color teal200 = Color(0xFF80E6D1);
  static const Color teal300 = Color(0xFF4DDCBE);
  static const Color teal400 = Color(0xFF26D4B0);
  static const Color teal500 = Color(0xFF00CDA3); // Teal primary
  static const Color teal600 = Color(0xFF00BA95);
  static const Color teal700 = Color(0xFF00A382);
  static const Color teal800 = Color(0xFF008D70);
  static const Color teal900 = Color(0xFF006A4E);

  // Màu chủ đạo (backward compatibility)
  static const Color primaryColor = primary500;
  static const Color primaryDark = primary700;
  static const Color primaryLight = primary100;

  // AQI Status Colors (từ CSS)
  static const Color aqiGood = Color(0xFF00B2FF);
  static const Color aqiModerate = Color(0xFF00E676);
  static const Color aqiUnhealthySensitive = Color(0xFFFF9800);
  static const Color aqiUnhealthy = Color(0xFFF44336);
  static const Color aqiVeryUnhealthy = Color(0xFF9C27B0);
  static const Color aqiHazardous = Color(0xFF880E4F);

  // Neutral Colors (từ CSS)
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Card color (backward compatibility)
  static const Color cardColor = surface;

  // Splash Gradient Colors (từ CSS gradient-splash)
  static const Color splashStart = Color(0xFF4DCAFF); // primary300
  static const Color splashMiddle = Color(0xFF26D4B0); // teal400
  static const Color splashEnd = Color(0xFF80E6D1); // teal200

  // Shadows (từ CSS)
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get shadowXl => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.16),
      blurRadius: 48,
      offset: const Offset(0, 16),
    ),
  ];

  // Splash screen shadow (soft, large)
  static List<BoxShadow> get splashShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 40,
      spreadRadius: 0,
      offset: const Offset(0, 8),
    ),
  ];

  static EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: 16.w);
  static EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: 12.w);

  // Border Radius (responsive với ScreenUtil)
  static BorderRadius get radiusXs => BorderRadius.circular(2.r);
  static BorderRadius get radiusSm => BorderRadius.circular(4.r);
  static BorderRadius get radiusMd => BorderRadius.circular(8.r);
  static BorderRadius get radiusLg => BorderRadius.circular(12.r);
  static BorderRadius get radiusXl => BorderRadius.circular(16.r);
  static BorderRadius get radius2xl => BorderRadius.circular(20.r);
  static BorderRadius get radius3xl => BorderRadius.circular(28.r);
  static BorderRadius get radius4xl => BorderRadius.circular(40.r);

  // Curved bottom border (cho header sections)
  static BorderRadius get curvedBottom => BorderRadius.only(
        topLeft: Radius.circular(40.r),
        topRight: Radius.circular(40.r),
      );
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
          borderRadius: radius2xl, // radius-md từ CSS
        ),
        shadowColor: Colors.black.withValues(alpha: 0.08),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600, // SemiBold
          letterSpacing: -0.01,
          fontFamily: 'OpenSans',
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 48,
          fontWeight: FontWeight.w700, // Bold
          letterSpacing: -0.02,
          fontFamily: 'OpenSans',
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600, // SemiBold
          letterSpacing: -0.01,
          fontFamily: 'OpenSans',
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600, // SemiBold
          fontFamily: 'OpenSans',
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400, // Regular
          height: 1.6,
          fontFamily: 'OpenSans',
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400, // Regular
          height: 1.5,
          fontFamily: 'OpenSans',
        ),
        bodySmall: TextStyle(
          color: textTertiary,
          fontSize: 12,
          fontWeight: FontWeight.w400, // Regular
          fontFamily: 'OpenSans',
        ),
        titleSmall: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700, // Bold
          fontFamily: 'OpenSans',
        ),
        labelLarge: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600, // SemiBold
          fontFamily: 'OpenSans',
        ),
      ),
      fontFamily: 'OpenSans',
    );
  }

  /// Text style cho header title (white text trên gradient)
  static TextStyle get headerTitle => TextStyle(
    color: Colors.white,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700, // Bold
    letterSpacing: -0.02,
    height: 1.2,
    fontFamily: fontFamily,
  );

  /// Text style cho header subtitle (white text với opacity)
  static TextStyle get headerSubtitle => TextStyle(
    color: Colors.white.withValues(alpha: 0.7),
    fontSize: 16.sp,
    height: 1.5,
    fontFamily: fontFamily,
  );

  /// Text style cho setting item title
  static TextStyle get settingItemTitle => TextStyle(
    color: textPrimary,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400, // Regular
    fontFamily: fontFamily,
  );

  /// Text style cho setting item subtitle
  static TextStyle get settingItemSubtitle => TextStyle(
    color: textSecondary,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400, // Regular
    fontFamily: fontFamily,
  );

  /// Text style cho button label (selected state - white)
  static TextStyle get buttonLabelSelected => TextStyle(
    color: Colors.white,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600, // SemiBold
    fontFamily: fontFamily,
  );

  /// Text style cho button label (unselected state)
  static TextStyle get buttonLabelUnselected => TextStyle(
    color: textSecondary,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600, // SemiBold
    fontFamily: fontFamily,
  );

  /// Text style cho title small (20sp, bold)
  static TextStyle get titleSmall => TextStyle(
    color: textPrimary,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700, // Bold
    fontFamily: fontFamily,
  );

  /// Text style cho body small (12sp, tertiary color)
  static TextStyle get bodySmall => TextStyle(
    color: textTertiary,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400, // Regular
    fontFamily: fontFamily,
  );

  /// Gradient cho splash screen (từ CSS gradient-splash)
  static LinearGradient get splashGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [
      splashStart, // #4dcaff
      splashMiddle, // #26d4b0
      splashEnd, // #80e6d1
    ],
  );

  /// Gradient sky (từ CSS gradient-sky)
  static LinearGradient get skyGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary500, // #00b2ff
      teal500, // #00cda3
    ],
  );

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
    return [aqiGood, aqiModerate, aqiUnhealthy, aqiVeryUnhealthy, aqiHazardous];
  }

  /// Font family mặc định
  static const String fontFamily = 'OpenSans';

  /// Helper để tạo TextStyle với OpenSans
  static TextStyle textStyle({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      color: color ?? textPrimary,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}
