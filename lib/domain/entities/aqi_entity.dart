/// Entity cho chỉ số chất lượng không khí
class AQIEntity {
  final int aqi;
  final String status;
  final String location;
  final String updateTime;
  final List<PollutantEntity> pollutants;
  final List<String> recommendations;

  const AQIEntity({
    required this.aqi,
    required this.status,
    required this.location,
    required this.updateTime,
    required this.pollutants,
    required this.recommendations,
  });
}

/// Entity cho từng chất ô nhiễm
class PollutantEntity {
  final String name;
  final double value;
  final String unit;
  final String status;

  const PollutantEntity({
    required this.name,
    required this.value,
    required this.unit,
    required this.status,
  });
}

