import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/utils/location_exceptions.dart';

/// Provider cho LocationRepository
final locationRepositoryProvider =
    Provider<LocationRepository>((ref) => LocationRepositoryImpl());

/// Loại lỗi location
enum LocationErrorType {
  none,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  other,
}

/// State class cho LocationProvider
class LocationState {
  final LocationEntity? currentLocation;
  final bool isLoading;
  final String? error;
  final LocationErrorType errorType;
  final List<LocationEntity> searchResults;

  const LocationState({
    this.currentLocation,
    this.isLoading = false,
    this.error,
    this.errorType = LocationErrorType.none,
    this.searchResults = const [],
  });

  LocationState copyWith({
    LocationEntity? currentLocation,
    bool? isLoading,
    String? error,
    LocationErrorType? errorType,
    List<LocationEntity>? searchResults,
  }) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      errorType: errorType ?? this.errorType,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}

/// Notifier cho quản lý location state
class LocationNotifier extends StateNotifier<LocationState> {
  final LocationRepository _repository;

  LocationNotifier(this._repository) : super(const LocationState()) {
    _initialize();
  }

  /// Khởi tạo: lấy location đã lưu hoặc vị trí hiện tại
  Future<void> _initialize() async {
    // Thử lấy location đã lưu trước
    final savedLocation = await _repository.getSavedLocation();
    if (savedLocation != null) {
      state = state.copyWith(currentLocation: savedLocation);
      return;
    }

    // Nếu không có location đã lưu, lấy vị trí hiện tại
    await getCurrentLocation();
  }

  /// Lấy vị trí hiện tại từ GPS
  Future<void> getCurrentLocation() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      errorType: LocationErrorType.none,
    );
    try {
      final location = await _repository.getCurrentLocation();
      if (location != null) {
        await _repository.saveSelectedLocation(location);
        state = state.copyWith(
          currentLocation: location,
          isLoading: false,
          error: null,
          errorType: LocationErrorType.none,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Không thể lấy vị trí hiện tại',
          errorType: LocationErrorType.other,
        );
      }
    } on AppLocationServiceDisabledException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        errorType: LocationErrorType.serviceDisabled,
      );
    } on AppLocationPermissionDeniedException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        errorType: LocationErrorType.permissionDenied,
      );
    } on AppLocationPermissionDeniedForeverException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        errorType: LocationErrorType.permissionDeniedForever,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        errorType: LocationErrorType.other,
      );
    }
  }

  /// Search locations
  Future<void> searchLocations(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(searchResults: []);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await _repository.searchLocations(query);
      state = state.copyWith(
        searchResults: results,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        searchResults: [],
      );
    }
  }

  /// Chọn location
  Future<void> selectLocation(LocationEntity location) async {
    try {
      await _repository.saveSelectedLocation(location);
      state = state.copyWith(
        currentLocation: location,
        searchResults: [],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Clear search results
  void clearSearchResults() {
    state = state.copyWith(searchResults: []);
  }
}

/// Provider cho LocationNotifier
final locationProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  final repository = ref.watch(locationRepositoryProvider);
  return LocationNotifier(repository);
});

/// Provider để lấy current location (nullable)
final currentLocationProvider = Provider<LocationEntity?>((ref) {
  return ref.watch(locationProvider).currentLocation;
});

