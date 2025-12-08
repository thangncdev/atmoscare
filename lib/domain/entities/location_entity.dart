/// Entity cho thông tin vị trí
class LocationEntity {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double? elevation;
  final String? country;
  final String? countryCode;
  final String? admin1; // Province/State
  final String? admin2; // District/City
  final String? timezone;

  const LocationEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.elevation,
    this.country,
    this.countryCode,
    this.admin1,
    this.admin2,
    this.timezone,
  });

  /// Tạo display name cho location
  String get displayName {
    final parts = <String>[name];
    if (admin2 != null && admin2 != name) {
      parts.add(admin2!);
    }
    if (admin1 != null) {
      parts.add(admin1!);
    }
    if (country != null) {
      parts.add(country!);
    }
    return parts.join(', ');
  }

  /// Tạo short display name (chỉ name và admin1)
  String get shortDisplayName {
    if (admin1 != null && admin1 != name) {
      return '$name, $admin1';
    }
    return name;
  }
}

