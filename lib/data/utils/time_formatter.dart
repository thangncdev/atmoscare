import 'package:intl/intl.dart';

/// Helper để format time từ unixtime và ISO8601
class TimeFormatter {
  /// Format unixtime sang HH:mm
  static String formatUnixTimeToHourMinute(int unixTime) {
    final date = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
    return DateFormat('HH:mm').format(date);
  }

  /// Format unixtime sang full date time string
  static String formatUnixTime(int unixTime, {String format = 'HH:mm'}) {
    final date = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
    return DateFormat(format).format(date);
  }

  /// Format ISO8601 time sang HH:mm
  static String formatISO8601ToHourMinute(String iso8601) {
    try {
      final date = DateTime.parse(iso8601);
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return '00:00';
    }
  }

  /// Format time cho "Bây giờ" hoặc "HH:mm"
  static String formatHourlyTime(int unixTime, {bool isNow = false}) {
    if (isNow) {
      return 'Bây giờ';
    }
    final date = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final forecastDate = DateTime(date.year, date.month, date.day);
    
    if (forecastDate == today) {
      return DateFormat('HH:mm').format(date);
    } else {
      return DateFormat('HH:mm').format(date);
    }
  }

  /// Format update time
  static String formatUpdateTime(int unixTime) {
    final date = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
    return DateFormat('HH:mm').format(date);
  }
}

