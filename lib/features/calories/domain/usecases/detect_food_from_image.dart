import 'dart:io';

import 'package:cal_scanner/core/error/failure.dart';
import 'package:cal_scanner/features/calories/domain/entities/food.dart';
import 'package:cal_scanner/features/calories/domain/repositories/food_repository.dart';
import 'package:fpdart/fpdart.dart';

class DetectFoodFromImage {
  final FoodRepository _repo;
  DetectFoodFromImage(this._repo);

  Future<Either<Failure, Food>> call(File image) =>
      _repo.detectFoodFromImage(image);
}
