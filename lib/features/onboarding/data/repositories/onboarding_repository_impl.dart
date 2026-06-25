import 'package:cal_scanner/core/error/failure.dart';
import 'package:cal_scanner/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:cal_scanner/features/onboarding/data/models/user_data_model.dart';
import 'package:cal_scanner/features/onboarding/domain/entities/user_data.dart';
import 'package:cal_scanner/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fpdart/fpdart.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _local;
  OnboardingRepositoryImpl(this._local);

  @override
  Future<Either<Failure, UserData?>> getUserData() async {
    try {
      final model = await _local.getUserData();
      return right(model?.toDomain());
    } on Object catch (e) {
      return left(CacheFailure('Failed to read user data', cause: e));
    }
  }

  @override
  Future<Either<Failure, bool>> isOnboardingComplete() async {
    try {
      final done = await _local.isOnboardingComplete();
      return right(done);
    } on Object catch (e) {
      return left(CacheFailure('Failed to read onboarding status', cause: e));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveUserData(UserData userData) async {
    try {
      await _local.saveUserData(UserDataModel.fromDomain(userData));
      return right(unit);
    } on Object catch (e) {
      return left(CacheFailure('Failed to save user data', cause: e));
    }
  }

  @override
  Future<Either<Failure, Unit>> setOnboardingComplete({
    required bool value,
  }) async {
    try {
      await _local.setOnboardingComplete(value: value);
      return right(unit);
    } on Object catch (e) {
      return left(CacheFailure('Failed to write onboarding status', cause: e));
    }
  }
}
