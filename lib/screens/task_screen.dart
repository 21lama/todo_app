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
   bool isCheck = false; //default value for checkBox
  List<TaskModel> task = []; // نفس اللي بـ home_screen.dart

  @override
   void initState() {
    super.initState();
    _loadTask();
  }
  //بتجيب الليست الخاصة بالتاسك
  void _loadTask() async {
    final pref = await SharedPreferences.getInstance();
    final finalTask = pref.getString('tasks');
    if(finalTask !=null){
    final taskAfterDecode = jsonDecode(finalTask ?? "") as List<dynamic>;
     
   final tasks = taskAfterDecode.map((element) {
  return TaskModel(
    taskName: element["taskName"],
    taskDescription: element["taskDescription"],
    isHighPrio: element["isHighPrio"],
  );
}).toList();

setState(() {
  task = taskAfterDecode.map((element) => TaskModel.fromJson(element)).toList();
  task=task.where((element) => element.isDone == false).toList(); //لعرض التاسكات الي لسا ما خلصتها
});
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar : AppBar(title : Text("To Do Task")),
      body: Padding(
        padding: EdgeInsets.all(16),
       child:TaskListWidget(tasks: task,
       onTap: (value, index) async{
         setState(() {
              task[index!].isDone = value ?? false; // store on ram temprature
                                      
               });
             // update task on sharedPrefrence
             final pref = await SharedPreferences.getInstance();
            final updateTask = task.map((element) => element.toMap() ).toList();
             final allData= pref.getString("tasks");
           pref.setString('tasks',jsonEncode(updateTask) );
           List<TaskModel> allDataList= (jsonDecode(allData) as List).map(element ) =>TaskModel.fromJson(element)).toString();
            _loadTask();
       },
       ),
        )
    );
  }
}