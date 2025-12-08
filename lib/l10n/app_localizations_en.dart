// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get customizeApp => 'Customize app';

  @override
  String get temperatureUnit => 'Temperature unit';

  @override
  String get celsius => 'Celsius (°C)';

  @override
  String get fahrenheit => 'Fahrenheit (°F)';

  @override
  String get weatherNotifications => 'Weather notifications';

  @override
  String get badWeatherAndHighAQIAlerts => 'Bad weather & high AQI alerts';

  @override
  String get aboutApp => 'About app';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get howWeProtectYourData => 'How we protect your data';

  @override
  String get weatherAndAirQuality => 'Weather & Air Quality';

  @override
  String get allRightsReserved => '© 2025 AtmosCare. All rights reserved.';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String updateTime(String time) {
    return 'Updated: $time';
  }

  @override
  String get high => 'High';

  @override
  String get low => 'Low';

  @override
  String get feelsLike => 'Feels like';

  @override
  String get humidity => 'Humidity';

  @override
  String get wind => 'Wind';

  @override
  String get visibility => 'Visibility';

  @override
  String get pressure => 'Pressure';

  @override
  String get airQuality => 'Air quality';

  @override
  String updatedMinutesAgo(int minutes) {
    return 'Updated $minutes minutes ago';
  }

  @override
  String get sunrise => 'Sunrise';

  @override
  String get sunset => 'Sunset';

  @override
  String get direction => 'Direction';

  @override
  String get normal => 'Normal';

  @override
  String get veryGood => 'Very good';

  @override
  String get good => 'Good';

  @override
  String get limited => 'Limited';

  @override
  String get hourlyForecast => '24-hour forecast';

  @override
  String get viewDetails => 'View details';

  @override
  String get airQualityGoodSafe =>
      'Air quality is good, safe for all outdoor activities';

  @override
  String get moderate => 'Moderate';

  @override
  String get poor => 'Poor';

  @override
  String get hazardous => 'Hazardous';

  @override
  String get home => 'Home';

  @override
  String get forecast => 'Forecast';

  @override
  String get aqi => 'AQI';

  @override
  String get healthRecommendations => 'Health recommendations';

  @override
  String get basedOnCurrentAQI => 'Based on current AQI index';

  @override
  String get pollutantIndex => 'Pollutant Index';

  @override
  String get highAQIAlert => 'High AQI Alert';

  @override
  String get receiveNotificationWhenAQI =>
      'Receive notifications when AQI >150';

  @override
  String get aqiScale => 'AQI Scale';

  @override
  String get aqiAndPollutantsIndex => 'AQI Index & Pollutants';

  @override
  String get weatherForecast => 'Weather Forecast';

  @override
  String get detailsForNext7Days => 'Details for the next 7 days';

  @override
  String get hourlyDetails => 'Hourly Details';

  @override
  String get twentyFourHours => '24 Hours';

  @override
  String get sevenDays => '7 Days';
}
