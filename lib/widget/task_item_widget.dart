import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/core/enum/task_iem_action_enum.dart' show TaskItemActionsEnum;

// هذا الويدجت مسؤول عن عرض تاسك واحدة بس (بديل الـ Container اللي كان جوا
// ListView.builder بملف task_list_widget.dart)
// المستخدم يقدر: يعمل Complete / Edit (اسم+وصف+أهمية) / Delete
class TaskItemWidget extends StatefulWidget {
  final TaskModel task;
  final int index;

  // نفس توقيع onTap المستخدم بكل مكان بمشروعك (HomeScreen وغيرها)
  // عشان الـ Checkbox والـ "اعملها كومبليت" يشتغلوا بنفس طريقة الحفظ الموجودة عندك
  final Function(bool?, int?) onTap;

  // بينادى بعد Edit أو Delete عشان الشاشة الأب (اللي فيها الـ List) تعمل _loadTask()
  // وتحدث نفسها. لو ما بدك تستخدمها هلق، سيبها فاضية بمكان الاستدعاء
  final VoidCallback? onTaskUpdated;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.index,
    required this.onTap,
    this.onTaskUpdated,
  });

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  // =======================================================
  // حذف التاسك مباشرة من SharedPreferences
  // =======================================================
  Future<void> _deleteTask() async {
    final shouldDelete = await _showDeleteDialog();
    if (!shouldDelete) return; // المستخدم ضغط Cancel

    final pref = await SharedPreferences.getInstance();
    final allData = pref.getString('tasks');
    if (allData == null) return;

    // نجيب كل التاسكات المخزنة (الليستة الكاملة) عشان نشيل منها التاسك المطلوب
    List<TaskModel> allDataList = (jsonDecode(allData) as List)
        .map((element) => TaskModel.fromJson(element))
        .toList();

    // نشيل التاسك اللي نفس id تبعها id تبع التاسك الحالية
    allDataList.removeWhere((e) => e.id == widget.task.id);

    // نحفظ الليستة بعد الحذف
    await pref.setString(
      'tasks',
      jsonEncode(allDataList.map((e) => e.toMap()).toList()),
    );

    // منادي الشاشة الأب عشان تعمل refresh (لو موجودة الدالة)
    widget.onTaskUpdated?.call();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task deleted successfully")),
    );
  }

  // بوب اب تأكيد الحذف
  Future<bool> _showDeleteDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task?"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
    return result ?? false; // لو المستخدم أغلق البوب اب بدون اختيار، منعتبرها Cancel
  }

  // =======================================================
  // تعديل التاسك (اسم + وصف + أهمية بس، بدون تاريخ أو صورة لسا)
  // =======================================================
  Future<void> _editTask() async {
    final updatedTask = await showModalBottomSheet<TaskModel>(
      context: context,
      isScrollControlled: true, // مشان الشيت ياخد مساحة أكبر ويصير فيه كيبورد
      backgroundColor: Colors.transparent,
      builder: (context) => _EditTaskSheet(task: widget.task),
    );

    // لو المستخدم سكر الشيت بدون Save، بترجع null فما في شي نعمله
    if (updatedTask == null) return;

    final pref = await SharedPreferences.getInstance();
    final allData = pref.getString('tasks');
    if (allData == null) return;

    List<TaskModel> allDataList = (jsonDecode(allData) as List)
        .map((element) => TaskModel.fromJson(element))
        .toList();

    // نلاقي مكان التاسك القديمة بالليستة الكاملة عشان نستبدلها بالمعدّلة
    final newIndex = allDataList.indexWhere((e) => e.id == updatedTask.id);
    if (newIndex != -1) {
      allDataList[newIndex] = updatedTask;
      await pref.setString(
        'tasks',
        jsonEncode(allDataList.map((e) => e.toMap()).toList()),
      );
    }

    widget.onTaskUpdated?.call();
  }

  // بتحدد شو تعمل حسب الخيار اللي اختاره المستخدم من الـ PopupMenu
  void _handleAction(TaskItemActionsEnum action) {
    switch (action) {
      case TaskItemActionsEnum.edit:
        _editTask();
        break;
      case TaskItemActionsEnum.delete:
        _deleteTask();
        break;
      case TaskItemActionsEnum.markAsDone:
        // بنستخدم نفس onTap الموجودة أصلاً (زي ما بيصير بالـ Checkbox بالضبط)
        // عشان الحفظ يصير بنفس طريقة الشاشة الأب
        widget.onTap(!widget.task.isDone, widget.index);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Container(
      height: 56,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.isDone,
            onChanged: (value) => widget.onTap(value, widget.index),
            activeColor: const Color(0xFF15B86C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.taskName,
                  style: TextStyle(
                    color: task.isDone
                        ? const Color(0xFFA0A0A0)
                        : const Color(0xFFFFFCFC),
                    fontSize: 16,
                    decoration:
                        task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                    decorationColor: const Color(0xFFA0A0A0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (task.taskDescription.isNotEmpty)
                  Text(
                    task.taskDescription,
                    style: const TextStyle(
                      color: Color(0xFFC6C6C6),
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          // التلت نقاط: فيها Complete / Delete / Edit
          PopupMenuButton<TaskItemActionsEnum>(
            icon: const Icon(Icons.more_vert, color: Color(0xFFA0A0A0)),
            onSelected: _handleAction, // هون كان الخطأ عندك: switch بدون break وbدون دالة صحيحة
            itemBuilder: (context) => TaskItemActionsEnum.values.map((e) {
              return PopupMenuItem<TaskItemActionsEnum>(
                value: e,
                child: Text(e.name),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// شيت تعديل التاسك: اسم + وصف + أهمية بس (بدون تاريخ أو صورة لسا)
// =========================================================
class _EditTaskSheet extends StatefulWidget {
  final TaskModel task;
  const _EditTaskSheet({required this.task});

  @override
  State<_EditTaskSheet> createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<_EditTaskSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late bool _isHighPrio;

  @override
  void initState() {
    super.initState();
    // نعبي الفيلدز بالقيم الحالية للتاسك عشان يشوفها المستخدم قبل ما يعدل
    _titleController = TextEditingController(text: widget.task.taskName);
    _descriptionController = TextEditingController(text: widget.task.taskDescription);
    _isHighPrio = widget.task.isHighPrio;
  }

  @override
  void dispose() {
    // لازم نتخلص من الـ Controllers عشان ما يصير memory leak
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final taskName = _titleController.text.trim();

    // Validation: ما بنسمح نحفظ تاسك بدون اسم
    if (taskName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a task name")),
      );
      return;
    }

    // منسوي TaskModel جديدة بنفس الـ id (id ثابت)، بس بالقيم المعدّلة
    final updatedTask = TaskModel(
      id: widget.task.id,
      taskName: taskName,
      taskDescription: _descriptionController.text.trim(),
      isHighPrio: _isHighPrio,
      isDone: widget.task.isDone, // ما منلمس حالة الإنجاز من هون
    );

    // منرجع التاسك المعدلة لـ _editTask() اللي فوق عشان تحفظها
    Navigator.pop(context, updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // مشان الشيت يطلع فوق الكيبورد لما المستخدم يكتب
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF181818),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Edit Task",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: "Task name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: const InputDecoration(hintText: "Task description"),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("High Priority", style: TextStyle(color: Colors.white)),
              value: _isHighPrio,
              onChanged: (value) => setState(() => _isHighPrio = value),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}