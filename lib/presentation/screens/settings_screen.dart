import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../l10n/app_localizations.dart';
import '../core/screen_util_helper.dart';
import '../core/theme.dart';
import '../widgets/settings/settings_header.dart';
import '../widgets/settings/settings_section.dart';
import '../widgets/settings/setting_item.dart';
import '../widgets/settings/notification_item.dart';
import '../widgets/settings/app_info_widget.dart';
import '../widgets/settings/language_item.dart';
import '../providers/notification_provider.dart';

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

/// Màn hình cài đặt
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Future<void> _openEmailSupport() async {
    final email = 'thangnct110@gmail.com';
    final subject = Uri.encodeComponent('Support Request - Atmos Care');
    final body = Uri.encodeComponent('Hello,\n\n');
    
    final uri = Uri.parse('mailto:$email?subject=$subject&body=$body');
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open email client'),
              backgroundColor: AppTheme.aqiUnhealthy,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening email: $e'),
            backgroundColor: AppTheme.aqiUnhealthy,
          ),
        );
      }
    }
  }

  void _showAboutAppDialog(BuildContext context, AppLocalizations l10n) {
    final currentLocale = Localizations.localeOf(context);
    final isVietnamese = currentLocale.languageCode == 'vi';
    
    // Lấy nội dung dựa trên locale hiện tại - chỉ hiển thị ngôn ngữ hiện tại
    final content = isVietnamese 
        ? l10n.aboutAppContentVietnamese 
        : l10n.aboutAppContentEnglish;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radius2xl,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.divider,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.aboutApp,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: AppTheme.textSecondary,
                        size: 24.w,
                      ),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.6,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
              // Footer
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary500,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // final tempUnit = ref.watch(temperatureUnitProvider);
    final notificationState = ref.watch(notificationEnabledProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsHeader(),
            SizedBox(height: 16.h),
            // Display Section

            // Notifications Section
            SettingsSection(
              delay: 0.2,
              children: [
                LanguageItem(delay: 0.15),
                notificationState.when(
                  data: (enabled) => NotificationItem(
                    enabled: enabled,
                    onToggle: () {
                      ref.read(notificationEnabledProvider.notifier).toggle();
                    },
                    delay: 0.35,
                  ),
                  loading: () => NotificationItem(
                    enabled: false,
                    onToggle: () {},
                    delay: 0.35,
                  ),
                  error: (_, __) => NotificationItem(
                    enabled: false,
                    onToggle: () {
                      ref.read(notificationEnabledProvider.notifier).toggle();
                    },
                    delay: 0.35,
                  ),
                ),
                SettingItem(
                  icon: Icons.info_outline,
                  title: l10n.aboutApp,
                  subtitle: l10n.tapToLearnMore,
                  delay: 0.45,
                  onTap: () => _showAboutAppDialog(context, l10n),
                ),
                SettingItem(
                  icon: Icons.email_outlined,
                  title: l10n.contactSupport,
                  subtitle: l10n.sendEmailForSupport,
                  delay: 0.55,
                  onTap: () => _openEmailSupport(),
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
