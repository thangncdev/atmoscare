/// Entity cho dự báo theo ngày
class DailyForecastEntity {
  final String day;
  final String date;
  final String icon;
  final String description;
  final int rainChance;
  final double tempHigh;
  final double tempLow;

  const DailyForecastEntity({
    required this.day,
    required this.date,
    required this.icon,
    required this.description,
    required this.rainChance,
    required this.tempHigh,
    required this.tempLow,
  });
}

