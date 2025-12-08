import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/aqi_provider.dart';
import '../core/theme.dart';

/// Màn hình chất lượng không khí
class AQIScreen extends ConsumerWidget {
  const AQIScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aqiAsync = ref.watch(currentAQIProvider);
    final alertEnabled = ref.watch(aqiAlertEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chất lượng không khí'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentAQIProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: aqiAsync.when(
              data: (aqi) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AQI Circle
                  _buildAQICircle(context, aqi),
                  const SizedBox(height: 32),

                  // Location and Update Time
                  Center(
                    child: Column(
                      children: [
                        Text(
                          aqi.location,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Cập nhật: ${aqi.updateTime}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Health Recommendations
                  _buildRecommendations(context, aqi),
                  const SizedBox(height: 32),

                  // Detailed Pollutants
                  _buildPollutants(context, aqi),
                  const SizedBox(height: 32),

                  // Alert Switch
                  _buildAlertSwitch(context, alertEnabled, ref),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Lỗi: ${err.toString()}'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAQICircle(BuildContext context, aqi) {
    final aqiColor = AppTheme.getAQIColor(aqi.aqi);
    final progress = (aqi.aqi / 300).clamp(0.0, 1.0);

    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
            ),
            // Progress circle
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 20,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(aqiColor),
              ),
            ),
            // Center content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${aqi.aqi}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: aqiColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: aqiColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    aqi.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(BuildContext context, aqi) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Khuyến nghị sức khỏe',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...aqi.recommendations.map((recommendation) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          recommendation,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPollutants(BuildContext context, aqi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chỉ số chi tiết',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        ...aqi.pollutants.map((pollutant) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pollutant.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${pollutant.value} ${pollutant.unit}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getPollutantColor(pollutant.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        pollutant.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildAlertSwitch(
    BuildContext context,
    bool alertEnabled,
    WidgetRef ref,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cảnh báo AQI cao',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nhận thông báo khi AQI > 150',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Switch(
              value: alertEnabled,
              onChanged: (value) {
                ref.read(aqiAlertEnabledProvider.notifier).setEnabled(value);
              },
              activeThumbColor: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Color _getPollutantColor(String status) {
    switch (status) {
      case 'Tốt':
        return AppTheme.aqiGood;
      case 'Trung bình':
        return AppTheme.aqiModerate;
      case 'Không tốt':
        return AppTheme.aqiUnhealthy;
      default:
        return AppTheme.aqiGood;
    }
  }
}

