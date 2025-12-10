import 'package:atmoscare/data/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/weather_provider.dart';
import '../providers/aqi_provider.dart';
import '../providers/notification_provider.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';
import '../widgets/weather_header_section.dart';
import '../widgets/aqi_summary_card.dart';
import '../widgets/sunrise_sunset_card.dart';
import '../widgets/weather_detail_card.dart';
import '../widgets/forecast_hourly_list_widget.dart';
import '../widgets/skeleton_loading.dart';
import '../widgets/error_widget.dart';
import 'location_search_screen.dart';
import '../../l10n/app_localizations.dart';

/// Màn hình trang chủ
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndShowNotificationDialog();
    });
  }

  Future<void> checkAndShowNotificationDialog() async {
    final isShowedDialogRequestNoti = await NotificationService()
        .isShowedDialogRequestNoti();
    if (isShowedDialogRequestNoti) {
      return;
    }
    if (mounted) {
      showNotificationPermissionDialog(context);
      await NotificationService().setShowedDialogRequestNoti();
    }
  }

  void showNotificationPermissionDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radius2xl),
        title: Text(
          l10n.enableNotificationsTitle,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          l10n.enableNotificationsMessage,
          style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              l10n.notNow,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await NotificationService().initialize();
              ref.read(notificationEnabledProvider.notifier).loadEnabled();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              l10n.enable,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(currentWeatherProvider);
    final aqiAsync = ref.watch(currentAQIProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentWeatherProvider);
          ref.invalidate(hourlyForecastProvider);
          ref.invalidate(currentAQIProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: weatherAsync.when(
            data: (weather) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Header with Dynamic Background
                WeatherHeaderSection(
                  weather: weather,
                  onLocationTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LocationSearchScreen(),
                      ),
                    );
                  },
                ),

                // Content Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),

                      // AQI Summary Card
                      aqiAsync.when(
                        data: (aqi) => AQISummaryCard(aqi: aqi),
                        loading: () => const AQISummaryCardSkeleton(),
                        error: (_, __) => _buildAQIError(context),
                      ),

                      // TextButton(
                      //   onPressed: () {
                      //     NotificationService().initialize();
                      //   },
                      //   child: Text('Initialize Notification'),
                      // ),
                      // TextButton(
                      //   onPressed: () {
                      //     NotificationService().showTestNotification();
                      //   },
                      //   child: Text('Test Notification'),
                      // ),
                      // TextButton(
                      //   onPressed: () {
                      //     NotificationService().showWeatherAlertNotification();
                      //   },
                      //   child: Text('Weather Alert Notification'),
                      // ),
                      SizedBox(height: 24.h),

                      // Sunrise/Sunset
                      SunriseSunsetRow(
                        sunrise: weather.sunrise,
                        sunset: weather.sunset,
                      ),

                      SizedBox(height: 20.h),
                      // Weather Details Grid
                      WeatherDetailsGrid(
                        humidity: weather.humidity.toDouble(),
                        windSpeed: weather.windSpeed,
                        windDirection: weather.windDirection,
                        pressure: weather.pressure,
                        rain: weather.rain,
                      ),

                      SizedBox(height: 24.h),

                      ForecastHourlyListWidget(
                        showViewDetails: true,
                        autoScroll: true,
                        onViewDetails: () {
                          context.go('/forecast');
                        },
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
            loading: () => _buildSkeletonLoading(),
            error: (err, stack) => _buildWeatherError(context),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WeatherHeaderSkeleton(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              const AQISummaryCardSkeleton(),
              SizedBox(height: 24.h),
              const SunriseSunsetRowSkeleton(),
              SizedBox(height: 20.h),
              const WeatherDetailsGridSkeleton(),
              SizedBox(height: 24.h),
              const ForecastHourlyListSkeleton(showViewDetails: true),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherError(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FriendlyErrorWidget(
      title: l10n.errorLoadingWeather,
      message: l10n.errorLoadingWeatherMessage,
      onRetry: () {
        ref.invalidate(currentWeatherProvider);
        ref.invalidate(hourlyForecastProvider);
      },
      icon: Icons.wb_cloudy_outlined,
    );
  }

  Widget _buildAQIError(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(Icons.air_outlined, size: 32.w, color: AppTheme.textSecondary),
          SizedBox(height: 12.h),
          Text(
            l10n.errorLoadingAQI,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.errorLoadingAQIMessage,
            style: TextStyle(fontSize: 12.sp, color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          TextButton.icon(
            onPressed: () {
              ref.invalidate(currentAQIProvider);
            },
            icon: Icon(Icons.refresh, size: 16.w),
            label: Text(l10n.retry, style: TextStyle(fontSize: 12.sp)),
            style: TextButton.styleFrom(foregroundColor: AppTheme.primaryColor),
          ),
        ],
      ),
    );
  }
}
