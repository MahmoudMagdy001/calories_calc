import 'dart:convert';

import 'package:cal_scanner/features/onboarding/data/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static const String _userDataKey = 'userData';

  final SharedPreferences prefs;

  PreferenceManager(this.prefs);

  Future<void> saveUserData(UserData userData) async {
    final userDataJson = jsonEncode(userData.toJson());
    await prefs.setString(_userDataKey, userDataJson);
  }

  UserData? getUserData() {
    final userDataJson = prefs.getString(_userDataKey);
    if (userDataJson != null) {
      final userDataMap = jsonDecode(userDataJson) as Map<String, dynamic>;
      return UserData.fromJson(userDataMap);
    }
    return null;
  }

  Future<void> clearUserData() async {
    await prefs.remove(_userDataKey);
  }
}
