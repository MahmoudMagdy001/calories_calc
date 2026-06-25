import 'package:cal_scanner/core/error/failure.dart';
import 'package:cal_scanner/core/utils/calorie_calculator.dart';
import 'package:cal_scanner/features/onboarding/domain/entities/user_data.dart';
import 'package:fpdart/fpdart.dart';

class CalculateGoals {
  Future<Either<Failure, UserData>> call({
    required double weight,
    required double heightCm,
    required int age,
    required String activityLevel,
    required String gender,
    required String goal,
  }) async {
    try {
      final maintenance = CalorieCalculator.fallbackEstimateCalories(
        weight: weight,
        height: heightCm,
        age: age,
        activityLevel: activityLevel,
        gender: gender,
      );

      final adjusted = CalorieCalculator.calculateCaloriesBasedOnGoal(
        maintenanceCalories: maintenance,
        goal: goal,
      );

      final macros = CalorieCalculator.calculateMacroGoals(
        calories: adjusted,
        goal: goal,
      );

      return right(
        UserData(
          weight: weight,
          heightCm: heightCm,
          age: age,
          activityLevel: activityLevel,
          gender: gender,
          goal: goal,
          estimatedCalories: adjusted,
          proteinGoal: macros['proteinGoal']!,
          fatGoal: macros['fatGoal']!,
          carbsGoal: macros['carbsGoal']!,
        ),
      );
    } on Object catch (e) {
      return left(Failure('Failed to calculate goals', cause: e));
    }
  }
}
