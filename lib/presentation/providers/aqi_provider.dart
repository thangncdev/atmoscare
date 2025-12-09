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

