
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';import 'package:shared_preferences/shared_preferences.dart';
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
                 controller: taskNameController, //بوخد controller الي اعملته
                  style: TextStyle(  //تنسيقات النص
                 
                    color: Colors.white , //لون النص الي رح يكتبه المستخدم
                  ),
                 
                 validator: (String? value){
                  if(value?.trim().isEmpty ?? false){ // ادا ما دخل المستخدم اسم وكبس ع الباتون
                    return "please enter task name";
                  }
                  return null;
                  
                 },
                 decoration: InputDecoration( //بسمح لللمستخدم يكتب جواته كانه textbox
                 hintText: 'inish UI design to login screen' , //تلميحة للمستخدم ايش يكتب
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
            SizedBox(height: 20,),
          
              SizedBox(height: 8,),
              Text('task description',
              style: TextStyle(
                color: Color(0xFFFFFCFC),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              
              ),
            
          SizedBox(height: 8,),
          
            TextFormField( // have a parent named form
                  // كل ما يصير تعديل ع الاسم الي رح يدخله المستخدم بناديها ورح يخزن الاسم الجديد
                 controller: taskDescriptionController, //بوخد controller الي اعملته
                  style: TextStyle(  //تنسيقات النص
                 
                    color: Colors.white , //لون النص الي رح يكتبه المستخدم
                  ),
                 
                
                 maxLines: 4, //لتكبير حجم textFormField
                 decoration: InputDecoration( //بسمح لللمستخدم يكتب جواته كانه textbox
                 hintText: 'finish on bording UI and hand of to dev during sunday ' , //تلميحة للمستخدم ايش يكتب
                 hintStyle: TextStyle(color: Color(0xFF6D6D6D)), // color of hint text
                 
                 filled: true, //سمحت اعطي الخلفية لون
                 fillColor: Color(0xFF282828), // لون الخلفية لمربع النص
                 border:OutlineInputBorder(
                 borderRadius: BorderRadius.circular(16),
                 borderSide: BorderSide.none
                 )
                 
                 ),
                 cursorColor: Colors.white,
                 ),SizedBox(height: 8,),
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
               // json: بوخد مني الاوبجكت ع key and value
                             //key , value
               //final task = <String, dynamic>{
                //"taskName": taskNameController.text, //اخدت الاسم
                //"taskDescription": taskDescriptionController.text, // اخدت الوصف
                //"isHighPrio" : isHighPrio,
              // };
              
               
                //listTasks.add(task); // add to list
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