part of 'watchlist_bloc.dart';

@immutable
sealed class WatchlistState extends Equatable {
  const WatchlistState({this.isDarkTheme = true});

  final bool isDarkTheme;

  @override
  List<Object?> get props => <Object?>[isDarkTheme];
}

class WatchlistInitial extends WatchlistState {
  const WatchlistInitial({super.isDarkTheme});
}

class WatchlistLoaded extends WatchlistState {
  const WatchlistLoaded({
    required this.items,
    super.isDarkTheme,
  });

  final List<WatchlistItemEntity> items;

  @override
  List<Object?> get props => <Object?>[items, isDarkTheme];

  WatchlistLoaded copyWith({
    final List<WatchlistItemEntity>? items,
    final bool? isDarkTheme,
  }) => WatchlistLoaded(
      items: items ?? this.items,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
    );
}

class WatchlistError extends WatchlistState {
  const WatchlistError({
    required this.message,
    super.isDarkTheme,
  });

  final String message;

  @override
  List<Object?> get props => <Object?>[message, isDarkTheme];
}
