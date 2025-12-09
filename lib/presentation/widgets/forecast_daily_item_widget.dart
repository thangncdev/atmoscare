import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';
import '../../domain/entities/daily_forecast_entity.dart';
import 'weather_icon.dart';

/// Widget item trong daily forecast list
class ForecastDailyItemWidget extends StatelessWidget {
  final DailyForecastEntity day;
  final int index;

  const ForecastDailyItemWidget({
    super.key,
    required this.day,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 200 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 120),
            child: child,
          ),
        );
      },
      child: Container(
        // margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),

        child: Row(
          children: [
            // Day and Date
            SizedBox(
              width: 120.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(day.day, style: AppTheme.settingItemTitle),
                      SizedBox(width: 8.w),
                      Text(
                        day.date,
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(day.description, style: AppTheme.bodySmall),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            // Weather Icon
            WeatherIcon(iconName: day.icon, size: 40.w),
            SizedBox(width: 16.w),
            // Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (day.rainChance > 0) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.water_drop,
                          size: 14.w,
                          color: AppTheme.primary500,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${day.rainChance}%',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 16.w),
            // Temperatures
            Text('${day.tempHigh.toInt()}°', style: AppTheme.settingItemTitle),
            SizedBox(width: 4.w),
            Text(
              '${day.tempLow.toInt()}°',
              style: AppTheme.settingItemSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}
