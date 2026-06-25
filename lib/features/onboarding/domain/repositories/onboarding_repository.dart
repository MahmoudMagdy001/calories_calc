import 'package:cal_scanner/core/error/failure.dart';
import 'package:cal_scanner/features/onboarding/domain/entities/user_data.dart';
import 'package:fpdart/fpdart.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, Unit>> saveUserData(UserData userData);
  Future<Either<Failure, UserData?>> getUserData();

  Future<Either<Failure, bool>> isOnboardingComplete();
  Future<Either<Failure, Unit>> setOnboardingComplete({required bool value});
}
