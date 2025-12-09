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
import 'location_search_screen.dart';
import '../../l10n/app_localizations.dart';

/// Màn hình trang chủ
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _hasShownDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowNotificationDialog();
    });
  }

  Future<void> _checkAndShowNotificationDialog() async {
    if (_hasShownDialog) return;
    
    final notificationService = ref.read(notificationServiceProvider);
    
    // Kiểm tra xem đã request permission chưa
    final hasRequested = await notificationService.hasRequestedPermission();
    if (hasRequested) {
      _hasShownDialog = true;
      return;
    }

    // Kiểm tra permission status
    final hasPermission = await notificationService.checkPermissionStatus();
    if (hasPermission) {
      await notificationService.markPermissionRequested();
      _hasShownDialog = true;
      return;
    }

    // Hiện dialog
    if (mounted && !_hasShownDialog) {
      _hasShownDialog = true;
      _showNotificationPermissionDialog();
    }
  }

  void _showNotificationPermissionDialog() {
    final l10n = AppLocalizations.of(context)!;
    final notificationService = ref.read(notificationServiceProvider);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radius2xl,
        ),
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
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              l10n.notNow,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              // Khởi tạo notification service trước khi request permission
              await notificationService.initialize();
              final granted = await notificationService.requestPermission();
              if (granted && mounted) {
                // Bật notification và lên lịch thông báo
                await notificationService.setNotificationEnabled(true);
                await notificationService.scheduleDailyReminder();
                // Cập nhật provider state
                ref.read(notificationEnabledProvider.notifier).setEnabled(true);
              }
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
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
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
                        error: (_, __) => const SizedBox(),
                      ),

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
            error: (err, stack) => _buildError(context, err.toString()),
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

  Widget _buildError(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Lỗi: $error'),
          ],
        ),
      ),
    );
  }
}
