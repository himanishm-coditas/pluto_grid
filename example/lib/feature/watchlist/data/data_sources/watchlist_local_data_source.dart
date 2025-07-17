// ignore_for_file: avoid_annotating_with_dynamic

import 'package:dartz/dartz.dart';
import 'package:example/core/failure/failure.dart';
import 'package:example/core/services/local_json_service.dart';
import 'package:example/feature/watchlist/data/models/watchlist_item_model.dart';

class WatchlistLocalDataSource {
  WatchlistLocalDataSource({
    required this.jsonService,
  });

  final JsonService jsonService;


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

}
