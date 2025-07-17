import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:example/core/failure/failure.dart';
import 'package:example/feature/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:example/feature/watchlist/domain/use_cases/watchlist_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_event.dart';

part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc({required this.watchlistUsecase}) : super(WatchlistInitial()) {
    on<LoadWatchlistEvent>(_onLoadWatchlist);
  }

  final WatchlistUsecase watchlistUsecase;

  Future<void> _onLoadWatchlist(
      final LoadWatchlistEvent event,
      final Emitter<WatchlistState> emit,
      ) async {
    emit(WatchlistInitial());
    final Either<Failure, List<WatchlistItemEntity>> result =
    await watchlistUsecase.getWatchlistItems();
    result.fold(
          (final Failure failure) => emit(WatchlistError(failure.message)),
          (final List<WatchlistItemEntity> items) => emit(WatchlistLoaded(items)),
    );
  }
}