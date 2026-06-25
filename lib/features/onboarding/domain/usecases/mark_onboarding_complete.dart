import 'package:cal_scanner/core/error/failure.dart';
import 'package:cal_scanner/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:fpdart/fpdart.dart';

class MarkOnboardingComplete {
  final OnboardingRepository _repo;
  MarkOnboardingComplete(this._repo);

  Future<Either<Failure, Unit>> call() =>
      _repo.setOnboardingComplete(value: true);
}
