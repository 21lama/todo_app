import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart' show TaskModel;
import 'package:todo_app/screens/high_priority_screen.dart' show HighPriorityScreen;

class HighPriorityTasksWidget extends StatelessWidget {
const HighPriorityTasksWidget({super.key ,  required this.onTap, required this.tasks , required this.refresh});

final List<TaskModel> tasks;
final Function(bool?, int?) onTap;
final Function refresh; // مشان اعمل ريفريش للشاشة لما ارجع من هاي بريوريتي سكرين

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF282828),
        borderRadius: BorderRadius.circular(20),

      ),
     child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, //المسافة بين العناصر بنفس الصف للاخر
       crossAxisAlignment: CrossAxisAlignment.end, // العنصر التاني الي بالصف خليه لتحت
       children: [
         Expanded(
           child: Column(
            children: [
              Text("High priority Task",
              style: TextStyle(
                color: Color(0xFF15B86D),
                fontSize: 24,
              ),
              ),
              SizedBox(height:8),
              ...tasks.where((e)=>e.isHighPrio).take(4).map((element){
                return Row(
                  children: [
                   Checkbox(
                        value: element.isDone,
                        onChanged: (bool? value) {
                         final index= tasks.indexWhere((e){
                           return e.id == element.id;
                         });
                  
                          onTap(value, index);
                        },
                        activeColor: Color(0xFF15B86C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(4),
                        ),
                      ),
                  Expanded(
                    child: Text(
                                element.taskName,
                                style: TextStyle(
                                  //ادا محطوط عليها صح غير لونها واشطبها
                                  color: element.isDone
                                      ? Color(0xFFA0A0A0)
                                      : Color(0xFFFFFCFC),
                                  fontSize: 16,
                                  decoration: element.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationColor: Color(0xFFA0A0A0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                  ),
                  ],
                );
              })
            ],
           ),
         ),

        // اضافة سهم قابل للكبس، لما اكبسه بروح ع صفحة هاي بريوريتي كاملة
        // وحطيت الدائرة والايقونة جوا الـ child تبع الـ GestureDetector
        // مشان تصير كل المساحة يلي جوا الدائرة قابلة للكبس، مش بس منطقة فاضية
        GestureDetector(
          onTap: () async{
            await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
               return HighPriorityScreen();
            },
            ),
            );
           refresh(); //مشان لما ارجع ع الهوم تتحدث القائمة فورا
          },
          child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 56,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF6E6E6E),
            ),
         
            child: const Icon(
    Icons.arrow_outward,
    color: Colors.white,
    size: 22,
  ),
          ),
        ),
        ),
       ],
     ),
    );
  }
}