import 'dart:convert';

import 'package:cal_scanner/features/onboarding/data/models/user_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalDataSource {
  static const String _userDataKey = 'userData';
  static const String _onboardingCompleteKey = 'onboarding_complete';

  final SharedPreferences _prefs;
  OnboardingLocalDataSource(this._prefs);

  Future<void> saveUserData(UserDataModel userData) async {
    await _prefs.setString(_userDataKey, jsonEncode(userData.toJson()));
  }

  Future<UserDataModel?> getUserData() async {
    final raw = _prefs.getString(_userDataKey);
    if (raw == null) return null;
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return null;
    return UserDataModel.fromJson(Map<String, dynamic>.from(decoded));
  }

  Future<bool> isOnboardingComplete() async =>
      _prefs.getBool(_onboardingCompleteKey) ?? false;

  Future<void> setOnboardingComplete({required bool value}) async {
    await _prefs.setBool(_onboardingCompleteKey, value);
  }
}
