import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Widget hiển thị thanh màu AQI
class AQIColorBar extends StatelessWidget {
  final int aqi;
  final double height;

  const AQIColorBar({
    super.key,
    required this.aqi,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.getAQIGradient();
    final double position = _getPosition(aqi);

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: colors,
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: position * MediaQuery.of(context).size.width * 0.9,
            child: Container(
              width: 3,
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getPosition(int aqi) {
    // AQI từ 0-300, map về 0-1
    if (aqi <= 50) return aqi / 50 * 0.2;
    if (aqi <= 100) return 0.2 + (aqi - 50) / 50 * 0.2;
    if (aqi <= 150) return 0.4 + (aqi - 100) / 50 * 0.2;
    if (aqi <= 200) return 0.6 + (aqi - 150) / 50 * 0.2;
    return 0.8 + ((aqi - 200) / 100 * 0.2).clamp(0.0, 0.2);
  }
}

