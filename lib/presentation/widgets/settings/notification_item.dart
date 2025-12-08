import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/screen_util_helper.dart';
import '../../core/theme.dart';
import 'toggle_switch.dart';

/// Widget cho notification setting với toggle
class NotificationItem extends StatelessWidget {
  final bool enabled;
  final VoidCallback onToggle;
  final double delay;

  const NotificationItem({
    super.key,
    required this.enabled,
    required this.onToggle,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (delay * 1000).toInt()),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * -10, 0),
            child: Container(
              padding: EdgeInsets.all(16.w),
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primary100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: AppTheme.primary700,
                      size: 24.w,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.weatherNotifications,
                          style: AppTheme.settingItemTitle,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          l10n.badWeatherAndHighAQIAlerts,
                          style: AppTheme.settingItemSubtitle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Toggle
                  ToggleSwitch(
                    enabled: enabled,
                    onToggle: onToggle,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

