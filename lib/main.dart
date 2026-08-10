
import 'package:flutter/material.dart';
import 'package:todo_app/core/services/preferece_manager.dart';
import 'package:todo_app/core/theme/dark_theme.dart';
import 'package:todo_app/core/theme/light_theme.dart';
import 'package:todo_app/screens/main_screen.dart';
import 'package:todo_app/screens/welcome_screen.dart';

//value notifier مشان انتقل من دارك ل لايت والعكس
ValueNotifier<ThemeMode> themeNotifier= ValueNotifier(ThemeMode.light);
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // اول 4 مكافئين لبعض لكن هون استخدنا شيرد بريفرنس انا بنيتها
  await PreferencesManager().init();
  String? username= PreferencesManager().getString('username');
  //final pref = await SharedPreferences.getInstance();
 
  //String? username= pref.getString('username');
   themeNotifier.value= ThemeMode.dark;
  runApp( MyApp(username: username,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.username});
final String? username;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder:(context, ThemeMode value , Widget? child){
           return  MaterialApp(
        title: 'tasky',
        theme: lightTheme,
        darkTheme: darktheme,
        themeMode:value,
        //ادا كان المستخدم مدخل اسمه ببعت~ه ع الهوم سكرين مباشرة
        home: username == null ? WelcomeScreen() : MainScreen(),
      );
        }
      
    );
  }
}