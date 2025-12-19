import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/core/theme.dart';
import '../repositories/location_repository_impl.dart';
import '../utils/aqi_helper.dart';
import '../utils/weather_code_mapper.dart';
import '../../constants/location.dart';

final List<String> dailyNotificationTitlesVietnamese = [
  'Hôm nay thời tiết thế nào?',
  'Chào buổi sáng 🌅',
  'Nhắc bạn xem thời tiết hôm nay',
  'Thời tiết hôm nay đã sẵn sàng!',
  'Kiểm tra thời tiết trước khi ra ngoài',
  'Đừng để thời tiết làm bạn bất ngờ',
  'Hôm nay bạn đã xem thời tiết chưa?',
  'Bản tin thời tiết hôm nay',
  'Thời tiết & sức khỏe hôm nay',
  'Chuẩn bị cho một ngày mới an toàn',
];

final List<String> dailyNotificationTitlesEnglish = [
  'What\'s the weather like today?',
  'Good morning 🌅',
  'Remind you to check the weather today',
  'The weather today is ready!',
  'Check the weather before going outside',
  'Don\'t let the weather surprise you',
  'Have you checked the weather today?',
  'The weather forecast for today',
  'Weather & health today',
  'Prepare for a safe day',
];

final List<String> dailyNotificationBodiesVietnamese = [
  'Mở app để xem dự báo thời tiết và chất lượng không khí hôm nay nhé!',
  'Chỉ mất 10 giây để biết hôm nay nắng, mưa hay UV cao.',
  'Xem trước thời tiết để chủ động bảo vệ sức khỏe nhé.',
  'Thời tiết & không khí có thể ảnh hưởng đến bạn hôm nay. Kiểm tra ngay!',
  'Trước khi ra ngoài, đừng quên kiểm tra nhiệt độ, mưa và chỉ số UV.',
  'Chuẩn bị ô, áo chống nắng hay khẩu trang từ sớm nhé!',
  'Một ngày an toàn bắt đầu từ việc xem thời tiết.',
  'Biết trước thời tiết sẽ giúp bạn thoải mái hơn cả ngày.',
  'Thói quen nhỏ cho sức khỏe lớn – mở app xem thời tiết ngay!',
  'Cập nhật nhanh thời tiết hôm nay chỉ với 1 chạm.',
];

final List<String> dailyNotificationBodiesEnglish = [
  'Open the app to view the weather forecast and air quality for today!',
  'It only takes 10 seconds to know if today is sunny, rainy, or UV high.',
  'Check the weather before going outside to proactively protect your health.',
  'The weather & air can affect you today. Check now!',
  'Before going outside, don\'t forget to check the temperature, rain, and UV index.',
  'Prepare your umbrella, sun protection, or face mask early!',
  'A safe day starts with checking the weather.',
  'Knowing the weather will make you more comfortable all day long.',
  'A small habit for big health – open the app to check the weather now!',
  'Update the weather for today with just one tap.',
];

