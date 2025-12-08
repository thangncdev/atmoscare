// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get settings => 'Cài đặt';

  @override
  String get customizeApp => 'Tùy chỉnh ứng dụng';

  @override
  String get temperatureUnit => 'Đơn vị nhiệt độ';

  @override
  String get celsius => 'Độ C (°C)';

  @override
  String get fahrenheit => 'Độ F (°F)';

  @override
  String get weatherNotifications => 'Thông báo thời tiết';

  @override
  String get badWeatherAndHighAQIAlerts => 'Cảnh báo thời tiết xấu & AQI cao';

  @override
  String get aboutApp => 'Giới thiệu ứng dụng';

  @override
  String version(String version) {
    return 'Phiên bản $version';
  }

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get howWeProtectYourData => 'Cách chúng tôi bảo vệ dữ liệu của bạn';

  @override
  String get weatherAndAirQuality => 'Thời tiết & Chất lượng không khí';

  @override
  String get allRightsReserved => '© 2025 AtmosCare. Bảo lưu mọi quyền.';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String updateTime(String time) {
    return 'Cập nhật: $time';
  }

  @override
  String get high => 'Cao';

  @override
  String get low => 'Thấp';

  @override
  String get feelsLike => 'Cảm giác';

  @override
  String get humidity => 'Độ ẩm';

  @override
  String get wind => 'Gió';

  @override
  String get visibility => 'Tầm nhìn';

  @override
  String get pressure => 'Áp suất';

  @override
  String get airQuality => 'Chất lượng không khí';

  @override
  String updatedMinutesAgo(int minutes) {
    return 'Cập nhật $minutes phút trước';
  }

  @override
  String get sunrise => 'Bình minh';

  @override
  String get sunset => 'Hoàng hôn';

  @override
  String get direction => 'Hướng';

  @override
  String get normal => 'Bình thường';

  @override
  String get veryGood => 'Rất tốt';

  @override
  String get good => 'Tốt';

  @override
  String get limited => 'Hạn chế';

  @override
  String get hourlyForecast => 'Dự báo 24 giờ';

  @override
  String get viewDetails => 'Xem chi tiết';

  @override
  String get airQualityGoodSafe =>
      'Chất lượng không khí tốt, an toàn cho mọi hoạt động ngoài trời';

  @override
  String get moderate => 'Trung bình';

  @override
  String get poor => 'Kém';

  @override
  String get hazardous => 'Nguy hại';

  @override
  String get home => 'Trang chủ';

  @override
  String get forecast => 'Dự báo';

  @override
  String get aqi => 'AQI';

  @override
  String get healthRecommendations => 'Khuyến nghị sức khỏe';

  @override
  String get basedOnCurrentAQI => 'Dựa trên chỉ số AQI hiện tại';

  @override
  String get pollutantIndex => 'Chỉ số các chất ô nhiễm';

  @override
  String get highAQIAlert => 'Cảnh báo AQI cao';

  @override
  String get receiveNotificationWhenAQI => 'Nhận thông báo khi AQI >150';

  @override
  String get aqiScale => 'Thang đo AQI';

  @override
  String get aqiAndPollutantsIndex => 'Chỉ số AQI & các chất ô nhiễm';

  @override
  String get weatherForecast => 'Dự báo thời tiết';

  @override
  String get detailsForNext7Days => 'Chi tiết 7 ngày tới';

  @override
  String get hourlyDetails => 'Chi tiết theo giờ';

  @override
  String get twentyFourHours => '24 giờ';

  @override
  String get sevenDays => '7 ngày';
}
