import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';
import '../../l10n/app_localizations.dart';
import 'forecast_daily_item_widget.dart';
import 'skeleton_loading.dart';

/// Widget hiển thị danh sách dự báo 7 ngày
class ForecastDailyListWidget extends ConsumerWidget {
  const ForecastDailyListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dailyAsync = ref.watch(dailyForecastProvider);

    return dailyAsync.when(
      data: (daily) => Container(
        padding: AppTheme.paddingScreen,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: AppTheme.radius2xl,
          boxShadow: AppTheme.shadowMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sevenDays,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            ...daily.asMap().entries.map((entry) {
              final index = entry.key;
              final day = entry.value;
              return ForecastDailyItemWidget(day: day, index: index);
            }),
          ],
        ),
      ),
      loading: () => const ForecastDailyListSkeleton(),
      error: (err, stack) => _buildError(context, l10n, ref),
    );
  }

  Widget _buildError(BuildContext context, l10n, WidgetRef ref) {
    return Container(
      padding: AppTheme.paddingScreen,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.radius2xl,
        boxShadow: AppTheme.shadowMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.sevenDays,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Icon(
            Icons.calendar_today_outlined,
            size: 48.w,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: 12.h),
          Text(
            l10n.errorLoadingForecast,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.errorLoadingForecastMessage,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.h),
          TextButton.icon(
            onPressed: () {
              ref.invalidate(dailyForecastProvider);
            },
            icon: Icon(Icons.refresh, size: 16.w),
            label: Text(
              l10n.retry,
              style: TextStyle(fontSize: 12.sp),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
