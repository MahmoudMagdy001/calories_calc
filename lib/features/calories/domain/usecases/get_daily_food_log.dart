import 'package:cal_scanner/core/error/failure.dart';
import 'package:cal_scanner/features/calories/domain/entities/food.dart';
import 'package:cal_scanner/features/calories/domain/repositories/food_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetDailyFoodLog {
  final FoodRepository _repo;
  GetDailyFoodLog(this._repo);

  Future<Either<Failure, List<Food>>> call(DateTime date) =>
      _repo.getDailyFoodLog(date);
}
