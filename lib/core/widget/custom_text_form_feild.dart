//sharedComponant: التيكست فيلد الي رح احط فيه اسم المستخدم
import 'package:flutter/material.dart';

class CustomTextFormFeild extends StatelessWidget {
const CustomTextFormFeild ({super.key , required this.controller
,this.maxLines, required this.hintText,
this.validator, required this.title});

//الاشياء المشتركة الي رح يختلفوا من سكرين والتانية رح اببعتهم بالسكرين كبباريميتر وهناك بكت ايش بدي
final TextEditingController controller;
final int? maxLines;
final String hintText;
final String? Function(String?)? validator;
final String title;
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
         Text('task name',
              style: TextStyle(
                color: Color(0xFFFFFCFC),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              ),
      SizedBox(height: 8,),
       TextFormField( // have a parent named form
                    // كل ما يصير تعديل ع الاسم الي رح يدخله المستخدم بناديها ورح يخزن الاسم الجديد
                   controller: controller, //بوخد controller الي اعملته
                    style: TextStyle(  //تنسيقات النص
                   
                      color: Colors.white , //لون النص الي رح يكتبه المستخدم
                     
                    ),
                   
                     validator: validator != null ? (String? value) => validator!(value): null,
                       maxLines: maxLines, //لتكبير حجم textFormField
                   //maxLines: maxLines, //لتكبير حجم textFormField
                   decoration: InputDecoration( //بسمح لللمستخدم يكتب جواته كانه textbox
                   hintText: hintText,//'finish on bording UI and hand of to dev during sunday ' , //تلميحة للمستخدم ايش يكتب
                   hintStyle: TextStyle(color: Color(0xFF6D6D6D)), // color of hint text
                   
                   filled: true, //سمحت اعطي الخلفية لون
                   fillColor: Color(0xFF282828), // لون الخلفية لمربع النص
                   border:OutlineInputBorder(
                   borderRadius: BorderRadius.circular(16),
                   borderSide: BorderSide.none
                   )
                   
                   ),
                   cursorColor: Colors.white,
                   ),
    ],
    );
  }
}