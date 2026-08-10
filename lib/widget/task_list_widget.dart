//لاحظنا انه بكل سكرين عنا تشابه بالليست ف مشان ما أكررهم بكل سكرين بخليهم مشتركين ببكب
import 'package:flutter/material.dart';
import 'package:todo_app/core/enum/task_iem_action_enum.dart' show TaskIemActionsEnum;
import 'package:todo_app/models/task_model.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({super.key, required this.tasks, required this.onTap});

  final List<TaskModel> tasks;
  //ادا صار اي تعديل ع اللتاسك انه خلصت او لا ببترجع اتنادي اي حد بستخدم askLisWidgget
  final Function(bool?, int?) onTap;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty ? Center(child: Text ("No Data",
    style: TextStyle(color: Colors.white,fontSize:24),
    ) )
    
    :ListView.builder(
      shrinkWrap: true, 

physics: NeverScrollableScrollPhysics(),


       
      padding: EdgeInsets.only(bottom: 60), // مسافة بين الزر واخر عنصر بالتاسك
      itemCount: tasks.length, //بحكي ل الليست كم عنصر جواتها
      itemBuilder: (BuildContext context, int index) {
        return Padding( //مشان يكون في مسافة بين كل تاسك
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
                  value: tasks[index].isDone,
                  onChanged: (bool? value) {
                    onTap(value, index);
                  },
                  activeColor: Color(0xFF15B86C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(4),
                  ),
                ),
                SizedBox(width: 16),
                Expanded( //مشان التاسك ووصفها يضل ضمن الحدود وما يأثر ع باقي الويدجت الي معه بنفس الصف
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start, //الكتابة اتبلش من البداية
                    children: [
                      //لعرض التاسك ووصفها
                      Text(
                        tasks[index].taskName,
                        style: TextStyle(
                          //ادا محطوط عليها صح غير لونها واشطبها
                          color: tasks[index].isDone
                              ? Color(0xFFA0A0A0)
                              : Color(0xFFFFFCFC),
                          fontSize: 16,
                          decoration: tasks[index].isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: Color(0xFFA0A0A0),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      //مشان ادا ما في وصف ييجي اسم التاسك بالنص
                      if (tasks[index].taskDescription.isNotEmpty)
                        Text(
                          tasks[index].taskDescription,
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
                
                PopupMenuButton<TaskIemActionsEnum>(
  icon: Icon(
    Icons.more_vert,
    color: Color(0xFFA0A0A0),
  ),
  onSelected: (value) {
      switch (value){
     case TaskIemActionsEnum.delete:
      
     case TaskIemActionsEnum.edit: }
      
    
  },
  itemBuilder: (context) => TaskIemActionsEnum.values.map((e) {
    return PopupMenuItem<TaskIemActionsEnum>(
      value: e,
      child: Text(e.name),
    );
  }).toList(),
),
              
                
              ],
            ),
          ),
        );
      },
    );
  }
}