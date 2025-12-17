import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../domain/entities/aqi_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../../l10n/app_localizations.dart';
import '../core/screen_util_helper.dart';
import '../core/theme.dart';

class WeatherBotReminderCard extends StatelessWidget {
  final WeatherEntity weather;
  final AQIEntity? aqi;

  const WeatherBotReminderCard({
    super.key,
    required this.weather,
    required this.aqi,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final message = _buildBotMessage(
      weather: weather,
      aqi: aqi,
      l10n: l10n,
    );

    final isWarning = message.isWarning;
    final accentColor = isWarning ? const Color(0xFFFB923C) : AppTheme.primary500;
    final chipBg = isWarning ? const Color(0xFFFFF7ED) : AppTheme.primary50;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: AppTheme.shadowLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 76.w,
            height: 76.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isWarning
                    ? [const Color(0xFFFFEDD5), const Color(0xFFFFFBEB)]
                    : [AppTheme.primary100, AppTheme.teal100],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Lottie.asset(
                'assets/animation/bot.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isWarning
                          ? Icons.warning_amber_rounded
                          : Icons.wb_sunny_outlined,
                      size: 18.sp,
                      color: accentColor,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        message.title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  message.body,
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.5,
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _BotMessage _buildBotMessage({
    required WeatherEntity weather,
    required AQIEntity? aqi,
    required AppLocalizations l10n,
  }) {
    // Keep thresholds aligned with NotificationService._generateWeatherAlertMessage
    final tempMin = weather.tempLow;
    final tempMax = weather.tempHigh;
    final uvIndex = weather.uvIndex.toDouble();

    final isLowTemp = tempMin < 13;
    final isHighUV = uvIndex > 7;
    final isHighAQI = (aqi?.aqi ?? 0) > 150;
    final isRain = _isRainFromWeatherEntity(weather);

    final List<String> warnings = [];
    if (isRain) {
      warnings.add(l10n.botRainWarning);
    }
    if (isHighAQI) {
      final aqiStatus = aqi?.status ?? '';
      warnings.add(l10n.botHighAQIWarning(aqiStatus, '${aqi!.aqi}'));
    }

    if (isLowTemp) {
      warnings.add(l10n.botLowTempWarning(tempMin.toStringAsFixed(0)));
    }

    if (isHighUV) {
      warnings.add(l10n.botHighUVWarning(uvIndex.toStringAsFixed(0)));
    }

    if (warnings.isNotEmpty) {
      return _BotMessage(
        title: l10n.botWeatherAlertTitle,
        body: warnings.first,
        isWarning: true,
      );
    }

    // Safe conditions - show positive message (same spirit as notification logic)
    final body = l10n.botNiceWeatherBody(
      weather.description,
      tempMin.toStringAsFixed(0),
      tempMax.toStringAsFixed(0),
    );

    return _BotMessage(
      title: l10n.botTodayWeatherTitle,
      body: body,
      isWarning: false,
    );
  }

  bool _isRainFromWeatherEntity(WeatherEntity weather) {
    if (weather.rain > 0) return true;

    final condition = weather.condition.toLowerCase();
    final description = weather.description.toLowerCase();

    if (condition.contains('rain') || description.contains('rain')) return true;
    if (condition.contains('drizzle') || description.contains('drizzle')) {
      return true;
    }
    if (condition.contains('thunder') || description.contains('thunder')) {
      return true;
    }

    // Support Vietnamese descriptions too (WeatherCodeMapper localizes description)
    if (condition.contains('mưa') ||
        description.contains('mưa') ||
        condition.contains('dông') ||
        description.contains('dông')) {
      return true;
    }

    return false;
  }
}

class _BotMessage {
  final String title;
  final String body;
  final bool isWarning;

  const _BotMessage({
    required this.title,
    required this.body,
    required this.isWarning,
  });
}
