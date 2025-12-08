import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/screen_util_helper.dart';
import '../../core/theme.dart';
import '../../providers/locale_provider.dart';

/// Widget cho language setting với buttons
class LanguageItem extends ConsumerWidget {
  final double delay;

  const LanguageItem({
    super.key,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    // Получаем название текущего языка
    final currentLanguageName = currentLocale.languageCode == 'vi'
        ? l10n.vietnamese
        : l10n.english;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (delay * 1000).toInt()),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * -10, 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showLanguageBottomSheet(context, ref, l10n),
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: AppTheme.primary100,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.language,
                          color: AppTheme.primary700,
                          size: 24.w,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.language,
                              style: AppTheme.settingItemTitle,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              currentLanguageName,
                              style: AppTheme.settingItemSubtitle,
                            ),
                          ],
                        ),
                      ),
                      // Chevron
                      Icon(
                        Icons.chevron_right,
                        color: AppTheme.textTertiary,
                        size: 20.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLanguageBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final currentLocale = ref.read(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Text(
                  l10n.selectLanguage,
                  style: AppTheme.settingItemTitle.copyWith(fontSize: 20.sp),
                ),
              ),
              // Language options
              _LanguageOption(
                label: l10n.vietnamese,
                isSelected: currentLocale.languageCode == 'vi',
                onTap: () {
                  localeNotifier.setLocale(const Locale('vi'));
                  Navigator.pop(context);
                },
              ),
              _LanguageOption(
                label: l10n.english,
                isSelected: currentLocale.languageCode == 'en',
                onTap: () {
                  localeNotifier.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// Language option widget for bottom sheet
class _LanguageOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.settingItemTitle,
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  color: AppTheme.primary700,
                  size: 24.w,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

