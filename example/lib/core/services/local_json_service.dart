import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:example/core/failure/failure.dart';
import 'package:flutter/services.dart';

class JsonService {
  Future<Either<Failure, T>> loadJsonFromAssets<T>(
      final String path, {
        required final Function(List<dynamic> data) parser,
      }) async {
    try {
      final String jsonString = await rootBundle.loadString(path);
      final List<dynamic> decoded = json.decode(jsonString);
      return Right<Failure, T>(parser(decoded));
    } on FormatException catch (e) {
      return Left<Failure, T>(
        InvalidInputFailure('Invalid JSON: ${e.message}'),
      );
    } on Exception catch (e) {
      return Left<Failure, T>(
        CacheFailure('Unexpected error: $e'),
      );
    }
  }
}
