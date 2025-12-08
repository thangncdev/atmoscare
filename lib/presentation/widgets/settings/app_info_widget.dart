import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/screen_util_helper.dart';
import '../../core/theme.dart';

/// Widget hiển thị thông tin app ở cuối Settings
class AppInfoWidget extends StatelessWidget {
  const AppInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Column(
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.splashGradient,
                  ),
                  child: Icon(
                    Icons.location_on,
                    size: 32.w,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'AtmosCare',
                  style: AppTheme.titleSmall,
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.weatherAndAirQuality,
                  style: AppTheme.settingItemSubtitle,
                ),
                SizedBox(height: 24.h),
                Text(
                  l10n.allRightsReserved,
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

