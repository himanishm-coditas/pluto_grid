import 'package:example/feature/watchlist/domain/use_cases/watchlist_usecase.dart';
import 'package:flutter/material.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController(this._watchlistUsecase) : super(ThemeMode.light);

  final WatchlistUsecase _watchlistUsecase;

  Future<void> initialize() async {
    final bool isDark = _watchlistUsecase.loadThemePreference();
    value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final ThemeMode newTheme =
        value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    value = newTheme;

    // Save the theme preference
    await _watchlistUsecase.saveThemePreference(
        isDark: newTheme == ThemeMode.dark);
  }

  Future<void> setLight() async {
    value = ThemeMode.light;
    await _watchlistUsecase.saveThemePreference(isDark: false);
  }

  Future<void> setDark() async {
    value = ThemeMode.dark;
    await _watchlistUsecase.saveThemePreference(isDark: true);
  }
}
