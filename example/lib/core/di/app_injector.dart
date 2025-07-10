import 'package:example/core/controller/theme_controller.dart';
import 'package:example/core/services/local_json_service.dart';
import 'package:example/core/services/storage/local_storage_service.dart';
import 'package:example/feature/watchlist/data/data_sources/watchlist_local_data_source.dart';

import 'package:example/feature/watchlist/data/repositories/watchlist_repository_impl.dart';

import 'package:example/feature/watchlist/domain/repositories/watchlist_repository.dart';

import 'package:example/feature/watchlist/domain/use_cases/watchlist_usecase.dart';
import 'package:example/feature/watchlist/presentation/bloc/watchlist_bloc.dart';

import 'package:get_it/get_it.dart';

class AppInjector {
  static final GetIt getIt = GetIt.instance;

  static Future<void> setupLocator() async {
    getIt
      ..registerLazySingleton<JsonService>(JsonService.new)
      ..registerLazySingleton<SharedPrefsService>(SharedPrefsService.new)
      ..registerLazySingleton<WatchlistLocalDataSource>(
        () => WatchlistLocalDataSource(
          jsonService: getIt<JsonService>(),
          sharedPrefsService: getIt<SharedPrefsService>(),
        ),
      )
      ..registerLazySingleton<WatchlistRepository>(
        () => WatchlistRepositoryImpl(
          localDataSource: getIt<WatchlistLocalDataSource>(),
        ),
      )
      ..registerLazySingleton<WatchlistUsecase>(
            () => WatchlistUsecase(
          getIt<WatchlistRepository>(),
        ),
      )
      ..registerFactory<WatchlistBloc>(
            () => WatchlistBloc(
          watchlistUsecase: getIt<WatchlistUsecase>(),
        ),
      )
      ..registerLazySingleton<ThemeController>(
            () => ThemeController(getIt<WatchlistRepository>()),
      );
  }
}
