import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../core/theme.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dự báo'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Toggle buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      context,
                      '24 giờ',
                      !_is24HourMode,
                      () => setState(() => _is24HourMode = false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildToggleButton(
                      context,
                      '7 ngày',
                      _is24HourMode,
                      () => setState(() => _is24HourMode = true),
                    ),
                  ),
                ],
              ),
            ),

            // Forecast list
            Expanded(
              child: _is24HourMode
                  ? _build24HourForecast(context)
                  : _build7DayForecast(context),
            ),
          ],
        ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _build24HourForecast(BuildContext context) {
    final hourlyAsync = ref.watch(hourlyForecastProvider);

    return hourlyAsync.when(
      data: (hourly) => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: hourly.length,
        itemBuilder: (context, index) {
          final hour = hourly[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      hour.time,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 16),
                  WeatherIcon(iconName: hour.icon, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${hour.temperature.toInt()}°C',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (hour.rainChance > 0)
                          Text(
                            'Mưa: ${hour.rainChance}%',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.blue,
                                ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text('Lỗi: ${err.toString()}'),
      ),
    );
  }

  Widget _build7DayForecast(BuildContext context) {
    final dailyAsync = ref.watch(dailyForecastProvider);

    return dailyAsync.when(
      data: (daily) => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: daily.length,
        itemBuilder: (context, index) {
          final day = daily[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day.day,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          day.date,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  WeatherIcon(iconName: day.icon, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (day.rainChance > 0)
                          Text(
                            'Mưa: ${day.rainChance}%',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.blue,
                                ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '${day.tempHigh.toInt()}° / ${day.tempLow.toInt()}°',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text('Lỗi: ${err.toString()}'),
      ),
    );
  }
}

