import 'package:example/feature/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:flutter/material.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController(this._watchlistRepository) : super(ThemeMode.light);

  final WatchlistRepository _watchlistRepository;

  Future<void> initialize() async {
    final bool isDark = _watchlistRepository.loadThemePreference();
    value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final ThemeMode newTheme =
        value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    value = newTheme;

    // Save the theme preference
    await _watchlistRepository.saveThemePreference(
        isDark: newTheme == ThemeMode.dark);
  }

  Future<void> setLight() async {
    value = ThemeMode.light;
    await _watchlistRepository.saveThemePreference(isDark: false);
  }

  Future<void> setDark() async {
    value = ThemeMode.dark;
    await _watchlistRepository.saveThemePreference(isDark: true);
  }
}
