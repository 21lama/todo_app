
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/screens/add_task.dart';
import 'package:todo_app/widget/task_list_widget.dart' show TaskListWidget;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key });
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  bool isCheck = false; //default value for checkBox
    List<TaskModel> task = [];
  @override
  //رح تتنفذ بالبداية
  void initState() {
    super.initState();
    _loadUserName();
    _loadTask();
  }
  void _loadUserName() async{
      final pref = await SharedPreferences.getInstance();
  
  setState(() {
    username= pref.getString('username');
  });
 
  }

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
  task = tasks;
});
  }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818), //لون خلفية الشاشة
     body: SafeArea(
     child: Padding(
       padding: const EdgeInsets.all(16),

       child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/person.png'),
            ),
             SizedBox(width: 8), //المسافة بين الافاتار والنصوص الي جنبه 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, //مشان النصوص الي جواته يبلشوا من البداية من الشمال يعني
                children: [
                 Text("Good Evning $username",
                  style: TextStyle(
                    color: Color(0xFFFFFCFC),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
               ),
              Text("One task at a time, one step closer.",
              style: TextStyle(
                color: Color(0xFFC6C6C6),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              ),
            ],
            ),
              
            ],
          ),
        SizedBox(height: 16,),
        Text(
          'yuhhu, Your work Is \nalmost done !',
         style: TextStyle(
          color: Color(0xFFFFFCFC),
          fontSize: 32,
         ),
        
        ),
        
        Padding(
          padding: const EdgeInsets.only(top:24 , bottom: 32.0),
          child: Text(
            'MY Task',
            style: TextStyle(color:Color(0xFFFFFCFC),
            fontSize: 20
            ),
          ),
        ),
          Expanded( //مشان توخد مساحة وييجوا تحت بعض ويظهروا كلهم
            child: TaskListWidget(tasks: task,
            onTap: (bool? value , int? index) async{
              setState(() {
              task[index!].isDone = value ?? false; // store on ram temprature
                                      
               });
             // update task on sharedPrefrence
             final pref = await SharedPreferences.getInstance();
            final updateTask = task.map((element) => element.toMap() ).toList();
           pref.setString('tasks',jsonEncode(updateTask) );
            } ,
            ), // لعدم تكرار كود الليست
          
         
          ),
          

        // add new task button:
        //Spacer(), //بحط الي تحته في اسفل الصفحة
        Align( // مشان ييجي الباتون ع اليمين
        alignment: Alignment.bottomRight,
          child: ElevatedButton.icon(
            style:ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF15B86C) ,//خلفيته
                    foregroundColor: Color(0xFFFFFCFC),
                 fixedSize:Size(168,48) ,
                  ),
                  icon:Icon(Icons.add),
                  label: Text("add new task"),
            onPressed: () async{
              await Navigator.push(
                
                context,
                MaterialPageRoute(
                  builder: (BuildContext context){
                  return AddTask();
                },
                ),
                );
                _loadTask();
            } ,
            
            ),
            
            ),
        
        

        ],
       ),
     ),
     ),
    );
  }
}