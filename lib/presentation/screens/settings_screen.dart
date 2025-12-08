import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../core/screen_util_helper.dart';
import '../core/theme.dart';
import '../widgets/settings/settings_header.dart';
import '../widgets/settings/settings_section.dart';
import '../widgets/settings/setting_item.dart';
import '../widgets/settings/temperature_unit_item.dart';
import '../widgets/settings/notification_item.dart';
import '../widgets/settings/app_info_widget.dart';
import '../widgets/settings/language_item.dart';

/// Provider cho temperature unit
final temperatureUnitProvider =
    StateNotifierProvider<TemperatureUnitNotifier, String>((ref) {
      return TemperatureUnitNotifier();
    });

class TemperatureUnitNotifier extends StateNotifier<String> {
  TemperatureUnitNotifier() : super('C');

  void setUnit(String unit) {
    state = unit;
  }
}

/// Provider cho notifications
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, bool>((ref) {
      return NotificationsNotifier();
    });

class NotificationsNotifier extends StateNotifier<bool> {
  NotificationsNotifier() : super(true);

  void toggle() {
    state = !state;
  }
}

/// Màn hình cài đặt
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tempUnit = ref.watch(temperatureUnitProvider);
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsHeader(),
            SizedBox(height: 16.h),
            // Display Section
            SettingsSection(
              delay: 0.15,
              children: [
                LanguageItem(
                  delay: 0.15,
                ),
                TemperatureUnitItem(
                  currentUnit: tempUnit,
                  onUnitChanged: (unit) {
                    ref
                        .read(temperatureUnitProvider.notifier)
                        .setUnit(unit);
                  },
                  delay: 0.2,
                ),
              ],
            ),
            
            // Notifications Section
            SettingsSection(
              delay: 0.3,
              children: [
                NotificationItem(
                  enabled: notifications,
                  onToggle: () {
                    ref.read(notificationsProvider.notifier).toggle();
                  },
                  delay: 0.35,
                ),
              ],
            ),
            
            // Information Section
            SettingsSection(
              delay: 0.4,
              children: [
                SettingItem(
                  icon: Icons.info_outline,
                  title: l10n.aboutApp,
                  subtitle: l10n.version('1.0.0'),
                  delay: 0.45,
                ),
                SizedBox(height: 12.h),
                SettingItem(
                  icon: Icons.shield_outlined,
                  title: l10n.privacyPolicy,
                  subtitle: l10n.howWeProtectYourData,
                  delay: 0.5,
                ),
              ],
            ),
            
            // App Info
            const AppInfoWidget(),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
