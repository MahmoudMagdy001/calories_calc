import 'dart:async';
import 'package:cal_scanner/core/network/api_service.dart';
import 'package:cal_scanner/core/routes/router.dart';
import 'package:cal_scanner/features/calories/data/datasources/food_local_datasource.dart';
import 'package:cal_scanner/features/calories/data/datasources/food_remote_datasource.dart';
import 'package:cal_scanner/features/calories/data/repositories/food_repository_impl.dart';
import 'package:cal_scanner/features/calories/domain/repositories/food_repository.dart';
import 'package:cal_scanner/features/calories/domain/usecases/add_food.dart';
import 'package:cal_scanner/features/calories/domain/usecases/delete_food.dart';
import 'package:cal_scanner/features/calories/domain/usecases/detect_food_from_image.dart';
import 'package:cal_scanner/features/calories/domain/usecases/get_daily_food_log.dart';
import 'package:cal_scanner/features/calories/domain/usecases/get_weekly_calories.dart';
import 'package:cal_scanner/features/calories/domain/usecases/update_food.dart';
import 'package:cal_scanner/features/calories/presentation/cubit/food_log_cubit.dart';
import 'package:cal_scanner/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:cal_scanner/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:cal_scanner/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:cal_scanner/features/onboarding/domain/usecases/calculate_goals.dart';
import 'package:cal_scanner/features/onboarding/domain/usecases/mark_onboarding_complete.dart';
import 'package:cal_scanner/features/onboarding/domain/usecases/save_user_data.dart';
import 'package:cal_scanner/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> configureDependencies({
  required SharedPreferences prefs,
  required bool showOnboarding,
}) async {
  // External
  sl
    ..registerLazySingleton<SharedPreferences>(() => prefs)
    ..registerLazySingleton<http.Client>(http.Client.new)

    // Core
    ..registerLazySingleton<ApiService>(() => ApiService(sl()))
    ..registerLazySingleton<AppRouter>(
      () => AppRouter(showOnboarding: showOnboarding, prefs: sl()),
    )
    ..registerLazySingleton<GoRouter>(() => sl<AppRouter>().router)

    // Calories
    ..registerLazySingleton<FoodLocalDataSource>(
      () => FoodLocalDataSource(sl()),
    )
    ..registerLazySingleton<FoodRemoteDataSource>(
      () => FoodRemoteDataSource(sl()),
    )
    ..registerLazySingleton<FoodRepository>(
      () => FoodRepositoryImpl(sl(), sl()),
    )
    ..registerLazySingleton<GetDailyFoodLog>(() => GetDailyFoodLog(sl()))
    ..registerLazySingleton<GetWeeklyCalories>(() => GetWeeklyCalories(sl()))
    ..registerLazySingleton<AddFood>(() => AddFood(sl()))
    ..registerLazySingleton<DeleteFood>(() => DeleteFood(sl()))
    ..registerLazySingleton<UpdateFood>(() => UpdateFood(sl()))
    ..registerLazySingleton<DetectFoodFromImage>(
      () => DetectFoodFromImage(sl()),
    )
    ..registerFactory<FoodLogCubit>(
      () {
        final cubit = FoodLogCubit(sl(), sl(), sl(), sl(), sl(), sl());
        unawaited(cubit.loadDailyLog());
        return cubit;
      },
    )

    // Onboarding
    ..registerLazySingleton<OnboardingLocalDataSource>(
      () => OnboardingLocalDataSource(sl()),
    )
    ..registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(sl()),
    )
    ..registerLazySingleton<CalculateGoals>(CalculateGoals.new)
    ..registerLazySingleton<SaveUserData>(() => SaveUserData(sl()))
    ..registerLazySingleton<MarkOnboardingComplete>(
      () => MarkOnboardingComplete(sl()),
    )
    ..registerFactory<OnboardingCubit>(
      () => OnboardingCubit(sl(), sl(), sl()),
    );
}
