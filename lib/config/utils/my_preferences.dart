import 'package:shared_preferences/shared_preferences.dart';

class MyPrefrences {
  static late SharedPreferences _prefs;
  static String guestLogin = "guestLogin";
  static String guestGuidUser = "guestGuidUser";
  static String guidUser = "guidUser";
  static String token = "token";
  static String currency = "currency";
  static String language = "selectedlanguage";
  static String forgetPasswordID = "forgetPasswordID";
  static String userID = "userID";
  static String registerUserID = "registerUserID";

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save String value
  static Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// Get String value
  static String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Save int value
  static Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  // Get int value
  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Save boolean value
  static Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  // Get boolean value
  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Save double value
  static Future<bool> saveDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  // Get double value
  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // Remove a key-value pair
  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Clear all data
  static Future<bool> clear() async {
    return await _prefs.clear();
  }
}
