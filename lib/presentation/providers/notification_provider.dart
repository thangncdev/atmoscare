import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmoscare/data/services/notification_service.dart';

/// Provider cho NotificationService
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

/// Provider cho notification enabled state
final notificationEnabledProvider =
    StateNotifierProvider<NotificationEnabledNotifier, AsyncValue<bool>>((ref) {
      final service = ref.watch(notificationServiceProvider);
      return NotificationEnabledNotifier(service);
    });

class NotificationEnabledNotifier extends StateNotifier<AsyncValue<bool>> {
  final NotificationService notificationService;

  NotificationEnabledNotifier(this.notificationService)
    : super(const AsyncValue.loading()) {
    loadEnabled();
  }

  Future<void> loadEnabled() async {
    try {
      final areNotificationsEnabled = await notificationService
          .areNotificationsEnabled();
      state = AsyncValue.data(areNotificationsEnabled);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> toggle({BuildContext? context}) async {
    if (state.isLoading) {
      await loadEnabled();
    }

    final currentValue = state.value ?? false;
    final newValue = !currentValue;

    if (newValue) {
      bool granted = await notificationService.initialize();
      state = AsyncValue.data(granted);
      
      // Show dialog if permission was denied and context is provided
      if (!granted && context != null && context.mounted) {
        await notificationService.showPermissionDeniedDialog(context);
      }
    } else {
      await notificationService.setNotificationsEnabled(newValue);
      state = AsyncValue.data(newValue);
    }
  }
}
