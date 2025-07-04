import 'package:equatable/equatable.dart';
import 'package:example/core/failure/failure.dart';
import 'package:example/feature/watchlist/domain/entities/watchlist_item_entity.dart';
import 'package:example/feature/watchlist/domain/use_cases/watchlist_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistUsecase watchlistUsecase;

  WatchlistBloc({required this.watchlistUsecase}) : super(WatchlistInitial()) {
    on<LoadWatchlistEvent>(_onLoadWatchlist);
  }

  Future<void> _onLoadWatchlist(
      LoadWatchlistEvent event,
      Emitter<WatchlistState> emit,
      ) async {
    emit(WatchlistInitial());
    final result = await watchlistUsecase.getWatchlistItems();
    result.fold(
          (failure) => emit(WatchlistError(_mapFailureToMessage(failure))),
          (items) => emit(WatchlistLoaded(items)),
    );
  }


  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}