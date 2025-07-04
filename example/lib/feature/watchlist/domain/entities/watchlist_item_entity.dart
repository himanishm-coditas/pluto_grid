import 'package:equatable/equatable.dart';

class WatchlistItem extends Equatable {
  final String symbol;
  final String company;
  final int bidQty;
  final double bidRate;
  final int askQty;
  final double askRate;
  final int volume;
  final double high52w;
  final double low52w;
  final double ltp;
  final String change;

  const WatchlistItem({
    required this.symbol,
    required this.company,
    required this.bidQty,
    required this.bidRate,
    required this.askQty,
    required this.askRate,
    required this.volume,
    required this.high52w,
    required this.low52w,
    required this.ltp,
    required this.change,
  });

  @override
  List<Object?> get props => [
    symbol,
    company,
    bidQty,
    bidRate,
    askQty,
    askRate,
    volume,
    high52w,
    low52w,
    ltp,
    change,
  ];
}
