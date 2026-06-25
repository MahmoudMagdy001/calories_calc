import 'package:cal_scanner/core/error/failure.dart';
import 'package:cal_scanner/features/onboarding/domain/entities/user_data.dart';
import 'package:cal_scanner/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveUserData {
  final OnboardingRepository _repo;
  SaveUserData(this._repo);

  Future<Either<Failure, Unit>> call(UserData userData) =>
      _repo.saveUserData(userData);
}
