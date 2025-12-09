import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service để quản lý local notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  
  static const String _notificationEnabledKey = 'notification_enabled';
  static const String _localeKey = 'app_locale';
  static const String _permissionRequestedKey = 'notification_permission_requested';
  static const String _permissionGrantedKey = 'notification_permission_granted';
  static const int _dailyReminderId = 1;
  
  bool _isInitialized = false;
  bool _timezoneInitialized = false;

  /// Khởi tạo timezone database (nếu chưa khởi tạo)
  void _ensureTimezoneInitialized() {
    if (!_timezoneInitialized) {
      tz.initializeTimeZones();
      _timezoneInitialized = true;
    }
  }

  /// Khởi tạo notification service (chỉ khởi tạo một lần)
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Khởi tạo timezone
    _ensureTimezoneInitialized();
    
    // Cấu hình Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // Cấu hình iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // Không request tự động
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    _isInitialized = true;
  }

  /// Request permission cho notifications
  Future<bool> _requestPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }

    // iOS permission được request trong initialization settings
    return true;
  }

  /// Kiểm tra xem notification có được bật không
  Future<bool> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationEnabledKey) ?? true; // Mặc định là true
  }

  /// Bật/tắt notifications
  Future<void> setNotificationEnabled(bool enabled) async {
    // Đảm bảo service đã được khởi tạo
    await initialize();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, enabled);

    if (enabled) {
      await scheduleDailyReminder();
    } else {
      await cancelDailyReminder();
    }
  }

  /// Lấy locale đã lưu
  Future<String> _getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeKey) ?? 'vi'; // Mặc định là tiếng Việt
  }

  /// Lưu locale
  Future<void> setLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale);
  }

  /// Lấy timezone của device
  tz.Location _getDeviceTimezone() {
    // Đảm bảo timezone đã được khởi tạo
    _ensureTimezoneInitialized();
    
    try {
      return tz.local;
    } catch (e) {
      // Fallback về timezone mặc định
      return tz.getLocation('Asia/Ho_Chi_Minh');
    }
  }

  /// Lấy notification messages theo locale
  Future<Map<String, String>> _getNotificationMessages() async {
    final locale = await _getLocale();
    
    if (locale == 'en') {
      return {
        'title': 'Check today\'s weather',
        'body': 'Check the weather forecast to plan for a great day!',
        'channelName': 'Daily Reminder',
        'channelDescription': 'Daily weather reminder notifications',
      };
    } else {
      return {
        'title': 'Kiểm tra thời tiết hôm nay',
        'body': 'Hãy xem dự báo thời tiết để có kế hoạch cho một ngày!',
        'channelName': 'Nhắc nhở hàng ngày',
        'channelDescription': 'Thông báo nhắc nhở kiểm tra thời tiết hàng ngày',
      };
    }
  }

  /// Lên lịch thông báo hàng ngày lúc 7h sáng
  Future<void> scheduleDailyReminder() async {
    // Hủy thông báo cũ nếu có
    await cancelDailyReminder();

    // Lấy timezone của device
    final location = _getDeviceTimezone();
    
    // Lên lịch cho 7h sáng hôm nay hoặc ngày mai nếu đã qua 7h
    final now = tz.TZDateTime.now(location);
    var scheduledDate = tz.TZDateTime(
      location,
      now.year,
      now.month,
      now.day,
      7,
      0,
    );

    // Nếu đã qua 7h hôm nay, lên lịch cho ngày mai
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Lấy messages theo locale
    final messages = await _getNotificationMessages();

    // Lên lịch thông báo lặp lại hàng ngày
    await _notifications.zonedSchedule(
      _dailyReminderId,
      messages['title']!,
      messages['body']!,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          messages['channelName']!,
          channelDescription: messages['channelDescription']!,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Lặp lại mỗi ngày cùng giờ
    );
  }

  /// Hủy thông báo hàng ngày
  Future<void> cancelDailyReminder() async {
    await _notifications.cancel(_dailyReminderId);
  }

  /// Xử lý khi người dùng tap vào notification
  void _onNotificationTapped(NotificationResponse response) {
    // Có thể navigate đến màn hình cụ thể nếu cần
    // Hiện tại chỉ cần log
    print('Notification tapped: ${response.payload}');
  }

  /// Kiểm tra xem đã request permission chưa
  Future<bool> hasRequestedPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_permissionRequestedKey) ?? false;
  }

  /// Đánh dấu đã request permission
  Future<void> markPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionRequestedKey, true);
  }

  /// Kiểm tra permission status thực tế từ hệ thống
  Future<bool> checkPermissionStatus() async {
    // Check permission thực tế từ hệ thống bằng permission_handler
    final status = await Permission.notification.status;
    final isGranted = status.isGranted;
    
    // Cập nhật cache để đồng bộ
    await _savePermissionStatus(isGranted);
    
    return isGranted;
  }

  /// Lưu trạng thái permission đã được cấp
  Future<void> _savePermissionStatus(bool granted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionGrantedKey, granted);
  }

  /// Request permission (gọi khi người dùng đồng ý)
  Future<bool> requestPermission() async {
    // Đảm bảo service đã được khởi tạo
    await initialize();
    
    final granted = await _requestPermissions();
    await markPermissionRequested();
    await _savePermissionStatus(granted);
    return granted;
  }
}

