import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/core/widget/custom_text_form_feild.dart';
import 'package:todo_app/models/task_model.dart';

class AddTask extends StatefulWidget {
   const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
// each controller for each textFormField انا بعمل اكسس عليه من خلال الكونترولار
   final TextEditingController taskNameController=TextEditingController();

   final TextEditingController taskDescriptionController= TextEditingController();

   final GlobalKey<FormState> _key= GlobalKey<FormState>() ;

   bool isHighPrio= true; // مشان اغير حالة السويتش
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: Color(0xFF181818),
        centerTitle: false,
        title:
         Text(
          'new task',
            style: TextStyle(
              color: Color(0xFFFFFCFC),
              fontSize: 20,
            ),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFFFFFCFC),
        ),
      ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
        child: Form(
            key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //بدل ما اكتب الكود بكل شاشة حطيته بملف منفصل وصرت اناديه عند الحاجة
              CustomTextFormFeild(
                controller: taskNameController,
                title: 'task name',
                hintText: 'inish UI design to login screen',
                validator: (String? value){
                  if(value?.trim().isEmpty ?? false){ // ادا ما دخل المستخدم اسم وكبس ع الباتون
                    return "please enter task name";
                  }
                  return null;
                },
              ),

            SizedBox(height: 20,),

          //بدل ما اكتب الكود بكل شاشة حطيته بملف منصل وصرت اناديه عند الحاجة
          CustomTextFormFeild(
            controller: taskDescriptionController,
            title: 'task description',
            maxLines: 5,
            hintText: 'nish on bording UI and hand of to dev during sunday ',
          ),

                 SizedBox(height: 8,),
         SizedBox(height: 20,),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween ,  //مسافة بين السويتش والنص
           children: [
            Text ("High priority",
            style: TextStyle(
              color: Color(0xFFFFFCFC),
              fontSize: 16,
            ),
            ),
             Switch(
              value: isHighPrio,
               onChanged: (bool value){
              
              setState(() {
                isHighPrio = value;
              });
              
             },
             activeTrackColor: Color(0xFF15B86C) , //لون السويتش الي بالنص
             
             
             ),
           ],
         ),
          Spacer(),
             ElevatedButton.icon(    // ادا محتوى الباتون يحتوي ع ايقونة ونص بستخدم .icon
            style:ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF15B86C) ,//خلفيته
                    foregroundColor: Color(0xFFFFFCFC), // لون المحتوى متل بعض ف هيك اسهل الهم كلهم
                 fixedSize:Size(MediaQuery.of(context).size.width,48) ,
                  ),
                  icon:Icon(Icons.add),     
                  label: Text("add task"),
            onPressed: () async{
              if(_key.currentState?.validate() ?? false){}
              final pref = await SharedPreferences.getInstance(); 
               final taskJson = pref.getString("tasks"); // جيب التاسك القديمة
               
               //مشان اجيب التاسكات القديمة
               List<dynamic> listTasks= [];
               if(taskJson != null){
                listTasks = jsonDecode(taskJson); //بعد ما فكيت تشفيرها ورجعتها ل داينمك هون جاب التاسك القديمة
               }

               TaskModel model = TaskModel(
                id: listTasks.length+1,
                taskName: taskNameController.text, 
               taskDescription: taskDescriptionController.text,
                isHighPrio: isHighPrio);

                 listTasks.add(model.toMap());
               final taskEncode = jsonEncode(listTasks); //حولتهم من key and value to string
               await pref.setString("tasks", taskEncode);
          
               Navigator.of(context).pop();
           
            } ,
            
            ),
            
            
            
            ],
          ),
        ),
      ),
    ),

    );
  }
}