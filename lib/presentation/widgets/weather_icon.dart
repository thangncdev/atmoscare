import 'package:flutter/material.dart';

/// Widget hiển thị icon thời tiết
class WeatherIcon extends StatelessWidget {
  final String iconName;
  final double size;

  const WeatherIcon({
    super.key,
    required this.iconName,
    this.size = 48,
  });

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
        iconColor = Colors.grey;
        break;
      case 'cloudy':
        iconData = Icons.cloud;
        iconColor = Colors.grey;
        break;
      case 'rainy':
        iconData = Icons.grain;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.wb_sunny;
        iconColor = Colors.amber;
    }

    return Icon(
      iconData,
      size: size,
      color: iconColor,
    );
  }
}

