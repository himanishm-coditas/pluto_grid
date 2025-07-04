import 'package:example/core/failure/failure.dart';
import 'package:example/feature/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:dartz/dartz.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, List<WatchlistItem>>> getWatchlistItems();
}