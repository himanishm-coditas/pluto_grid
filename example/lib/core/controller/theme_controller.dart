import 'package:example/core/services/storage/local_storage_keys.dart';
import 'package:example/core/services/storage/local_storage_service.dart';
import 'package:flutter/material.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController(this._sharedPrefsService) : super(ThemeMode.system);

  final SharedPrefsService _sharedPrefsService;

  Future<void> initialize() async {
    final String? modeName =
    _sharedPrefsService.getString(SharedPrefsKeys.themeMode);

    if (modeName != null) {
      value = ThemeMode.values.byName(modeName);
    } else {
      value = ThemeMode.system;
    }
  }

  Future<void> setTheme(final ThemeMode theme) async {
    value = theme;
    await _sharedPrefsService.setString(
       SharedPrefsKeys.themeMode,
       theme.name,
    );
  }

  Future<void> toggleTheme() async {
    if (value == ThemeMode.light) {
      await setTheme(ThemeMode.dark);
    } else  {
      await setTheme(ThemeMode.light);
    }
  }
}
