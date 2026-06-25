import 'package:cal_scanner/core/error/failure.dart';
import 'package:cal_scanner/features/calories/domain/repositories/food_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetWeeklyCalories {
  final FoodRepository _repo;
  GetWeeklyCalories(this._repo);

  Future<Either<Failure, List<double>>> call({required DateTime endDate}) =>
      _repo.getWeeklyCalories(endDate: endDate);
}
