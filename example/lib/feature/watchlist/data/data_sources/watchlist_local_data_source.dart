import 'package:example/core/failure/failure.dart';
import 'package:example/core/services/local_json_service.dart';
import 'package:example/feature/watchlist/data/models/watchlist_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:dartz/dartz.dart';

abstract class WatchlistDataSource {
  Future<Either<Failure, List<WatchlistItemModel>>> getWatchlistItems();
}

// Updated data source
class WatchlistLocalDataSource implements WatchlistDataSource {
  final JsonService jsonService;

  WatchlistLocalDataSource({required this.jsonService});

  @override
  Future<Either<Failure, List<WatchlistItemModel>>> getWatchlistItems() async {
    final result =
        await jsonService.loadJsonFromAssets('assets/fake_data/watchlist.json');
    return result.fold(
      (failure) => Left(failure),
      (jsonList) =>
          Right(jsonList.map((e) => WatchlistItemModel.fromJson(e)).toList()),
    );
  }
}
