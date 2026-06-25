import 'dart:io';

import 'package:cal_scanner/core/error/failure.dart';
import 'package:cal_scanner/features/calories/domain/entities/food.dart';
import 'package:fpdart/fpdart.dart';

abstract class FoodRepository {
  Future<Either<Failure, List<Food>>> getDailyFoodLog(DateTime date);
  Future<Either<Failure, Unit>> addFood(Food food);
  Future<Either<Failure, Unit>> deleteFood(Food food);
  Future<Either<Failure, Unit>> updateFood(Food food);

  Future<Either<Failure, Food>> detectFoodFromImage(File image);

  Future<Either<Failure, List<double>>> getWeeklyCalories({
    required DateTime endDate,
  });
}
