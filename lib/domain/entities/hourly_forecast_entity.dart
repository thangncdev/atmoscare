/// Entity cho dự báo theo giờ
class HourlyForecastEntity {
  final String time;
  final String icon;
  final double temperature;
  final int rainChance;

  const HourlyForecastEntity({
    required this.time,
    required this.icon,
    required this.temperature,
    required this.rainChance,
  });
}

