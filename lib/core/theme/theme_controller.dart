
//التعامل مع كل theme هون
//value notifier مشان انتقل من دارك ل لايت والعكس
import 'package:flutter/material.dart';
import 'package:todo_app/core/services/preferece_manager.dart' show PreferencesManager;
class ThemeController {
static final ValueNotifier<ThemeMode> themeNotifier= ValueNotifier(ThemeMode.dark);

init(){

  bool result = PreferencesManager().getBool("theme") ?? true;
  if(result == true){
    themeNotifier.value =ThemeMode.dark; }
    else{themeNotifier.value =ThemeMode.light;}
}

static toggleTheme() async {
  if(themeNotifier.value == ThemeMode.dark){
    themeNotifier.value = ThemeMode.light;
    await PreferencesManager().setBool("theme", false);
  }
  else{themeNotifier.value == ThemeMode.light;
        await PreferencesManager().setBool("theme", true);
        }
}


}
