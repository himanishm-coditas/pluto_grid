import 'package:dartz/dartz.dart';
import 'package:example/core/failure/failure.dart';
import 'package:example/feature/watchlist/domain/entities/watchlist_item_entity.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, List<WatchlistItemEntity>>> getWatchlistItems();

}
