// هون بعرض التاسكات الي لسا ما خلصتهم

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widget/task_list_widget.dart' show TaskListWidget;

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
   
   List<TaskModel> toDoTasks = []; // نفس اللي بـ home_screen.dart
   bool isCheck = false; //default value for checkBox
   bool isloading = false;
  
  @override
   void initState() {
    super.initState();
    _loadTask();
  }
  //بتجيب الليست الخاصة بالتاسك
 void _loadTask() async {
  setState(() {
    isloading = true;
  });

  final pref = await SharedPreferences.getInstance();
  final finalTask = pref.getString('tasks');

  if (finalTask != null) {
    final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
    setState(() {
      toDoTasks = taskAfterDecode.map((element) => TaskModel.fromJson(element)).toList();
      toDoTasks = toDoTasks.where((element) => element.isDone == false).toList();
    });
  }

  setState(() {
    isloading = false;  
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar : AppBar(title : Text("To Do Task")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: isloading ? Center (child: CircularProgressIndicator(value:20,))
       :TaskListWidget(tasks: toDoTasks,
       onTap: (value, index) async{
         setState(() {
              toDoTasks[index!].isDone = value ?? false; // store on ram temprature
                                      
               });
             // update task on sharedPrefrence
             final pref = await SharedPreferences.getInstance();
            //final updateTask = tasks.map((element) => element.toMap() ).toList();
             //final allData= pref.getString("tasks");
          // pref.setString('tasks',jsonEncode(allDataList) );
          
          final allData = pref.getString('tasks');
          if (allData != null){
         List<TaskModel> allDataList =
   (jsonDecode(allData) as List)
        .map((element) => TaskModel.fromJson(element))
        .toList();
        final int newIndex = allDataList.indexWhere((e) => e.id == toDoTasks[index!].id);
        allDataList[newIndex] = toDoTasks[index!];
           pref.setString('tasks',jsonEncode(allDataList) );pref.setString('tasks',jsonEncode(allDataList) );
            _loadTask();
       }
       },
       ),
        )
    );
  }
}