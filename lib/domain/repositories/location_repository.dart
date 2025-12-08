import '../../domain/entities/location_entity.dart';

/// Repository interface cho Location
abstract class LocationRepository {
  /// Search locations theo tên
  Future<List<LocationEntity>> searchLocations(String query);

  /// Lấy vị trí hiện tại từ GPS
  Future<LocationEntity?> getCurrentLocation();

  /// Lưu location đã chọn
  Future<void> saveSelectedLocation(LocationEntity location);

  /// Lấy location đã lưu
  Future<LocationEntity?> getSavedLocation();
}

