import 'package:dartz/dartz.dart';
import 'package:example/core/failure/failure.dart';
import 'package:example/feature/watchlist/data/data_sources/watchlist_local_data_source.dart';
import 'package:example/feature/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:example/feature/watchlist/domain/repositories/watchlist_repository.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  WatchlistRepositoryImpl({required this.localDataSource});

  final WatchlistLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<WatchlistItemEntity>>> getWatchlistItems() =>
      localDataSource.getWatchlistItems();

}
