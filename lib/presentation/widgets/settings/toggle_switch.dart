import 'package:flutter/material.dart';
import '../../core/screen_util_helper.dart';
import '../../core/theme.dart';

/// Custom toggle switch widget
class ToggleSwitch extends StatelessWidget {
  final bool enabled;
  final VoidCallback onToggle;

  const ToggleSwitch({
    super.key,
    required this.enabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 56.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: enabled ? AppTheme.primary500 : AppTheme.border,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: enabled ? 28.w : 4.w,
              top: 4.h,
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

