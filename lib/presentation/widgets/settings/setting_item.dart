import 'package:flutter/material.dart';
import '../../core/screen_util_helper.dart';
import '../../core/theme.dart';

/// Widget cho một setting item
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final double delay;
  final VoidCallback? onTap;
  final Widget? rightElement;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.delay = 0,
    this.onTap,
    this.rightElement,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (delay * 1000).toInt()),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * -10, 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(20.r),
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
                          icon,
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
                              title,
                              style: AppTheme.settingItemTitle,
                            ),
                            if (subtitle != null) ...[
                              SizedBox(height: 4.h),
                              Text(
                                subtitle!,
                                style: AppTheme.settingItemSubtitle,
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Right element (chevron or custom widget)
                      rightElement ??
                          Icon(
                            Icons.chevron_right,
                            color: AppTheme.textTertiary,
                            size: 20.w,
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

