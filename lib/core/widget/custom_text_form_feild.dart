//sharedComponant: التيكست فيلد الي رح احط فيه اسم المستخدم

import 'package:flutter/material.dart';

class CustomTextFormFeild extends StatelessWidget {
  const CustomTextFormFeild({
    super.key,
    required this.controller,
    this.maxLines,
    required this.hintText,
    this.validator,
    required this.title,
  });

  //الاشياء المشتركة الي رح يختلفوا من سكرين والتانية رح اببعتهم بالسكرين كبباريميتر وهناك بكت ايش بدي
  final TextEditingController controller;
  final int? maxLines;
  final String hintText;
  final String? Function(String?)? validator;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFFFFFCFC),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),

        SizedBox(height: 8),

        TextFormField(
          // have a parent named form

          // كل ما يصير تعديل ع الاسم الي رح يدخله المستخدم بناديها ورح يخزن الاسم الجديد
          controller: controller, //بوخد controller الي اعملته

          style: Theme.of(context).textTheme.labelMedium,

          validator: validator != null
              ? (String? value) => validator!(value)
              : null,

          maxLines: maxLines, //لتكبير حجم textFormField

          decoration: InputDecoration(
            //بسمح لللمستخدم يكتب جواته كانه textbox
            hintText: hintText, //تلميحة للمستخدم ايش يكتب
          ),

          cursorColor: Colors.white,
        ),
      ],
    );
  }
}