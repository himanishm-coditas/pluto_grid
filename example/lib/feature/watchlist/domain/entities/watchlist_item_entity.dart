import 'package:equatable/equatable.dart';

class WatchlistItemEntity extends Equatable {

  const WatchlistItemEntity({
    this.symbol,
    this.company,
    this.bidQty,
    this.bidRate,
    this.askQty,
    this.askRate,
    this.volume,
    this.high52w,
    this.low52w,
    this.ltp,
    this.change,
  });
  final String? symbol;
  final String? company;
  final int? bidQty;
  final double? bidRate;
  final int? askQty;
  final double? askRate;
  final int? volume;
  final double? high52w;
  final double? low52w;
  final double? ltp;
  final String? change;

  @override
  List<Object?> get props => <Object?>[
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
