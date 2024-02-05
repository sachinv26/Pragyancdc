import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String keyUserId = 'user_id';

  // Set user ID to shared preferences
  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserId, userId);
  }

  // Get user ID from shared preferences
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserId);
  }

  // Clear user ID from shared preferences
  static Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUserId);
  }
}
