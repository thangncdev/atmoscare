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
      error: (err, stack) => Center(child: Text('Lỗi: ${err.toString()}')),
    );
  }
}
