// ignore_for_file: avoid_annotating_with_dynamic

import 'package:dartz/dartz.dart';
import 'package:example/core/failure/failure.dart';
import 'package:example/core/services/local_json_service.dart';
import 'package:example/core/services/storage/shared_prefs_keys.dart';
import 'package:example/core/services/storage/shared_prefs_service.dart';
import 'package:example/feature/watchlist/data/models/watchlist_item_model.dart';

class WatchlistLocalDataSource {
  WatchlistLocalDataSource({
    required this.jsonService,
    required this.sharedPrefsService,
  });

  final JsonService jsonService;

  ///responsible service for persisting theme in shared preference
  final SharedPrefsService sharedPrefsService;

  Future<Either<Failure, List<WatchlistItemModel>>> getWatchlistItems() async {
    final Either<Failure, List<WatchlistItemModel>> result =
    await jsonService.loadJsonFromAssets<List<WatchlistItemModel>>(
      'assets/fake_data/watchlist.json',
      parser: (final List<dynamic> jsonList) => jsonList
          .map<WatchlistItemModel>(
            (final dynamic item) => WatchlistItemModel.fromJson(item),
      )
          .toList(),
    );
    return result;
  }

  /// Save theme preference
  Future<void> saveThemePreference({required final bool isDark}) =>
      sharedPrefsService.setBool(key: SharedPrefsKeys.themeKey, value: isDark);

  /// Load theme preference
  bool loadThemePreference() =>
      sharedPrefsService.getBool(SharedPrefsKeys.themeKey) ?? true;
}
