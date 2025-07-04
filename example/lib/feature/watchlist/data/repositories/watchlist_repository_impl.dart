import 'package:example/core/failure/failure.dart';
import 'package:example/feature/watchlist/data/data_sources/watchlist_local_data_source.dart';
import 'package:example/feature/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:example/feature/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:dartz/dartz.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  WatchlistRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<WatchlistItem>>> getWatchlistItems() async {
    try {
      final result = await localDataSource.getWatchlistItems();
      return result.fold(
            (failure) => Left(failure),
            (models) => Right(models),
      );
    } catch (e) {
      return Left(CacheFailure('Unexpected error: ${e.toString()}'));
    }
  }
}