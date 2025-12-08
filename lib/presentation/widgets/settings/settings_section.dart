import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// Widget cho section trong Settings
class SettingsSection extends StatelessWidget {
  final List<Widget> children;
  final double delay;

  const SettingsSection({super.key, required this.children, this.delay = 0});

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
            offset: Offset(0, (1 - value) * -100),
            child: Padding(
              padding: AppTheme.paddingHorizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [...children],
              ),
            ),
          ),
        );
      },
    );
  }
}
