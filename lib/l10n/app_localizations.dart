import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Settings screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize app'**
  String get customizeApp;

  /// Temperature unit setting title
  ///
  /// In en, this message translates to:
  /// **'Temperature unit'**
  String get temperatureUnit;

  /// Celsius unit label
  ///
  /// In en, this message translates to:
  /// **'Celsius (°C)'**
  String get celsius;

  /// Fahrenheit unit label
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit (°F)'**
  String get fahrenheit;

  /// Weather notifications setting title
  ///
  /// In en, this message translates to:
  /// **'Weather notifications'**
  String get weatherNotifications;

  /// Weather notifications setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Bad weather & high AQI alerts'**
  String get badWeatherAndHighAQIAlerts;

  /// About app setting title
  ///
  /// In en, this message translates to:
  /// **'About app'**
  String get aboutApp;

  /// App version text
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// Privacy policy setting title
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// Privacy policy setting subtitle
  ///
  /// In en, this message translates to:
  /// **'How we protect your data'**
  String get howWeProtectYourData;

  /// App subtitle
  ///
  /// In en, this message translates to:
  /// **'Weather & Air Quality'**
  String get weatherAndAirQuality;

  /// Copyright text
  ///
  /// In en, this message translates to:
  /// **'© 2025 AtmosCare. All rights reserved.'**
  String get allRightsReserved;

  /// Language setting title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// Vietnamese language name
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Update time label
  ///
  /// In en, this message translates to:
  /// **'Updated: {time}'**
  String updateTime(String time);

  /// High temperature label
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// Low temperature label
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// Feels like temperature label
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get feelsLike;

  /// Humidity label
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// Wind label
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// Visibility label
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibility;

  /// Pressure label
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// Air quality label
  ///
  /// In en, this message translates to:
  /// **'Air quality'**
  String get airQuality;

  /// Updated minutes ago text
  ///
  /// In en, this message translates to:
  /// **'Updated {minutes} minutes ago'**
  String updatedMinutesAgo(int minutes);

  /// Sunrise label
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// Sunset label
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// Direction label
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// Normal status
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// Very good status
  ///
  /// In en, this message translates to:
  /// **'Very good'**
  String get veryGood;

  /// Good status
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// Limited status
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get limited;

  /// 24-hour forecast title
  ///
  /// In en, this message translates to:
  /// **'24-hour forecast'**
  String get hourlyForecast;

  /// View details button
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// Default air quality recommendation
  ///
  /// In en, this message translates to:
  /// **'Air quality is good, safe for all outdoor activities'**
  String get airQualityGoodSafe;

  /// Moderate AQI status
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// Poor AQI status
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// Hazardous AQI status
  ///
  /// In en, this message translates to:
  /// **'Hazardous'**
  String get hazardous;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Forecast navigation label
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get forecast;

  /// AQI navigation label
  ///
  /// In en, this message translates to:
  /// **'AQI'**
  String get aqi;

  /// Health recommendations title
  ///
  /// In en, this message translates to:
  /// **'Health recommendations'**
  String get healthRecommendations;

  /// Health recommendations subtitle
  ///
  /// In en, this message translates to:
  /// **'Based on current AQI index'**
  String get basedOnCurrentAQI;

  /// Pollutant index title
  ///
  /// In en, this message translates to:
  /// **'Pollutant Index'**
  String get pollutantIndex;

  /// High AQI alert title
  ///
  /// In en, this message translates to:
  /// **'High AQI Alert'**
  String get highAQIAlert;

  /// High AQI alert subtitle
  ///
  /// In en, this message translates to:
  /// **'Receive notifications when AQI >150'**
  String get receiveNotificationWhenAQI;

  /// AQI scale title
  ///
  /// In en, this message translates to:
  /// **'AQI Scale'**
  String get aqiScale;

  /// AQI screen subtitle
  ///
  /// In en, this message translates to:
  /// **'AQI Index & Pollutants'**
  String get aqiAndPollutantsIndex;

  /// Weather forecast screen title
  ///
  /// In en, this message translates to:
  /// **'Weather Forecast'**
  String get weatherForecast;

  /// Weather forecast screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Details for the next 7 days'**
  String get detailsForNext7Days;

  /// Hourly forecast title
  ///
  /// In en, this message translates to:
  /// **'Hourly Details'**
  String get hourlyDetails;

  /// 24 hours toggle label
  ///
  /// In en, this message translates to:
  /// **'24 Hours'**
  String get twentyFourHours;

  /// 7 days toggle label
  ///
  /// In en, this message translates to:
  /// **'7 Days'**
  String get sevenDays;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
