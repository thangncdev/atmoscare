import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';
import '../../domain/entities/hourly_forecast_entity.dart';
import 'weather_icon.dart';

/// Widget item trong hourly forecast list
class ForecastHourlyItemWidget extends StatelessWidget {
  final HourlyForecastEntity hour;

  const ForecastHourlyItemWidget({super.key, required this.hour});

  @override
  Widget build(BuildContext context) {
    final isCurrentHour = hour.time == 'Bây giờ' || hour.time == 'Now';

    return Container(
      margin: EdgeInsets.only(right: 16.w),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(36.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hour.time,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12.sp,
              fontWeight: isCurrentHour ? FontWeight.w600 : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: 6.h),
          WeatherIcon(iconName: hour.icon, size: 28.w),
          SizedBox(height: 6.h),
          Text(
            '${hour.temperature.toInt()}°',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
