import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/weather_icon.dart';

/// Màn hình dự báo thời tiết
class ForecastScreen extends ConsumerStatefulWidget {
  const ForecastScreen({super.key});

  @override
  ConsumerState<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends ConsumerState<ForecastScreen> {
  bool _is24HourMode = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header với gradient
          SliverToBoxAdapter(
            child: _buildHeader(context, l10n),
          ),
          // Content
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 16.h),
                _is24HourMode
                    ? _build24HourForecast(context, l10n)
                    : _build7DayForecast(context, l10n),
                SizedBox(height: 24.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, l10n) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.skyGradient,
      ),
      child: Stack(
        children: [
          // Animated particles
          ...List.generate(5, (index) {
            return Positioned(
              left: ((20 + index * 15) / 100 * MediaQuery.of(context).size.width),
              top: ((30 + index * 10) / 100 * MediaQuery.of(context).size.height),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 3 + index),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, math.sin(value * 2 * math.pi) * 20),
                    child: Opacity(
                      opacity: (0.2 + (math.sin(value * 2 * math.pi) * 0.3)).clamp(0.0, 1.0),
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          // Header content
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 56.h, 24.w, 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  l10n.weatherForecast,
                  style: AppTheme.headerTitle,
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.detailsForNext7Days,
                  style: AppTheme.headerSubtitle,
                ),
                SizedBox(height: 24.h),

                // Toggle buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildToggleButton(
                        context,
                        l10n.twentyFourHours,
                        !_is24HourMode,
                        () => setState(() => _is24HourMode = false),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildToggleButton(
                        context,
                        l10n.sevenDays,
                        _is24HourMode,
                        () => setState(() => _is24HourMode = true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Curved bottom border
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: Container(
              height: 32.h,
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: AppTheme.curvedBottom,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: AppTheme.radius2xl,
          border: Border.all(
            color: Colors.white.withValues(alpha: isSelected ? 0.3 : 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              Container(
                width: 6.w,
                height: 6.w,
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build24HourForecast(BuildContext context, l10n) {
    final hourlyAsync = ref.watch(hourlyForecastProvider);

    return hourlyAsync.when(
      data: (hourly) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: AppTheme.radius2xl,
          boxShadow: AppTheme.shadowMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.hourlyDetails,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            ...hourly.asMap().entries.map((entry) {
              final index = entry.key;
              final hour = entry.value;
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index * 50)),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset((1 - value) * -10, 0),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppTheme.divider,
                    borderRadius: AppTheme.radius2xl,
                  ),
                  child: Row(
                    children: [
                      // Time
                      SizedBox(
                        width: 50.w,
                        child: Text(
                          hour.time,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Weather Icon
                      WeatherIcon(iconName: hour.icon, size: 28.w),
                      SizedBox(width: 12.w),
                      // Temperature
                      SizedBox(
                        width: 45.w,
                        child: Text(
                          '${hour.temperature.toInt()}°',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Rain chance
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.water_drop,
                              size: 14.w,
                              color: AppTheme.primary500,
                            ),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: Text(
                                '${hour.rainChance}%',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Wind speed (placeholder - hourly entity không có windSpeed)
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.air,
                              size: 14.w,
                              color: AppTheme.teal500,
                            ),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: Text(
                                '8 km/h',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      loading: () => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: AppTheme.radius2xl,
          boxShadow: AppTheme.shadowMd,
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: AppTheme.radius2xl,
          boxShadow: AppTheme.shadowMd,
        ),
        child: Center(
          child: Text('Lỗi: ${err.toString()}'),
        ),
      ),
    );
  }

  Widget _build7DayForecast(BuildContext context, l10n) {
    final dailyAsync = ref.watch(dailyForecastProvider);

    return dailyAsync.when(
      data: (daily) => Column(
        children: daily.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 200 + (index * 100)),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 20),
                  child: child,
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: AppTheme.radius2xl,
                boxShadow: AppTheme.shadowMd,
              ),
              child: Row(
                children: [
                  // Day and Date
                  SizedBox(
                    width: 100.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day.day,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          day.date,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
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
                        Text(
                          day.description,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14.sp,
                          ),
                        ),
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
                  Text(
                    '${day.tempHigh.toInt()}°',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${day.tempLow.toInt()}°',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text('Lỗi: ${err.toString()}'),
      ),
    );
  }
}
