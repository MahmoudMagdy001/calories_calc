import 'dart:convert';
import 'dart:io';

import 'package:cal_scanner/features/calories/data/models/food_item.dart';
import 'package:cal_scanner/features/calories/data/services/food_service.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodRepository {
  final FoodService _foodService;
  final SharedPreferences _prefs;

  FoodRepository(this._foodService, this._prefs);

  Future<List<FoodItem>> getDailyFoodLog(DateTime date) async {
    final key = 'food_log_${date.toIso8601String().split('T')[0]}';
    final storedData = _prefs.getString(key);

    if (storedData != null) {
      final jsonList = json.decode(storedData) as List<dynamic>;
      return jsonList
          .map((json) => FoodItem.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> addFoodItem(FoodItem item) async {
    final key = 'food_log_${item.timestamp.toIso8601String().split('T')[0]}';
    final currentLog = await getDailyFoodLog(item.timestamp);
    currentLog.add(item);

    await _prefs.setString(
      key,
      json.encode(currentLog.map((item) => item.toJson()).toList()),
    );
  }

  Future<Either<String, FoodItem>> detectFoodFromImage(File image) async =>
      _foodService.detectFoodAndCalories(image);

  Future<void> deleteFoodItem(FoodItem item) async {
    final key = 'food_log_${item.timestamp.toIso8601String().split('T')[0]}';
    final currentLog = await getDailyFoodLog(item.timestamp);
    currentLog.removeWhere((existingItem) => existingItem.id == item.id);

    await _prefs.setString(
      key,
      json.encode(currentLog.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> updateFoodItem(FoodItem item) async {
    final key = 'food_log_${item.timestamp.toIso8601String().split('T')[0]}';
    final currentLog = await getDailyFoodLog(item.timestamp);
    final index = currentLog.indexWhere(
      (existingItem) => existingItem.id == item.id,
    );

    if (index != -1) {
      currentLog[index] = item;
      await _prefs.setString(
        key,
        json.encode(currentLog.map((item) => item.toJson()).toList()),
      );
    }
  }
}
