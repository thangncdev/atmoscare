import 'package:flutter/material.dart';
import '../../domain/entities/aqi_entity.dart';
import '../../l10n/app_localizations.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';

/// Widget hiển thị card AQI với circular indicator
class AQISummaryCard extends StatelessWidget {
  final AQIEntity aqi;

  const AQISummaryCard({super.key, required this.aqi});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final aqiColor = AppTheme.getAQIColor(aqi.aqi);
    final progress = (aqi.aqi / 500).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: AppTheme.shadowLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: aqiColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(Icons.air, size: 18.w, color: aqiColor),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            l10n.airQuality,
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      aqi.status,
                      style: TextStyle(
                        color: aqiColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'AQI ${aqi.aqi} • ${l10n.updatedMinutesAgo(10)}',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // Circular AQI Indicator
              SizedBox(
                width: 112.w,
                height: 112.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    SizedBox(
                      width: 112.w,
                      height: 112.w,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 10.w,
                        backgroundColor: AppTheme.divider,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.divider,
                        ),
                      ),
                    ),
                    // Progress circle
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: progress),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return SizedBox(
                          width: 112.w,
                          height: 112.w,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 10.w,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(aqiColor),
                            strokeCap: StrokeCap.round,
                          ),
                        );
                      },
                    ),
                    // Center text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${aqi.aqi}',
                          style: AppTheme.textStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'AQI',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // AQI Scale Bar
          Column(
            children: [
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.aqiGood,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.r),
                            bottomLeft: Radius.circular(4.r),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Container(color: AppTheme.aqiModerate)),
                    Expanded(
                      child: Container(color: AppTheme.aqiUnhealthySensitive),
                    ),
                    Expanded(child: Container(color: AppTheme.aqiUnhealthy)),
                    Expanded(
                      child: Container(color: AppTheme.aqiVeryUnhealthy),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.aqiHazardous,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4.r),
                            bottomRight: Radius.circular(4.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.good,
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 10.sp,
                    ),
                  ),
                  Text(
                    l10n.moderate,
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 10.sp,
                    ),
                  ),
                  Text(
                    l10n.poor,
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 10.sp,
                    ),
                  ),
                  Text(
                    l10n.hazardous,
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Recommendation
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              aqi.recommendations.isNotEmpty
                  ? aqi.recommendations.first
                  : l10n.airQualityGoodSafe,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14.sp,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
