import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';
import '../../l10n/app_localizations.dart';

/// Widget header cho màn hình forecast với gradient và animated particles
class ForecastHeaderWidget extends StatelessWidget {
  const ForecastHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppTheme.radiusHeaderGradient,
        gradient: AppTheme.skyGradient,
      ),
      child: Stack(
        children: [
          // Animated particles
          ...List.generate(5, (index) {
            return Positioned(
              left:
                  ((20 + index * 15) / 100 * MediaQuery.of(context).size.width),
              top:
                  ((30 + index * 10) /
                  100 *
                  MediaQuery.of(context).size.height),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 3 + index),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, math.sin(value * 2 * math.pi) * 20),
                    child: Opacity(
                      opacity: (0.2 + (math.sin(value * 2 * math.pi) * 0.3))
                          .clamp(0.0, 1.0),
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          // Header content
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 56.h, 24.w, 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(l10n.weatherForecast, style: AppTheme.headerTitle),
                SizedBox(height: 8.h),
                Text(l10n.detailsForNext7Days, style: AppTheme.headerSubtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
