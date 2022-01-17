import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static getData({required key}) {
    return sharedPreferences.get(key);
  }

  static Future<bool> saveData({
    required key,
    required value,
  }) async {
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);

    return await sharedPreferences.setString(key, value);
  }

  static Future<bool> removeData({
    required key,
  }) async {
    return await sharedPreferences.remove(key);
  }
}
