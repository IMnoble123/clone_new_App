import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreference {
  late SharedPreferences preferences;

  static final AppSharedPreference _appSharedPreference =
      AppSharedPreference.internal();

  AppSharedPreference.internal();

  factory AppSharedPreference() {
    SharedPreferences.getInstance().then((prefs) {
      _appSharedPreference.preferences = prefs;
    });
    return _appSharedPreference;
  }

  Future<bool> saveStringData(String key, String value) async {
    /*await SharedPreferences.getInstance()
        .then((prefs) => prefs.setString(key, value));*/
    bool b = await preferences.setString(key, value);
    return b;
  }

  Future<String> getStringData(String key) async {
    return preferences.getString(key) ?? '';
  }

  Future<bool> saveBoolData(String key, bool value) async {
    bool b = await preferences.setBool(key, value);
    return b;
  }

  Future<bool> getBool(String key,{defaultValue = false}) async {
    /* final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;*/

    return preferences.getBool(key) ?? defaultValue;
  }




}
