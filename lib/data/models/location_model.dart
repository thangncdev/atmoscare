import '../../domain/entities/location_entity.dart';

/// Model cho Location từ API response
class LocationModel extends LocationEntity {
  const LocationModel({
    required super.id,
    required super.name,
    required super.latitude,
    required super.longitude,
    super.elevation,
    super.country,
    super.countryCode,
    super.admin1,
    super.admin2,
    super.timezone,
  });

  /// Parse từ JSON response của geocoding API
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      elevation: json['elevation'] != null
          ? (json['elevation'] as num).toDouble()
          : null,
      country: json['country'] as String?,
      countryCode: json['country_code'] as String?,
      admin1: json['admin1'] as String?,
      admin2: json['admin2'] as String?,
      timezone: json['timezone'] as String?,
    );
  }

  /// Convert sang JSON để lưu vào SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'elevation': elevation,
      'country': country,
      'country_code': countryCode,
      'admin1': admin1,
      'admin2': admin2,
      'timezone': timezone,
    };
  }

  /// Parse từ JSON đã lưu
  factory LocationModel.fromSavedJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      elevation: json['elevation'] != null
          ? (json['elevation'] as num).toDouble()
          : null,
      country: json['country'] as String?,
      countryCode: json['country_code'] as String?,
      admin1: json['admin1'] as String?,
      admin2: json['admin2'] as String?,
      timezone: json['timezone'] as String?,
    );
  }
}

