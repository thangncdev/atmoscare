import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../domain/entities/hourly_forecast_entity.dart';
import 'forecast_hourly_item_widget.dart';
import 'skeleton_loading.dart';

/// Widget hiển thị danh sách dự báo theo giờ (horizontal scroll)
class ForecastHourlyListWidget extends ConsumerStatefulWidget {
  final List<HourlyForecastEntity>? hourly;
  final bool showViewDetails;
  final VoidCallback? onViewDetails;
  final bool autoScroll;

  const ForecastHourlyListWidget({
    super.key,
    this.hourly,
    this.showViewDetails = false,
    this.onViewDetails,
    this.autoScroll = true,
  });

  @override
  ConsumerState<ForecastHourlyListWidget> createState() =>
      _ForecastHourlyListWidgetState();
}

class _ForecastHourlyListWidgetState
    extends ConsumerState<ForecastHourlyListWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToCurrent = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentHour(List<HourlyForecastEntity> hourly) {
    // Tìm index của giờ hiện tại (có label "Bây giờ" hoặc giờ gần nhất)
    int? currentIndex;
    for (int i = 0; i < hourly.length; i++) {
      final hour = hourly[i];
      if (hour.time == 'Bây giờ' || hour.time == 'Now') {
        currentIndex = i;
        break;
      }
    }

    // Nếu không tìm thấy "Bây giờ", tìm giờ gần nhất với thời điểm hiện tại
    if (currentIndex == null) {
      final now = DateTime.now();
      int minDiff = 999999;
      for (int i = 0; i < hourly.length; i++) {
        final hour = hourly[i];
        // Parse time string (format: "HH:mm")
        try {
          final parts = hour.time.split(':');
          if (parts.length == 2) {
            final hourValue = int.parse(parts[0]);
            final minuteValue = int.parse(parts[1]);
            final forecastTime = DateTime(
              now.year,
              now.month,
              now.day,
              hourValue,
              minuteValue,
            );
            final diff = (forecastTime.difference(now)).abs().inMinutes;
            if (diff < minDiff) {
              minDiff = diff;
              currentIndex = i;
            }
          }
        } catch (e) {
          // Ignore parsing errors
        }
      }
    }

    // Scroll đến giờ hiện tại sau khi build
    if (currentIndex != null) {
      // Đợi ListView build xong trước khi scroll
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted || !_scrollController.hasClients) return;

        final itemWidth = 80.w + 16.w; // width + margin
        final screenWidth = MediaQuery.of(context).size.width;
        final scrollPosition =
            (currentIndex! * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
        _scrollController.animateTo(
          scrollPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Nếu có hourly data được truyền vào, sử dụng trực tiếp
    if (widget.hourly != null) {
      return _buildContent(context, l10n, widget.hourly!);
    }

    // Nếu không, fetch từ provider
    final hourlyAsync = ref.watch(hourlyForecastProvider);

    return hourlyAsync.when(
      data: (hourly) => _buildContent(context, l10n, hourly),
      loading: () => const ForecastHourlyListSkeleton(),
      error: (err, stack) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: AppTheme.radius2xl,
          boxShadow: AppTheme.shadowMd,
        ),
        child: Center(child: Text('Lỗi: ${err.toString()}')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    l10n,
    List<HourlyForecastEntity> hourly,
  ) {
    // Scroll đến giờ hiện tại sau khi data được load (chỉ một lần và nếu autoScroll = true)
    if (widget.autoScroll && !_hasScrolledToCurrent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasScrolledToCurrent) {
          _scrollToCurrentHour(hourly);
          _hasScrolledToCurrent = true;
        }
      });
    }

    return Container(
      padding: widget.showViewDetails
          ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)
          : AppTheme.paddingScreen,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: widget.showViewDetails
            ? BorderRadius.circular(28.r)
            : AppTheme.radius2xl,
        boxShadow: widget.showViewDetails
            ? AppTheme.shadowLg
            : AppTheme.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.hourlyForecast,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.showViewDetails && widget.onViewDetails != null)
                TextButton(
                  onPressed: widget.onViewDetails,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.viewDetails,
                        style: TextStyle(
                          color: AppTheme.primary500,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward,
                        size: 16.w,
                        color: AppTheme.primary500,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.shortestSide >= 600 ? 150.h : 120.h,
            child: ListView.builder(
              controller: widget.autoScroll ? _scrollController : null,
              scrollDirection: Axis.horizontal,
              itemCount: hourly.length,
              itemBuilder: (context, index) {
                return ForecastHourlyItemWidget(hour: hourly[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
