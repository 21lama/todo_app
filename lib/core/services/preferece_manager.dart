class PreferencesManager {
  static final PreferencesManager _instance = PreferencesManager._internal();

  factory PreferencesManager() {
    return _instance;
  }

  PreferencesManager._internal();

  late final SharedPreferences _preferences;   // ✅ بـ underscore

  init() async {
    _preferences = await SharedPreferences.getInstance();   // ✅ نفس الاسم
  }

  String? getString(String key) {
    return _preferences.getString(key);   // ✅ نفس الاسم
  }
}