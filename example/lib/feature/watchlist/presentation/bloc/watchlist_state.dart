part of 'watchlist_bloc.dart';

@immutable
sealed  class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => <Object?>[];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {

  const WatchlistLoaded(this.items);
  final List<WatchlistItemEntity> items;

  @override
  List<Object?> get props => <Object?>[items];
}

class WatchlistError extends WatchlistState {

  const WatchlistError(this.message);
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
