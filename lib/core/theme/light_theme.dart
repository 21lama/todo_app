
import 'package:flutter/material.dart';

ThemeData lightTheme =ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primaryContainer: Color(0xFFFFFFFF)
  ),
    
        //لون خلفية مشترك لكل السكرين لانه السكافولد بتوخد القيمة الموجودة هوت في المتيريال اب
         scaffoldBackgroundColor: Color(0xFFF6F7F9),//لون
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFF6F7F9), //لون خلفية الشاشة
          titleTextStyle: TextStyle(
            color: Color(0xFF161f18), //لون النص الي رح يظهر ع appBar
            fontSize: 20,
          ),
       centerTitle: true,
       iconTheme: IconThemeData(
        color: Color(0xFF161F18),
       ),
        ),
        
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Color(0xFF15B86C)),
                        foregroundColor: WidgetStateProperty.all(Color(0xFFFFFCFC)),
          ),
        ),
        useMaterial3: true,
      
  textTheme: TextTheme(
            displaySmall: TextStyle(
              fontSize: 24,
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w400,
            ),
  

            displayMedium: TextStyle(
              fontSize: 28,
              color: Color(0xFF161f18),
              fontWeight: FontWeight.w400,
            ),
            titleSmall: TextStyle(
               fontSize: 14,
              color: Color(0xFF3A4640),
              fontWeight: FontWeight.w400,
            ),
            
            titleMedium: TextStyle(
               fontSize: 16,
              color: Color(0xFF161F18),
              fontWeight: FontWeight.w400,
            ),
            
            
           titleLarge: TextStyle(
               fontSize: 32,
              color: Color(0xFF161F18),
              fontWeight: FontWeight.w400,
            ),
            labelMedium: TextStyle(color: Colors.black) , //لون النص الي رح يكتبه المستخدم
                     
         
          ),
    
            
    inputDecorationTheme: InputDecorationTheme(
           hintStyle: TextStyle(color: Color(0xFF9E9E9E)), // color of hint text
         
            
                   filled: true, //سمحت اعطي الخلفية لون
                   fillColor: Color(0xFFFFFFFF), // لون الخلفية لمربع النص
                   border:OutlineInputBorder(
                   borderRadius: BorderRadius.circular(16),
                   borderSide: BorderSide.none
                   )
         )
);

          




