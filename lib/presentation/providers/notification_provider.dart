import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/notification_service.dart';

/// Provider cho NotificationService
final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

/// Provider cho notification enabled state
final notificationEnabledProvider =
    StateNotifierProvider<NotificationEnabledNotifier, AsyncValue<bool>>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return NotificationEnabledNotifier(service);
});

class NotificationEnabledNotifier extends StateNotifier<AsyncValue<bool>> {
  final NotificationService _service;

  NotificationEnabledNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadEnabled();
  }

  Future<void> _loadEnabled() async {
    try {
      final enabled = await _service.isNotificationEnabled();
      state = AsyncValue.data(enabled);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> toggle() async {
    // Đảm bảo state đã được load
    if (state.isLoading) {
      await _loadEnabled();
    }
    
    // Lấy giá trị thực tế từ state hoặc từ service
    final currentValue = state.value ?? await _service.isNotificationEnabled();
    final newValue = !currentValue;
    
    // Nếu đang bật notification, cần khởi tạo và check permission
    if (newValue) {
      await _service.initialize();
      final hasPermission = await _service.checkPermissionStatus();
      if (!hasPermission) {
        // Request permission nếu chưa có
        final granted = await _service.requestPermission();
        if (!granted) {
          // Nếu không được cấp quyền, không bật notification
          return;
        }
      }
    }
    
    // Update state trước
    state = AsyncValue.data(newValue);
    
    try {
      await _service.setNotificationEnabled(newValue);
    } catch (e, stackTrace) {
      // Revert nếu có lỗi
      state = AsyncValue.data(currentValue);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> setEnabled(bool enabled) async {
    // Nếu đang bật notification, cần khởi tạo và check permission
    if (enabled) {
      await _service.initialize();
      final hasPermission = await _service.checkPermissionStatus();
      if (!hasPermission) {
        // Request permission nếu chưa có
        final granted = await _service.requestPermission();
        if (!granted) {
          // Nếu không được cấp quyền, không bật notification
          return;
        }
      }
    }
    
    state = AsyncValue.data(enabled);
    
    try {
      await _service.setNotificationEnabled(enabled);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

