import '../../domain/entities/aqi_entity.dart';

/// Model cho chất lượng không khí
class AQIModel extends AQIEntity {
  const AQIModel({
    required super.aqi,
    required super.status,
    required super.location,
    required super.updateTime,
    required super.pollutants,
    required super.recommendations,
  });

  factory AQIModel.fromJson(Map<String, dynamic> json) {
    return AQIModel(
      aqi: json['aqi'] as int,
      status: json['status'] as String,
      location: json['location'] as String,
      updateTime: json['updateTime'] as String,
      pollutants: (json['pollutants'] as List)
          .map((e) => PollutantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendations: (json['recommendations'] as List)
          .map((e) => e as String)
          .toList(),
    );
  }
}

/// Model cho chất ô nhiễm
class PollutantModel extends PollutantEntity {
  const PollutantModel({
    required super.name,
    required super.value,
    required super.unit,
    required super.status,
  });

  factory PollutantModel.fromJson(Map<String, dynamic> json) {
    return PollutantModel(
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      status: json['status'] as String,
    );
  }
}

