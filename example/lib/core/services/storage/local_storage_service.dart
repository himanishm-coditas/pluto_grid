import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  late final SharedPreferences _prefs;

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setString(final String key, final String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(final String key) => _prefs.getString(key);

  Future<void> setBool({
  required final String key,
  required final bool value,
}) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(final String key) => _prefs.getBool(key);

  Future<void> setInt(final String key, final int value) async {
    await _prefs.setInt(key, value);
  }

  int? getInt(final String key) => _prefs.getInt(key);

  Future<void> setDouble(final String key, final double value) async {
    await _prefs.setDouble(key, value);
  }

  double? getDouble(final String key) => _prefs.getDouble(key);

  Future<void> setStringList(final String key, final List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  List<String>? getStringList(final String key) => _prefs.getStringList(key);

  Future<void> remove(final String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }

  bool containsKey(final String key) => _prefs.containsKey(key);
}
