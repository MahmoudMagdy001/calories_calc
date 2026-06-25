import 'package:cal_scanner/core/error/failure.dart';
import 'package:cal_scanner/features/calories/domain/entities/food.dart';
import 'package:cal_scanner/features/calories/domain/repositories/food_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateFood {
  final FoodRepository _repo;
  UpdateFood(this._repo);

  Future<Either<Failure, Unit>> call(Food food) => _repo.updateFood(food);
}
