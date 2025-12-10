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
  String get weatherNotifications => 'Thông báo';

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
  String get allRightsReserved => '© 2025 Atmos Care. Bảo lưu mọi quyền.';

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

  @override
  String get today => 'Hôm nay';

  @override
  String get tomorrow => 'Ngày mai';

  @override
  String get sunday => 'Chủ nhật';

  @override
  String get monday => 'Thứ hai';

  @override
  String get tuesday => 'Thứ ba';

  @override
  String get wednesday => 'Thứ tư';

  @override
  String get thursday => 'Thứ năm';

  @override
  String get friday => 'Thứ sáu';

  @override
  String get saturday => 'Thứ bảy';

  @override
  String get uvIndex => 'Chỉ số UV';

  @override
  String get rain => 'Mưa';

  @override
  String get noRain => 'Không mưa';

  @override
  String get lightRain => 'Mưa nhẹ';

  @override
  String get moderateRain => 'Mưa vừa';

  @override
  String get heavyRain => 'Mưa nặng';

  @override
  String get selectLocation => 'Chọn vị trí';

  @override
  String get searchCity => 'Tìm kiếm thành phố...';

  @override
  String get currentLocation => 'Vị trí hiện tại';

  @override
  String get getCurrentLocationFromGPS => 'Lấy vị trí hiện tại từ GPS';

  @override
  String get enterCityNameToSearch => 'Nhập tên thành phố để tìm kiếm';

  @override
  String get locationServiceDisabled => 'Dịch vụ vị trí bị tắt';

  @override
  String get locationServiceDisabledMessage =>
      'Vui lòng bật dịch vụ vị trí trong cài đặt thiết bị để sử dụng tính năng này.';

  @override
  String get locationPermissionDenied => 'Quyền truy cập vị trí bị từ chối';

  @override
  String get locationPermissionDeniedMessage =>
      'Chúng tôi cần quyền truy cập vị trí để hiển thị thời tiết tại vị trí hiện tại của bạn.';

  @override
  String get locationPermissionDeniedForever => 'Cần quyền truy cập vị trí';

  @override
  String get locationPermissionDeniedForeverMessage =>
      'Quyền truy cập vị trí đã bị từ chối vĩnh viễn. Vui lòng bật trong cài đặt ứng dụng.';

  @override
  String get openSettings => 'Mở Cài đặt';

  @override
  String get cancel => 'Hủy';

  @override
  String get grantPermission => 'Cấp quyền';

  @override
  String get dailyWeatherReminderTitle => 'Kiểm tra thời tiết hôm nay';

  @override
  String get dailyWeatherReminderBody =>
      'Hãy xem dự báo thời tiết để có kế hoạch cho một ngày tốt đẹp!';

  @override
  String get enableNotificationsTitle => 'Bật thông báo';

  @override
  String get enableNotificationsMessage =>
      'Bật thông báo để nhận cảnh báo về thời tiết xấu và chất lượng không khí kém.';

  @override
  String get enable => 'Bật';

  @override
  String get notNow => 'Không phải bây giờ';

  @override
  String get tapToLearnMore => 'Nhấn để tìm hiểu thêm';

  @override
  String get aboutAppContentEnglish =>
      '🇺🇸 About App (English)\n\nThis app is built with the goal of becoming your trusted daily companion. Beyond weather forecasts, it provides real-time air quality information to help you take better care of your health and stay safe in changing environmental conditions.\n\nThe app is completely free, created for the community with a strong focus on your safety and well-being. We believe that when you truly understand the weather and the air around you, you can live more confidently, proactively, and healthily every day.';

  @override
  String get aboutAppContentVietnamese =>
      '🇻🇳 About App (Tiếng Việt)\n\nỨng dụng được tạo ra với mong muốn trở thành người bạn đồng hành đáng tin cậy trong cuộc sống hằng ngày của bạn. Không chỉ cung cấp thông tin thời tiết, chúng tôi còn theo dõi chất lượng không khí theo thời gian thực, giúp bạn chủ động bảo vệ sức khỏe của bản thân và gia đình trước những thay đổi của môi trường.\n\nỨng dụng hoàn toàn miễn phí, được phát triển vì cộng đồng, với mục tiêu đặt sự an toàn và sức khỏe của người dùng lên hàng đầu. Chúng tôi tin rằng, khi hiểu rõ thời tiết và không khí xung quanh, bạn sẽ sống an tâm hơn, chủ động hơn và khỏe mạnh hơn mỗi ngày.';

  @override
  String get contactSupport => 'Liên hệ hỗ trợ';

  @override
  String get sendEmailForSupport => 'Gửi email để được hỗ trợ';

  @override
  String get errorLoadingWeather => 'Không thể tải dữ liệu thời tiết';

  @override
  String get errorLoadingWeatherMessage =>
      'Chúng tôi không thể lấy thông tin thời tiết. Vui lòng kiểm tra kết nối internet và thử lại.';

  @override
  String get errorLoadingAQI => 'Không thể tải dữ liệu chất lượng không khí';

  @override
  String get errorLoadingAQIMessage =>
      'Chúng tôi không thể lấy thông tin chất lượng không khí. Vui lòng kiểm tra kết nối internet và thử lại.';

  @override
  String get retry => 'Thử lại';

  @override
  String get errorLoadingForecast => 'Không thể tải dự báo';

  @override
  String get errorLoadingForecastMessage =>
      'Chúng tôi không thể lấy thông tin dự báo. Vui lòng kiểm tra kết nối internet và thử lại.';
}
