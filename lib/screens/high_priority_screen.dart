import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/task_model.dart' show TaskModel;
import 'package:todo_app/widget/task_list_widget.dart' show TaskListWidget;

class HighPriorityScreen extends StatefulWidget {
  const HighPriorityScreen({super.key});

  @override
  State<HighPriorityScreen> createState() => _HighPriorityScreenState();
}

class _HighPriorityScreenState extends State<HighPriorityScreen> {
  // القائمة الي رح نعرضها بهاي الشاشة (بس التاسكات ذات الأولوية العالية)
  List<TaskModel> highPriorityTasks = [];

  // مشان نعرض دائرة تحميل لحد ما تجهز البيانات
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    _loadTask(); // بتنفذ مرة وحدة أول ما تفتح الشاشة
  }

  // بتجيب كل التاسكات، وبتفلتر بس اللي أولوية عالية
  void _loadTask() async {
    setState(() {
      isloading = true; // بلشنا التحميل
    });

    final pref = await SharedPreferences.getInstance();
    final finalTask = pref.getString('tasks'); // كل التاسكات مخزنة هون

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        // حولنا كل عنصر من JSON لكائن TaskModel
        highPriorityTasks =
            taskAfterDecode.map((element) => TaskModel.fromJson(element)).toList();

        // فلترنا بس التاسكات ذات الأولوية العالية (isHighPrio = true)
        highPriorityTasks =
            highPriorityTasks.where((element) => element.isHighPrio).toList().reversed.toList();
      });
    }

    setState(() {
      isloading = false; // خلص التحميل
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('High Priority Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isloading
            ? Center(child: CircularProgressIndicator())
            : TaskListWidget(
                tasks: highPriorityTasks, // ✅ استخدمنا الاسم الصح المعرّف بالكلاس
                onTap: (value, index) async {
                  // 1) عدلنا حالة isDone بالقائمة المحلية (highPriorityTasks) فقط، بالذاكرة
                  setState(() {
                    highPriorityTasks[index!].isDone = value ?? false;
                  });
        
                  // 2) بما إنه هاي شاشة مفلترة (بس أولوية عالية)، لازم نحدث
                  //    التعديل بالقائمة الأصلية الكاملة المخزنة تحت مفتاح 'tasks'،
                  //    مش نستبدلها بالكامل بقائمة highPriorityTasks (لأنها ناقصة تاسكات تانية)
                  final pref = await SharedPreferences.getInstance();
                  final allData = pref.getString('tasks');
        
                  if (allData != null) {
                    // جبنا القائمة الكاملة الأصلية (كل التاسكات، مش بس أولوية عالية)
                    List<TaskModel> allDataList = (jsonDecode(allData) as List)
                        .map((element) => TaskModel.fromJson(element))
                        .toList();
        
                    // لاقينا مكان التاسك المعدّلة بالقائمة الكاملة عن طريق الـ id
                    final int newIndex = allDataList
                        .indexWhere((e) => e.id == highPriorityTasks[index!].id);
        
                    // استبدلنا التاسك القديمة بالنسخة المعدّلة
                    allDataList[newIndex] = highPriorityTasks[index!];
        
                    // خزّنا القائمة الكاملة (بعد التعديل) من جديد
                    await pref.setString('tasks', jsonEncode(allDataList));
        
                    // أعدنا تحميل الشاشة عشان تعرض آخر تحديث
                    _loadTask();
                  }
                },
              ),
      ),
    );
  }
}