import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../providers/aqi_provider.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';
import '../widgets/weather_header_section.dart';
import '../widgets/aqi_summary_card.dart';
import '../widgets/sunrise_sunset_card.dart';
import '../widgets/weather_detail_card.dart';
import '../widgets/hourly_forecast_widget.dart';
import 'location_search_screen.dart';

/// Màn hình trang chủ
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider);
    final hourlyForecastAsync = ref.watch(hourlyForecastProvider);
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
                        loading: () => const SizedBox(),
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
                        visibility: weather.visibility,
                      ),

                      SizedBox(height: 24.h),

                      // 24 Hour Forecast
                      hourlyForecastAsync.when(
                        data: (hourly) => HourlyForecastWidget(
                          hourly: hourly,
                          onViewDetails: () {
                            // TODO: Navigate to detailed forecast
                          },
                        ),
                        loading: () => Container(
                          height: 200.h,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (err, stack) => Container(
                          height: 200.h,
                          child: Center(
                            child: Text(
                              'Lỗi: ${err.toString()}',
                              style: TextStyle(color: AppTheme.textSecondary),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, stack) => _buildError(context, err.toString()),
          ),
        ),
      ),
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
