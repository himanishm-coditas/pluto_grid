
import 'dart:convert' ;

import 'package:dartz/dartz.dart';
import 'package:example/core/failure/failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class  JsonService {
  Future<Either<Failure, List<dynamic>>> loadJsonFromAssets(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      return Right(json.decode(jsonString) as List<dynamic>);
    } on FormatException catch (e) {
      return Left(InvalidInputFailure('Invalid JSON: ${e.message}'));
    } on FlutterError catch (e) {
      return Left(CacheFailure('File error: ${e.message}'));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }
}