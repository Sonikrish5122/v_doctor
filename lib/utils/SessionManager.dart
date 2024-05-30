import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_doctor/Model/LoginModel.dart';

class SessionManager {
  static String userModel = 'userModel';
  static String userEmail = 'email';
  static String userUid = 'uid';
  static String accessToken = 'accessToken';

  void setUserInfo(String jsonEncode) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(SessionManager.userModel, jsonEncode);
    });
  }

  Future<UserData?> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(SessionManager.userModel);
    if (jsonString != null) {
      final valueMap = json.decode(jsonString);
      return UserData.fromJson(valueMap);
    } else {
      return null;
    }
  }
}


class ProfileManager {
  static const String _keyName = 'name';

  Future<void> saveName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
  }


  Future<String?> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }
}

