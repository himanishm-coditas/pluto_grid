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
  WatchlistBloc({required this.watchlistUsecase})
      : super(WatchlistInitial(
            isDarkTheme: watchlistUsecase.loadThemePreference())) {
    on<LoadWatchlistEvent>(_onLoadWatchlist);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<LoadThemeEvent>(_onLoadTheme);
  }

  final WatchlistUsecase watchlistUsecase;

  Future<void> _onLoadWatchlist(
    final LoadWatchlistEvent event,
    final Emitter<WatchlistState> emit,
  ) async {
    emit(WatchlistInitial(isDarkTheme: _currentTheme));

    final Either<Failure, List<WatchlistItemEntity>> result =
        await watchlistUsecase.getWatchlistItems();
    result.fold(
      (final Failure failure) => emit(
          WatchlistError(message: failure.message, isDarkTheme: _currentTheme)),
      (final List<WatchlistItemEntity> items) {
        emit(WatchlistLoaded(items: items, isDarkTheme: _currentTheme));
      },
    );
  }

  Future<void> _onToggleTheme(
    final ToggleThemeEvent event,
    final Emitter<WatchlistState> emit,
  ) async {
    final bool newTheme = !_currentTheme;
    await watchlistUsecase.saveThemePreference(isDark: newTheme);

    final WatchlistState currentState = state;
    if (currentState is WatchlistLoaded) {
      emit(currentState.copyWith(isDarkTheme: newTheme));
    } else if (currentState is WatchlistInitial) {
      emit(WatchlistInitial(isDarkTheme: newTheme));
    } else if (currentState is WatchlistError) {
      emit(
        WatchlistError(
          message: currentState.message,
          isDarkTheme: newTheme,
        ),
      );
    }
  }

  void _onLoadTheme(
    final LoadThemeEvent event,
    final Emitter<WatchlistState> emit,
  ) {
    final bool isDarkTheme = watchlistUsecase.loadThemePreference();

    if (state is WatchlistLoaded) {
      emit((state as WatchlistLoaded).copyWith(isDarkTheme: isDarkTheme));
    } else if (state is WatchlistInitial) {
      emit(WatchlistInitial(isDarkTheme: isDarkTheme));
    } else if (state is WatchlistError) {
      emit(
        WatchlistError(
            message: (state as WatchlistError).message,
            isDarkTheme: isDarkTheme),
      );
    }
  }

  bool get _currentTheme {
    return state is WatchlistInitial
        ? (state as WatchlistInitial).isDarkTheme
        : state is WatchlistLoaded
            ? (state as WatchlistLoaded).isDarkTheme
            : state is WatchlistError
                ? (state as WatchlistError).isDarkTheme
                : true;
  }
}
