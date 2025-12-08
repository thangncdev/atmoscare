import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../core/theme.dart';
import '../core/screen_util_helper.dart';

/// Widget hiển thị card bình minh/hoàng hôn
class SunriseSunsetCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final Color startColor;
  final Color endColor;

  const SunriseSunsetCard({
    super.key,
    required this.icon,
    required this.label,
    required this.time,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppTheme.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [startColor, endColor],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: startColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24.w),
              ),
              SizedBox(width: 12.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      time,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            height: 4.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [startColor, Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget hiển thị 2 card bình minh và hoàng hôn
class SunriseSunsetRow extends StatelessWidget {
  final String sunrise;
  final String sunset;

  const SunriseSunsetRow({
    super.key,
    required this.sunrise,
    required this.sunset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: SunriseSunsetCard(
            icon: Icons.wb_twilight,
            label: l10n.sunrise,
            time: sunrise,
            startColor: const Color(0xFFFFA726),
            endColor: const Color(0xFFFF6F00),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: SunriseSunsetCard(
            icon: Icons.wb_twilight,
            label: l10n.sunset,
            time: sunset,
            startColor: const Color(0xFFFF6B6B),
            endColor: const Color(0xFFEE5A6F),
          ),
        ),
      ],
    );
  }
}

