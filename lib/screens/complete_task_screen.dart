import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart' show TaskModel;
import 'package:todo_app/widget/task_list_widget.dart' show TaskListWidget;
import 'package:shared_preferences/shared_preferences.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  List<TaskModel> completeTasks = []; // نفس اللي بـ home_screen.dart

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  //بتجيب الليست الخاصة بالتاسك
  void _loadTask() async {
    final pref = await SharedPreferences.getInstance();
    final finalTask = pref.getString('tasks');
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        // تحويل كل عنصر بالـ json لـ TaskModel عن طريق fromJson
        completeTasks =
            taskAfterDecode.map((element) => TaskModel.fromJson(element)).toList();

        // لعرض التاسكات الي خلصت بس (isDone = true)
        completeTasks =
            completeTasks.where((element) => element.isDone == true).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Completed Task")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: TaskListWidget(
          tasks: completeTasks,
          onTap: (value, index) async {
            // تحديث الحالة على الـ RAM مباشرة (مؤقتاً) عشان الـ UI يتحدث فوراً
            setState(() {
              completeTasks[index!].isDone = value ?? false; // store on ram temprature
            });

            // update task on sharedPrefrence
            final pref = await SharedPreferences.getInstance();

            final allData = pref.getString('tasks');
            if (allData != null) {
              // نجيب كل التاسكات المخزنة (مش بس المكتملة) عشان نعدل عليها ونحفظها كاملة
              List<TaskModel> allDataList = (jsonDecode(allData) as List)
                  .map((element) => TaskModel.fromJson(element))
                  .toList();

              // نلاقي مكان التاسك اللي عدلنا عليه بالليست الكاملة، بالاعتماد على الـ id
              final int newIndex =
                  allDataList.indexWhere((e) => e.id == completeTasks[index!].id);

              if (newIndex != -1) {
                // نستبدل التاسك القديم بالتاسك المعدل
                allDataList[newIndex] = completeTasks[index!];

                // نحفظ الليست الكاملة بعد التعديل بالـ SharedPreferences
                await pref.setString('tasks', jsonEncode(allDataList));
              }

              // نعيد تحميل الليست عشان الشاشة تتحدث بأحدث بيانات
              _loadTask();
            }
          },
        ),
      ),
    );
  }
}