import 'package:example/core/failure/failure.dart';
import 'package:example/feature/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:example/feature/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:dartz/dartz.dart';

class WatchlistUsecase {
  final WatchlistRepository repository;

  WatchlistUsecase(this.repository);

  Future<Either<Failure, List<WatchlistItem>>> getWatchlistItems() =>
      repository.getWatchlistItems();
}
