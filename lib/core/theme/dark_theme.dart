import 'package:flutter/material.dart';

ThemeData darktheme =ThemeData(
  brightness: Brightness.dark,
  //لون خلفية الكونتينار
  colorScheme: ColorScheme.dark(
    primaryContainer: Color(0xFF282828)
  ),
        //لون خلفية مشترك لكل السكرين لانه السكافولد بتوخد القيمة الموجودة هوت في المتيريال اب
         scaffoldBackgroundColor: Color(0xFF181818),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF181818), //لون خلفية الشاشة
          titleTextStyle: TextStyle(
            color: Color(0xFFFFFCFC), //لون النص الي رح يظهر ع appBar
            fontSize: 20,
          ),
       centerTitle: true,
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
        //الثيم للنصوص لما يتغير الثيم للتطبيق الى غامق
          textTheme: TextTheme(

            displaySmall: TextStyle(
              fontSize: 24,
              color: Color(0xFFFFFCFC),
              fontWeight: FontWeight.w400,
            ),
            displayMedium: TextStyle(
              fontSize: 28,
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w400,
            ),
           
            titleSmall: TextStyle(
               fontSize: 14,
              color: Color(0xFF6c6c6c),
              fontWeight: FontWeight.w400,
            ),
            titleMedium: TextStyle(
               fontSize: 16,
              color: Color(0xFFFFFCFC),
              fontWeight: FontWeight.w400,
            ),
           
           titleLarge: TextStyle(
               fontSize: 32,
              color: Color(0xFFFFFCFC),
              fontWeight: FontWeight.w400,
            ),
           
            
           labelMedium: TextStyle(color: Colors.white) , //لون النص الي رح يكتبه المستخدم
          //for done task
          
          
          ),

         inputDecorationTheme: InputDecorationTheme(
           hintStyle: TextStyle(color: Color(0xFF6D6D6D)), // color of hint text
         
            
                   filled: true, //سمحت اعطي الخلفية لون
                   fillColor: Color(0xFF282828), // لون الخلفية لمربع النص
                   border:OutlineInputBorder(
                   borderRadius: BorderRadius.circular(16),
                   borderSide: BorderSide.none
                   )
         )

);
