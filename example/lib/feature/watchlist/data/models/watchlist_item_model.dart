import 'package:example/feature/watchlist/domain/entities/watchlist_item_entity.dart';


class WatchlistItemModel extends WatchlistItem  {
  const WatchlistItemModel({
    required super.symbol,
    required super.company,
    required super.bidQty,
    required super.bidRate,
    required super.askQty,
    required super.askRate,
    required super.volume,
    required super.high52w,
    required super.low52w,
    required super.ltp,
    required super.change,
  });

  factory WatchlistItemModel.fromJson(Map<String, dynamic> json) {
    return WatchlistItemModel(
      symbol: json['symbol'],
      company: json['company'],
      bidQty: json['bid_qty'],
      bidRate: json['bid_rate'],
      askQty: json['ask_qty'],
      askRate: json['ask_rate'],
      volume: json['volume'],
      high52w: json['high_52w'],
      low52w: json['low_52w'],
      ltp: json['ltp'].toDouble(),
      change: json['change'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'company': company,
      'bid_qty': bidQty,
      'bid_rate': bidRate,
      'ask_qty': askQty,
      'ask_rate': askRate,
      'volume': volume,
      'high_52w': high52w,
      'low_52w': low52w,
      'ltp': ltp,
      'change': change,
    };
  }

}