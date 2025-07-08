import 'package:dartz/dartz.dart';
import 'package:example/core/failure/failure.dart';
import 'package:example/feature/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:example/feature/watchlist/domain/repositories/watchlist_repository.dart';

class WatchlistUsecase {

  WatchlistUsecase(this.repository);
  final WatchlistRepository repository;

  Future<Either<Failure, List<WatchlistItemEntity>>> getWatchlistItems() =>
      repository.getWatchlistItems();
}
