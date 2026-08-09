
import 'package:flutter/material.dart';
import 'package:todo_app/core/services/preferece_manager.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/main_screen.dart';
import 'package:todo_app/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // اول 4 مكافئين لبعض لكن هون استخدنا شيرد بريفرنس انا بنيتها
  await PreferencesManager().init();
  String? username= PreferencesManager().getString('username');
  //final pref = await SharedPreferences.getInstance();
 
  //String? username= pref.getString('username');

  runApp( MyApp(username: username,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.username});
final String? username;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tasky',
      theme: ThemeData(
        //لون خلفية مشترك لكل السكرين لانه السكافولد بتوخد القيمة الموجودة هوت في المتيريال اب
        scaffoldBackgroundColor: Color(0xFF181818),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF181818), //لون خلفية الشاشة
          titleTextStyle: TextStyle(
            color: Color(0xFFFFFCFC), //لون النص الي رح يظهر ع appBar
            fontSize: 20,
          ),
       centerTitle: false,
       iconTheme: IconThemeData(
        color: Color(0xfffffcfc),
       ),
        ),
        
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Color(0xFF15B86C)),
                        foregroundColor: WidgetStateProperty.all(Color(0xFFFFFCFC)),
          ),
        ),
        useMaterial3: true,
      ),
      
      //ادا كان المستخدم مدخل اسمه ببعت~ه ع الهوم سكرين مباشرة
      home: username == null ? WelcomeScreen() : MainScreen(),
    );
  }
}