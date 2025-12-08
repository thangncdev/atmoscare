import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider для управления языком приложения
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('vi')) {
    _loadLocale();
  }

  /// Загружает сохраненный язык из SharedPreferences
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'vi';
    state = Locale(languageCode);
  }

  /// Устанавливает язык и сохраняет его
  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  /// Переключает язык между vi и en
  Future<void> toggleLanguage() async {
    final newLocale = state.languageCode == 'vi' 
        ? const Locale('en') 
        : const Locale('vi');
    await setLocale(newLocale);
  }
}

