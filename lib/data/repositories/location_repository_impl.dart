import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../models/location_model.dart';
import '../utils/location_exceptions.dart';

/// Implementation của LocationRepository
class LocationRepositoryImpl implements LocationRepository {
  final Dio _dio = Dio();
  static const String _geocodingBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';
  static const String _savedLocationKey = 'saved_location';

  @override
  Future<List<LocationEntity>> searchLocations(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      final response = await _dio.get(
        _geocodingBaseUrl,
        queryParameters: {
          'name': query,
          'count': 10,
          'language': 'en',
          'format': 'json',
        },
      );

      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>?;

      if (results == null || results.isEmpty) {
        return [];
      }

      return results
          .map((json) => LocationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search locations: $e');
    }
  }

  @override
  Future<LocationEntity?> getCurrentLocation() async {
    try {
      // Kiểm tra dịch vụ vị trí có bật không
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw AppLocationServiceDisabledException();
      }

      // Kiểm tra quyền truy cập vị trí
      LocationPermission permission = await Geolocator.checkPermission();
      
      // Nếu chưa có quyền, yêu cầu quyền
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw AppLocationPermissionDeniedException();
        }
      }

      // Nếu bị từ chối vĩnh viễn, cần mở settings
      if (permission == LocationPermission.deniedForever) {
        throw AppLocationPermissionDeniedForeverException();
      }

      // Lấy vị trí hiện tại
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      // Reverse geocoding để lấy tên địa điểm thực tế
      // Sử dụng Nominatim (OpenStreetMap) API để reverse geocoding
      try {
        final reverseResponse = await _dio.get(
          'https://nominatim.openstreetmap.org/reverse',
          queryParameters: {
            'lat': position.latitude,
            'lon': position.longitude,
            'format': 'json',
            'addressdetails': 1,
            'accept-language': 'vi,en',
          },
          options: Options(
            headers: {
              'User-Agent': 'Atmos Care Weather App',
            },
          ),
        );

        final reverseData = reverseResponse.data as Map<String, dynamic>;
        final address = reverseData['address'] as Map<String, dynamic>?;

        if (address != null) {
          // Lấy tên địa điểm từ address
          final name = address['city'] as String? ??
              address['town'] as String? ??
              address['village'] as String? ??
              address['municipality'] as String? ??
              address['county'] as String? ??
              address['state'] as String? ??
              'Unknown Location';

          final admin1 = address['state'] as String? ??
              address['region'] as String?;
          final admin2 = address['city'] as String? ??
              address['town'] as String? ??
              address['municipality'] as String?;
          final country = address['country'] as String?;
          final countryCode = (address['country_code'] as String?)?.toUpperCase();

          return LocationModel(
            id: DateTime.now().millisecondsSinceEpoch, // Generate unique ID
            name: name,
            latitude: position.latitude,
            longitude: position.longitude,
            elevation: position.altitude,
            country: country,
            countryCode: countryCode,
            admin1: admin1,
            admin2: admin2,
          );
        }
      } catch (e) {
        // Nếu reverse geocoding fail, tạo location với tên từ tọa độ
      }

      // Fallback: tạo location với tên từ tọa độ
      return LocationModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}',
        latitude: position.latitude,
        longitude: position.longitude,
        elevation: position.altitude,
      );
    } on AppLocationServiceDisabledException {
      rethrow;
    } on AppLocationPermissionDeniedException {
      rethrow;
    } on AppLocationPermissionDeniedForeverException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  @override
  Future<void> saveSelectedLocation(LocationEntity location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> json;
      
      if (location is LocationModel) {
        json = location.toJson();
      } else {
        // Convert LocationEntity sang JSON
        json = {
          'id': location.id,
          'name': location.name,
          'latitude': location.latitude,
          'longitude': location.longitude,
          'elevation': location.elevation,
          'country': location.country,
          'country_code': location.countryCode,
          'admin1': location.admin1,
          'admin2': location.admin2,
          'timezone': location.timezone,
        };
      }
      
      await prefs.setString(_savedLocationKey, jsonEncode(json));
    } catch (e) {
      throw Exception('Failed to save location: $e');
    }
  }

  @override
  Future<LocationEntity?> getSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_savedLocationKey);
      if (jsonString == null) {
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return LocationModel.fromSavedJson(json);
    } catch (e) {
      return null;
    }
  }
}

