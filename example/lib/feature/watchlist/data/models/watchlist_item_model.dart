import 'package:example/feature/watchlist/domain/entities/watchlist_item_entity.dart';

class WatchlistItemModel extends WatchlistItemEntity {
  const WatchlistItemModel({
    super.symbol,
    super.company,
    super.bidQty,
    super.bidRate,
    super.askQty,
    super.askRate,
    super.volume,
    super.high52w,
    super.low52w,
    super.ltp,
    super.change,
  });

  factory WatchlistItemModel.fromJson(final Map<String, dynamic> json) =>
      WatchlistItemModel(
        symbol: json['symbol'] ?? "",
        company: json['company'] ?? "",
        bidQty: json['bid_qty'] ?? 0,
        bidRate: json['bid_rate'] ?? 0.0,
        askQty: json['ask_qty'] ?? 0,
        askRate: json['ask_rate'] ?? 0.0,
        volume: json['volume'] ?? 0,
        high52w: json['high_52w'] ?? 0.0,
        low52w: json['low_52w'] ?? 0.0,
        ltp: json['ltp'] ?? 0.0,
        change: json['change'] ?? "",
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
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
