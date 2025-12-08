import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/aqi_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../data/repositories/aqi_repository_impl.dart';
import 'location_provider.dart';
import 'locale_provider.dart';

/// Provider cho AQIRepository
final aqiRepositoryProvider = Provider<AQIRepository>((ref) {
  return AQIRepositoryImpl();
});

/// Provider cho AQI hiện tại
final currentAQIProvider = FutureProvider<AQIEntity>((ref) async {
  final repository = ref.watch(aqiRepositoryProvider);
  final location = ref.watch(currentLocationProvider);
  final locale = ref.watch(localeProvider);
  return await repository.getCurrentAQI(location: location, locale: locale);
});

/// Provider cho trạng thái cảnh báo AQI
final aqiAlertEnabledProvider =
    StateNotifierProvider<AQIAlertNotifier, bool>((ref) {
  return AQIAlertNotifier(ref.watch(aqiRepositoryProvider));
});

/// Notifier cho quản lý trạng thái cảnh báo AQI
class AQIAlertNotifier extends StateNotifier<bool> {
  final AQIRepository _repository;

  AQIAlertNotifier(this._repository) : super(false) {
    _loadAlertStatus();
  }

  Future<void> _loadAlertStatus() async {
    state = await _repository.getAQIAlertEnabled();
  }

  Future<void> setEnabled(bool enabled) async {
    await _repository.setAQIAlertEnabled(enabled);
    state = enabled;
  }
}

