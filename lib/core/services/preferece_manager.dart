
import 'package:shared_preferences/shared_preferences.dart';
class PreferencesManager {
  static final PreferencesManager _instance = PreferencesManager._internal();

  factory PreferencesManager() {
    return _instance;
  }

  PreferencesManager._internal();

  late final SharedPreferences _preferences;   // ✅ بـ underscore

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();   // ✅ نفس الاسم
  }

  String? getString(String key) {
    return _preferences.getString(key);   
  }
  
  Future<bool> setString(String key , String value) async{
    return await _preferences.setString(key, value) ; 
  }

    bool? getBool(String key){
      return _preferences.getBool(key);
    }
    Future<bool> setBool(String key,bool value ) async{
      return await _preferences.setBool(key, value);
    }
}