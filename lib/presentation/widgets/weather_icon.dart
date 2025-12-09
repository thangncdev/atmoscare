import 'package:atmoscare/presentation/core/theme.dart';
import 'package:flutter/material.dart';

/// Widget hiển thị icon thời tiết
class WeatherIcon extends StatelessWidget {
  final String iconName;
  final double size;

  const WeatherIcon({super.key, required this.iconName, this.size = 48});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;

    switch (iconName.toLowerCase()) {
      case 'sunny':
        iconData = Icons.wb_sunny;
        iconColor = Colors.amber;
        break;
      case 'partly_cloudy':
        iconData = Icons.wb_cloudy;
        iconColor = AppTheme.primary200;
        break;
      case 'cloudy':
        iconData = Icons.cloud;
        iconColor = AppTheme.primary200;
        break;
      case 'foggy':
        iconData = Icons.foggy;
        iconColor = AppTheme.textTertiary;
        break;
      case 'rainy':
        iconData = Icons.grain;
        iconColor = Colors.blue;
        break;
      case 'snowy':
        iconData = Icons.ac_unit;
        iconColor = Colors.lightBlue;
        break;
      case 'stormy':
        iconData = Icons.thunderstorm;
        iconColor = Colors.deepPurple;
        break;
      default:
        iconData = Icons.wb_sunny;
        iconColor = Colors.amber;
    }

    return Icon(iconData, size: size, color: iconColor);
  }
}