/// Service for managing local notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _showDialogRequestNotiKey = 'showDialogRequestNotiKey';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const int _weatherAlertReminderId = 1;
  static const int id = 99;

  final Dio _dio = Dio();
  final LocationRepositoryImpl _locationRepository = LocationRepositoryImpl();

  // Default location: Hanoi
  static double defaultLatitude = LocationConstants.defaultPosition.latitude;
  static double defaultLongitude = LocationConstants.defaultPosition.longitude;

  /// Initialize notification service
  Future<bool> initialize() async {
    try {
      // Initialize timezone
      tz.initializeTimeZones();

      final TimezoneInfo timeZone = await FlutterTimezone.getLocalTimezone();

      tz.setLocalLocation(tz.getLocation(timeZone.identifier));

      // Android initialization settings
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Request permissions
      final granted = await _requestPermissions();
      if (granted) {
        await setNotificationsEnabled(true);
        return true;
      } else {
        await setNotificationsEnabled(false);
        return false;
      }
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
      return false;
    }
  }

  /// Request notification permissions
  Future<bool> _requestPermissions() async {
    if (Platform.isIOS) {
      final granted = await _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      final granted = await androidImplementation
          ?.requestNotificationsPermission();
      return granted ?? false;
    }
    return false;
  }

  /// Show dialog when notification permission is denied
  /// This should be called when _requestPermissions() returns false
  Future<void> showPermissionDeniedDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.notificationPermissionDenied),
        content: Text(l10n.notificationPermissionDeniedMessage),
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radius2xl),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await openAppSettings();
            },
            child: Text(l10n.openSettings),
          ),
        ],
      ),
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle navigation if needed
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_notificationsEnabledKey) ?? false;
    } catch (e) {
      debugPrint('Error checking notification status: $e');
      return true;
    }
  }

  Future<bool> isShowedDialogRequestNoti() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_showDialogRequestNotiKey) ?? false;
    } catch (e) {
      debugPrint('Error checking showed dialog request notification: $e');
      return true;
    }
  }

  Future<void> setShowedDialogRequestNoti() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_showDialogRequestNotiKey, true);
    } catch (e) {
      debugPrint('Error setting showed dialog request notification: $e');
    }
  }

  /// Enable or disable notifications
  Future<void> setNotificationsEnabled(bool enabled, {Locale? locale}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsEnabledKey, enabled);

      if (enabled) {
        await scheduleWeatherAlertReminder(locale: locale);
      } else {
        await cancelWeatherAlertReminder();
      }
    } catch (e) {
      debugPrint('Error setting notification status: $e');
    }
  }

  /// Fetch weather data for a specific day (0 = today, 1 = tomorrow)
  Future<Map<String, dynamic>?> _fetchWeatherData({int dayOffset = 0}) async {
    try {
      final location = await _locationRepository.getSavedLocation();
      final lat = location?.latitude ?? defaultLatitude;
      final lon = location?.longitude ?? defaultLongitude;

      // Fetch forecast for the next few days to get the target day
      final response = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'daily':
              'weather_code,temperature_2m_max,temperature_2m_min,uv_index_max',
          'timeformat': 'unixtime',
          'timezone': 'auto',
          'forecast_days':
              dayOffset + 1, // Fetch enough days to include target day
        },
      );

      final data = response.data as Map<String, dynamic>;
      final daily = data['daily'] as Map<String, dynamic>;

      // Get data for the target day (dayOffset)
      final index = dayOffset;
      final weatherCodes = daily['weather_code'] as List;
      final tempMaxs = daily['temperature_2m_max'] as List;
      final tempMins = daily['temperature_2m_min'] as List;
      final uvIndexes = daily['uv_index_max'] as List;

      if (index >= weatherCodes.length) {
        debugPrint('Day offset $dayOffset is out of range');
        return null;
      }

      return {
        'weather_code': weatherCodes[index] as int,
        'temp_max': tempMaxs[index] as num,
        'temp_min': tempMins[index] as num,
        'uv_index_max': uvIndexes[index] as num,
      };
    } catch (e) {
      debugPrint('Error fetching weather data: $e');
      return null;
    }
  }

  /// Fetch current AQI data
  Future<int?> _fetchAQIData() async {
    try {
      final location = await _locationRepository.getSavedLocation();
      final lat = location?.latitude ?? defaultLatitude;
      final lon = location?.longitude ?? defaultLongitude;

      final response = await _dio.get(
        'https://air-quality-api.open-meteo.com/v1/air-quality',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'timezone': 'auto',
          'current': 'us_aqi',
        },
      );

      final data = response.data as Map<String, dynamic>;
      final current = data['current'] as Map<String, dynamic>;
      return (current['us_aqi'] as num?)?.toInt();
    } catch (e) {
      debugPrint('Error fetching AQI data: $e');
      return null;
    }
  }

  /// Check if weather code indicates rain
  bool _isRainy(int weatherCode) {
    // Weather codes for rain: 51-67 (drizzle/rain), 80-82 (rain showers), 95-99 (thunderstorms)
    return (weatherCode >= 51 && weatherCode <= 67) ||
        (weatherCode >= 80 && weatherCode <= 82) ||
        (weatherCode >= 95 && weatherCode <= 99);
  }

  /// Generate notification message based on weather conditions
  Future<Map<String, String>> _generateWeatherAlertMessage(
    Map<String, dynamic>? weatherData,
    int? aqi,
    Locale? locale,
  ) async {
    final isVietnamese = locale == null || locale.languageCode == 'vi';

    if (weatherData == null || aqi == null) {
      return {
        'title': await _getNotificationTitle(isVietnamese),
        'body': await _getNotificationBody(isVietnamese),
      };
    }

    final weatherCode = weatherData['weather_code'] as int;
    final tempMin = (weatherData['temp_min'] as num).toDouble();
    final uvIndex = (weatherData['uv_index_max'] as num).toDouble();
    final isRain = _isRainy(weatherCode);
    final isLowTemp = tempMin < 13;
    final isHighUV = uvIndex > 7;
    final isHighAQI = aqi > 150;

    // Check for unsafe conditions
    final List<String> warnings = [];

    if (isHighAQI) {
      final aqiStatus = AQIHelper.getAQIStatus(aqi, locale: locale);
      warnings.add(
        isVietnamese
            ? 'Chất lượng không khí: $aqiStatus (AQI: $aqi). Hãy đeo khẩu trang khi ra ngoài!'
            : 'Air quality: $aqiStatus (AQI: $aqi). Please wear a mask when going outside!',
      );
    }
    if (isRain) {
      warnings.add(
        isVietnamese
            ? 'Trời có mưa. Hãy mang ô mưa khi ra ngoài!'
            : 'Rain expected. Please bring an umbrella when going outside!',
      );
    }
    if (isLowTemp) {
      warnings.add(
        isVietnamese
            ? 'Nhiệt độ thấp nhất $tempMin°C. Hãy giữ ấm khi ra ngoài!'
            : 'Low temperature ($tempMin°C). Please keep warm when going outside!',
      );
    }
    if (isHighUV) {
      warnings.add(
        isVietnamese
            ? 'Chỉ số UV cao $uvIndex. Hãy tránh đi ngoài trời khi UV cao!'
            : 'High UV index $uvIndex. Please avoid going outside when UV is high!',
      );
    }

    if (warnings.isNotEmpty) {
      // Unsafe conditions - show warning
      final title = isVietnamese ? 'Cảnh báo thời tiết' : 'Weather Alert';
      final body = warnings[0];

      return {'title': title, 'body': body};
    } else {
      // Safe conditions - show positive message
      final title = isVietnamese ? 'Thời tiết hôm nay' : 'Today\'s Weather';
      final tempMax = (weatherData['temp_max'] as num).toDouble();
      final weatherDesc = WeatherCodeMapper.getDescriptionFromCode(
        weatherCode,
        locale: locale,
      );
      final body = isVietnamese
          ? '$weatherDesc. Nhiệt độ: ${tempMin.toStringAsFixed(0)}-${tempMax.toStringAsFixed(0)}°C. Thời tiết đẹp, phù hợp cho hoạt động ngoài trời!'
          : '$weatherDesc. Temperature: ${tempMin.toStringAsFixed(0)}-${tempMax.toStringAsFixed(0)}°C. Nice weather, perfect for outdoor activities!';

      return {'title': title, 'body': body};
    }
  }

  /// Schedule weather alert reminder that checks weather conditions
  /// This will fetch weather data and send notification at scheduled time
  Future<void> scheduleWeatherAlertReminder({Locale? locale}) async {
    try {
      // Cancel existing reminder first
      await cancelWeatherAlertReminder();

      // Schedule for 8 AM daily
      final scheduledTime = tz.TZDateTime(
        tz.local,
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        6, // 8 AM
        0,
      );

      // If the time has passed today, schedule for tomorrow
      final now = tz.TZDateTime.now(tz.local);
      final isTomorrow = scheduledTime.isBefore(now);
      final timeToSchedule = isTomorrow
          ? scheduledTime.add(const Duration(days: 1))
          : scheduledTime;

      // Fetch weather data for the day the notification is scheduled for
      // dayOffset: 0 = today, 1 = tomorrow
      final message = await _generateWeatherAlertMessage(null, null, locale);

      // Android notification details
      const androidDetails = AndroidNotificationDetails(
        'weather_alert',
        'Cảnh báo thời tiết',
        channelDescription:
            'Thông báo cảnh báo thời tiết và chất lượng không khí',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false,
      );

      // iOS notification details
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.zonedSchedule(
        _weatherAlertReminderId,
        message['title'] ?? 'Weather Alert',
        message['body'] ?? 'Check today\'s weather conditions',
        timeToSchedule,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Weather alert reminder scheduled for 8 AM');
    } catch (e) {
      debugPrint('Error scheduling weather alert reminder: $e');
    }
  }

  /// Cancel weather alert reminder
  Future<void> cancelWeatherAlertReminder() async {
    try {
      await _notifications.cancel(_weatherAlertReminderId);
      debugPrint('Weather alert reminder cancelled');
    } catch (e) {
      debugPrint('Error cancelling weather alert reminder: $e');
    }
  }

  /// Get notification title based on locale
  Future<String> _getNotificationTitle(bool isVietnamese) async {
    return isVietnamese
        ? dailyNotificationTitlesVietnamese[Random().nextInt(
            dailyNotificationTitlesVietnamese.length,
          )]
        : dailyNotificationTitlesEnglish[Random().nextInt(
            dailyNotificationTitlesEnglish.length,
          )];
  }

  /// Get notification body - check if there are transactions today
  Future<String> _getNotificationBody(bool isVietnamese) async {
    return isVietnamese
        ? dailyNotificationBodiesVietnamese[Random().nextInt(
            dailyNotificationBodiesVietnamese.length,
          )]
        : dailyNotificationBodiesEnglish[Random().nextInt(
            dailyNotificationBodiesEnglish.length,
          )];
  }

  /// Show immediate notification (for testing)
  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await _notifications.show(
      id,
      'plain title',
      'plain body',
      notificationDetails,
      payload: 'item x',
    );
  }

  Future<void> showWeatherAlertNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    final weatherData = await _fetchWeatherData(dayOffset: 0);
    final aqi = await _fetchAQIData();
    final message = await _generateWeatherAlertMessage(weatherData, aqi, null);

    await _notifications.show(
      id,
      message['title'],
      message['body'],
      notificationDetails,
    );
  }
}
