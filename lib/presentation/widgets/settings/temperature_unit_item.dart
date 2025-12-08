import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/screen_util_helper.dart';
import '../../core/theme.dart';

/// Widget cho temperature unit setting với buttons
class TemperatureUnitItem extends StatelessWidget {
  final String currentUnit;
  final Function(String) onUnitChanged;
  final double delay;

  const TemperatureUnitItem({
    super.key,
    required this.currentUnit,
    required this.onUnitChanged,
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
                      Icons.thermostat,
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
                          l10n.temperatureUnit,
                          style: AppTheme.settingItemTitle,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          currentUnit == 'C' ? l10n.celsius : l10n.fahrenheit,
                          style: AppTheme.settingItemSubtitle,
                        ),
                      ],
                    ),
                  ),
                  // Unit buttons
                  Row(
                    children: [
                      _UnitButton(
                        label: '°C',
                        isSelected: currentUnit == 'C',
                        onTap: () => onUnitChanged('C'),
                      ),
                      SizedBox(width: 8.w),
                      _UnitButton(
                        label: '°F',
                        isSelected: currentUnit == 'F',
                        onTap: () => onUnitChanged('F'),
                      ),
                    ],
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

/// Unit button widget
class _UnitButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _UnitButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary500 : AppTheme.divider,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            label,
            style: (isSelected
                ? AppTheme.buttonLabelSelected
                : AppTheme.buttonLabelUnselected),
          ),
        ),
      ),
    );
  }
}
