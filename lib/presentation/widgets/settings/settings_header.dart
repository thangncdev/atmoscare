import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/screen_util_helper.dart';
import '../../core/theme.dart';
import 'grid_pattern_painter.dart';

/// Header widget cho Settings screen
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: AppTheme.skyGradient),
      child: Stack(
        children: [
          // Grid pattern background
          Positioned.fill(child: CustomPaint(painter: GridPatternPainter())),
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settings,
                    style: AppTheme.headerTitle.copyWith(fontSize: 24.sp),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    l10n.customizeApp,
                    style: AppTheme.headerSubtitle.copyWith(fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
