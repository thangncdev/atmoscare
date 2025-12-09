import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';

/// Widget hiển thị card chi tiết thời tiết
class WeatherDetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color startColor;
  final Color endColor;
  final String? subtitle;
  final double? progress;

  const WeatherDetailCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.startColor,
    required this.endColor,
    this.subtitle,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppTheme.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [startColor, endColor],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: startColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 20.w),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                unit,
                style: TextStyle(color: AppTheme.textTertiary, fontSize: 12.sp),
              ),
            ],
          ),
          if (subtitle != null) ...[
            SizedBox(height: 6.h),
            Text(
              subtitle!,
              style: TextStyle(color: AppTheme.textTertiary, fontSize: 11.sp),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
          if (progress != null) ...[
            SizedBox(height: 8.h),
            Container(
              height: 4.h,
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: progress),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [startColor, endColor],
                        ),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget hiển thị grid các card chi tiết thời tiết
class WeatherDetailsGrid extends StatelessWidget {
  final double humidity;
  final double windSpeed;
  final String windDirection;
  final double pressure;
  final double rain;

  const WeatherDetailsGrid({
    super.key,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.rain,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Tính chiều cao cố định cho card (vuông, dựa trên chiều rộng màn hình)
    final cardHeight = (MediaQuery.of(context).size.width - 48.w - 16.w) / 2;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: cardHeight,
                child: WeatherDetailCard(
                  icon: Icons.water_drop,
                  label: l10n.humidity,
                  value: '${humidity.toInt()}',
                  unit: '%',
                  startColor: AppTheme.primary400,
                  endColor: AppTheme.primary600,
                  progress: humidity / 100,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SizedBox(
                height: cardHeight,
                child: WeatherDetailCard(
                  icon: Icons.compress,
                  label: l10n.pressure,
                  value: '${pressure.toInt()}',
                  unit: 'hPa',
                  startColor: AppTheme.primary500,
                  endColor: AppTheme.primary700,
                  subtitle: l10n.normal,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
