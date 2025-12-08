import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../providers/aqi_provider.dart';
import '../core/theme.dart';
import '../widgets/weather_icon.dart';
import '../widgets/aqi_color_bar.dart';

/// Màn hình trang chủ
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider);
    final hourlyForecastAsync = ref.watch(hourlyForecastProvider);
    final aqiAsync = ref.watch(currentAQIProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentWeatherProvider);
            ref.invalidate(hourlyForecastProvider);
            ref.invalidate(currentAQIProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context, weatherAsync),
                const SizedBox(height: 24),

                // Current Weather
                weatherAsync.when(
                  data: (weather) => _buildCurrentWeather(context, weather),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => _buildError(context, err.toString()),
                ),

                const SizedBox(height: 24),

                // Weather Parameters
                weatherAsync.when(
                  data: (weather) => _buildWeatherParameters(context, weather),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),

                const SizedBox(height: 24),

                // Sunrise/Sunset
                weatherAsync.when(
                  data: (weather) => _buildSunriseSunset(context, weather),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),

                const SizedBox(height: 24),

                // AQI Summary
                aqiAsync.when(
                  data: (aqi) => _buildAQISummary(context, aqi),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),

                const SizedBox(height: 24),

                // 24 Hour Forecast
                _build24HourForecast(context, hourlyForecastAsync),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AsyncValue weatherAsync) {
    return weatherAsync.when(
      data: (weather) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weather.location,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Cập nhật: ${weather.updateTime}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              // TODO: Implement location change
            },
          ),
        ],
      ),
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildCurrentWeather(BuildContext context, weather) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            WeatherIcon(iconName: weather.icon, size: 80),
            const SizedBox(height: 16),
            Text(
              '${weather.temperature.toInt()}°C',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppTheme.primaryColor,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              weather.condition,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cao: ${weather.tempHigh.toInt()}°',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(width: 16),
                Text(
                  'Thấp: ${weather.tempLow.toInt()}°',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cảm giác: ${weather.feelsLike.toInt()}°',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                Text(
                  'UV: ${weather.uvIndex}/11',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherParameters(BuildContext context, weather) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông số',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildParameterItem(
                    context,
                    Icons.water_drop,
                    'Độ ẩm',
                    '${weather.humidity}%',
                  ),
                ),
                Expanded(
                  child: _buildParameterItem(
                    context,
                    Icons.air,
                    'Gió',
                    '${weather.windSpeed.toInt()} km/h\n${weather.windDirection}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildParameterItem(
                    context,
                    Icons.visibility,
                    'Tầm nhìn',
                    '${weather.visibility.toInt()} km',
                  ),
                ),
                Expanded(
                  child: _buildParameterItem(
                    context,
                    Icons.compress,
                    'Áp suất',
                    '${weather.pressure.toInt()} hPa',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSunriseSunset(BuildContext context, weather) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSunItem(context, Icons.wb_twilight, 'Bình minh', weather.sunrise),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey[300],
            ),
            _buildSunItem(context, Icons.wb_twilight, 'Hoàng hôn', weather.sunset),
          ],
        ),
      ),
    );
  }

  Widget _buildSunItem(BuildContext context, IconData icon, String label, String time) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildAQISummary(BuildContext context, aqi) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chất lượng không khí',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.getAQIColor(aqi.aqi),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'AQI: ${aqi.aqi}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              aqi.status,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.getAQIColor(aqi.aqi),
                  ),
            ),
            const SizedBox(height: 12),
            AQIColorBar(aqi: aqi.aqi),
            const SizedBox(height: 12),
            Text(
              aqi.recommendations.isNotEmpty
                  ? aqi.recommendations.first
                  : 'Chất lượng không khí tốt, an toàn cho hoạt động ngoài trời',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _build24HourForecast(
    BuildContext context,
    AsyncValue hourlyForecastAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dự báo 24 giờ',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: hourlyForecastAsync.when(
            data: (hourly) => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourly.length,
              itemBuilder: (context, index) {
                final hour = hourly[index];
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            hour.time,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          WeatherIcon(iconName: hour.icon, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            '${hour.temperature.toInt()}°',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${hour.rainChance}%',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.blue,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text('Lỗi: ${err.toString()}'),
            ),
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

