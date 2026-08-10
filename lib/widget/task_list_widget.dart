//لاحظنا انه بكل سكرين عنا تشابه بالليست ف مشان ما أكررهم بكل سكرين بخليهم مشتركين ببكب

import 'package:flutter/material.dart';

import 'package:todo_app/core/enum/task_iem_action_enum.dart'
    show TaskItemActionsEnum;

import 'package:todo_app/core/widget/custom_text_form_feild.dart';

import 'package:todo_app/models/task_model.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    required this.onDelete,
    required this.onUpdate,
  });

  final List<TaskModel> tasks;

  //ادا صار اي تعديل ع اللتاسك انه خلصت او لا ببترجع اتنادي اي حد بستخدم TaskListWidget
  final Function(bool?, int?) onTap;

  //مشان احذف التاسك من الشاشة الرئيسية
  final Function(int) onDelete;

  //مشان لما اعدل ع التاسك ابعت التاسك الجديدة للشاشة الرئيسية
  final Function(TaskModel) onUpdate;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Text(
              "No Data",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,

            physics: NeverScrollableScrollPhysics(),

            padding: EdgeInsets.only(
              bottom: 60,
            ), // مسافة بين الزر واخر عنصر بالتاسك

            itemCount: tasks.length, //بحكي ل الليست كم عنصر جواتها

            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              final model = tasks[index];

              return Padding(
                //مشان يكون في مسافة بين كل تاسك
                padding: const EdgeInsets.only(top: 8.0),

                child: Container(
                  height: 56,

                  width: double.infinity, //as quaryData: بتوخد عرض الشاشة

                  alignment: Alignment.center, // الكتابة بالنص

                  decoration: BoxDecoration(
                    color: Color(0xFF282828),
                    borderRadius: BorderRadius.circular(28),
                  ),

                  child: Row(
                    children: [
                      Checkbox(
                        value: model.isDone,

                        onChanged: (bool? value) {
                          onTap(value, index);
                        },

                        activeColor: Color(0xFF15B86C),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadiusGeometry.circular(4),
                        ),
                      ),

                      SizedBox(width: 16),

                      Expanded(
                        //مشان التاسك ووصفها يضل ضمن الحدود وما يأثر ع باقي الويدجت الي معه بنفس الصف
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          //الكتابة اتبلش من البداية

                          children: [
                            //لعرض التاسك ووصفها
                            Text(
                              model.taskName,

                              style: TextStyle(
                                //ادا محطوط عليها صح غير لونها واشطبها
                                color: model.isDone
                                    ? Color(0xFFA0A0A0)
                                    : Color(0xFFFFFCFC),

                                fontSize: 16,

                                decoration: model.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,

                                decorationColor:
                                    Color(0xFFA0A0A0),

                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            //مشان ادا ما في وصف ييجي اسم التاسك بالنص
                            if (model.taskDescription.isNotEmpty)
                              Text(
                                model.taskDescription,

                                style: TextStyle(
                                  color: Color(0xFFC6C6C6),
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // اضافة التلت نقاط الي فوق بعض وجعلها قابلة للكبس
                      PopupMenuButton<TaskItemActionsEnum>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Color(0xFFA0A0A0),
                        ),

                        onSelected: (value) async {
                          switch (value) {
                            case TaskItemActionsEnum.markAsDone:

                              //مشان اغير حالة التاسك من منتهية لغير منتهية والعكس
                              onTap(!model.isDone, index);

                              break;

                            case TaskItemActionsEnum.delete:

                              //مشان قبل الحذف اسأل المستخدم اذا متأكد
                              final result =
                                  await _showDeleteDialog(context);

                              if (result == true) {
                                onDelete(model.id);
                              }

                              break;

                            case TaskItemActionsEnum.edit:

                              //مشان افتح واجهة التعديل
                              final updatedModel =
                                  await _showButtonSheet(
                                context,
                                model,
                              );

                              //اذا المستخدم عمل Update برجع التاسك الجديدة للشاشة الرئيسية
                              if (updatedModel != null) {
                                onUpdate(updatedModel);
                              }

                              break;
                          }
                        },

                        itemBuilder: (context) {
                          return TaskItemActionsEnum.values
                              .map((e) {
                            return PopupMenuItem<
                                TaskItemActionsEnum>(
                              value: e,
                              child: Text(e.name),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  //مشان اظهر رسالة تأكيد قبل ما احذف التاسك
  Future<bool?> _showDeleteDialog(
    BuildContext context,
  ) {
    return showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text("Delete Task"),

          content: Text("sure?"),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('cancle'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  //مشان افتح Bottom Sheet لتعديل التاسك
  Future<TaskModel?> _showButtonSheet(
    BuildContext context,
    TaskModel model,
  ) {
    // each controller for each textFormField انا بعمل اكسس عليه من خلال الكونترولار

    //مشان اجيب البيانات الموجودة بالتاسك واحطها داخل التكست فيلد
    final TextEditingController taskNameController =
        TextEditingController(
      text: model.taskName,
    );

    final TextEditingController taskDescriptionController =
        TextEditingController(
      text: model.taskDescription,
    );

    //مشان اتأكد من البيانات قبل ما اعمل Update
    final GlobalKey<FormState> key =
        GlobalKey<FormState>();

    //مشان السويتش يبدأ بنفس حالة الـ priority الموجودة بالتاسك
    bool isHighPrio = model.isHighPrio;

    return showModalBottomSheet<TaskModel>(
      context: context,

      isScrollControlled: true,

      backgroundColor: Color(0xFF181818),

      builder: (context) {
        //استخدمت StatefulBuilder هون مشان اقدر اغير حالة السويتش
        //بدون ما احول TaskListWidget من StatelessWidget لـ StatefulWidget
        return StatefulBuilder(
          builder: (
            context,
            setState,
          ) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,

                //مشان الكيبورد ما يغطي على التكست فيلد او الباتون
                bottom:
                    MediaQuery.of(context).viewInsets.bottom +
                        16,
              ),

              child: Form(
                key: key,

                child: SizedBox(
                  height:
                      MediaQuery.of(context).size.height *
                          0.75,

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      //بدل ما اكتب الكود بكل شاشة حطيته بملف منفصل وصرت اناديه عند الحاجة
                      CustomTextFormFeild(
                        controller:
                            taskNameController,

                        title: 'task name',

                        hintText:
                            'inish UI design to login screen',

                        validator: (String? value) {
                          if (value?.trim().isEmpty ??
                              false) {
                            // ادا ما دخل المستخدم اسم وكبس ع الباتون
                            return "please enter task name";
                          }

                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      //بدل ما اكتب الكود بكل شاشة حطيته بملف منصل وصرت اناديه عند الحاجة
                      CustomTextFormFeild(
                        controller:
                            taskDescriptionController,

                        title: 'task description',

                        maxLines: 5,

                        hintText:
                            'nish on bording UI and hand of to dev during sunday ',
                      ),

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        //مسافة بين السويتش والنص

                        children: [
                          Text(
                            "High priority",

                            style: TextStyle(
                              color:
                                  Color(0xFFFFFCFC),
                              fontSize: 16,
                            ),
                          ),

                          Switch(
                            value: isHighPrio,

                            onChanged: (
                              bool value,
                            ) {
                              setState(() {
                                isHighPrio = value;
                              });
                            },

                            activeTrackColor:
                                Color(0xFF15B86C),
                          ),
                        ],
                      ),

                      Spacer(),

                      ElevatedButton.icon(
                        // ادا محتوى الباتون يحتوي ع ايقونة ونص بستخدم .icon

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xFF15B86C), //خلفيته

                          foregroundColor:
                              Color(0xFFFFFCFC), // لون المحتوى متل بعض ف هيك اسهل الهم كلهم

                          fixedSize: Size(
                            MediaQuery.of(context)
                                .size
                                .width,
                            48,
                          ),
                        ),

                        icon: Icon(Icons.edit),

                        label: Text("Update"),

                        onPressed: () {
                          if (!(key.currentState
                                  ?.validate() ??
                              false)) {
                            return;
                          }

                          //عملت TaskModel جديدة بالقيم الجديدة
                          //وخليت الـ id وحالة isDone من التاسك القديمة
                          final updatedModel =
                              TaskModel(
                            id: model.id,

                            taskName:
                                taskNameController
                                    .text
                                    .trim(),

                            taskDescription:
                                taskDescriptionController
                                    .text
                                    .trim(),

                            isHighPrio:
                                isHighPrio,

                            isDone:
                                model.isDone,
                          );

                          //برجع التاسك الجديدة للشاشة الرئيسية مشان تنحفظ
                          Navigator.pop(
                            context,
                            updatedModel,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}