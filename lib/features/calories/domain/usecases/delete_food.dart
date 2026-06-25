import 'package:cal_scanner/core/error/failure.dart';
import 'package:cal_scanner/features/calories/domain/entities/food.dart';
import 'package:cal_scanner/features/calories/domain/repositories/food_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteFood {
  final FoodRepository _repo;
  DeleteFood(this._repo);

  Future<Either<Failure, Unit>> call(Food food) => _repo.deleteFood(food);
}
