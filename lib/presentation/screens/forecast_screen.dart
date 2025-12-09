import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';
import '../widgets/forecast_header_widget.dart';
import '../widgets/forecast_hourly_list_widget.dart';
import '../widgets/forecast_daily_list_widget.dart';

/// Màn hình dự báo thời tiết
class ForecastScreen extends ConsumerWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header với gradient
          SliverToBoxAdapter(child: const ForecastHeaderWidget()),
          // Content
          SliverPadding(
            padding: AppTheme.paddingScreen,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 16.h),
                const ForecastHourlyListWidget(),
                SizedBox(height: 24.h),
                const ForecastDailyListWidget(),
                SizedBox(height: 24.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
