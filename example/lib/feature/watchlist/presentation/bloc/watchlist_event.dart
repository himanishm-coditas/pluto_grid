part of 'watchlist_bloc.dart';

@immutable
sealed class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlistEvent extends WatchlistEvent {
  const LoadWatchlistEvent();
}

class RefreshWatchlistEvent extends WatchlistEvent {
  const RefreshWatchlistEvent();
}