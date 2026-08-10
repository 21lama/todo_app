
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/screens/add_task.dart';
import 'package:todo_app/widget/high_priority_tasks_widget.dart' show HighPriorityTasksWidget;
import 'package:todo_app/widget/task_list_widget.dart' show TaskListWidget;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key });
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  bool isCheck = false; //default value for checkBox
    List<TaskModel> tasks = [];
    int totalTask=0;
    int totalDoneTask=0;
    double percent=0;
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
     
     
     
    
setState(() {
      tasks = taskAfterDecode.map((element) => TaskModel.fromJson(element)).toList();
       totalTask= tasks.length;
    totalDoneTask= tasks.where((e) => e.isDone).length;
     percent = totalTask == 0 ? 0 :totalDoneTask / totalTask; 

});


setState(() {
  tasks = tasks;
});
  }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818), //لون خلفية الشاشة
     body: SafeArea(
     child: SingleChildScrollView(
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
                     style: Theme.of(context).textTheme.titleMedium,
                 ),
                Text("One task at a time, one step closer.",
                style:Theme.of(context).textTheme.titleSmall,
                ),
              ],
              ),
                
              ],
            ),
          SizedBox(height: 16,),
          Text(
            'yuhhu, Your work Is \nalmost done !',
              style:Theme.of(context).textTheme.titleLarge,
          
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Text('Achived Task',
                  style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 4,),
                  Text('$totalDoneTask Out of $totalTask',
                  style: Theme.of(context).textTheme.titleSmall,
                  ),
                  ],
                ),
              Stack(
               alignment: Alignment.center,
               children: [
                CircularProgressIndicator(value:percent),
                Text("${((percent * 100).toInt())}%" ,
                style: Theme.of(context).textTheme.titleMedium,
              ),
               ], 
              )
              
              ],),
            ),
         
          ),
             SizedBox(height: 8,),
             HighPriorityTasksWidget( 
            tasks: tasks,
             onTap: (bool? value, int? index) async { 
                  setState(() {
                tasks[index!].isDone = value ?? false; // store on ram temprature
                                        
                 });
               // update task on sharedPrefrence
               final pref = await SharedPreferences.getInstance();
              final updateTask = tasks.map((element) => element.toMap() ).toList();
             pref.setString('tasks',jsonEncode(updateTask) );
              },
              refresh: (){
                _loadTask();
              },
              
              ),//اعملت فلترة للتاكسات المهمة اكتر
          Padding(
            padding: const EdgeInsets.only(top:24 , bottom: 32.0),
            child: Text(
              'MY Tasks',
              style: Theme.of(context).textTheme.labelSmall,
              
            ),
          ),
            //مشان توخد مساحة وييجوا تحت بعض ويظهروا كلهم
              TaskListWidget(tasks: tasks,
              onTap: (bool? value , int? index) async{
                setState(() {
                tasks[index!].isDone = value ?? false; // store on ram temprature
                                        
                 });
               // update task on sharedPrefrence
               final pref = await SharedPreferences.getInstance();
              final updateTask = tasks.map((element) => element.toMap() ).toList();
             pref.setString('tasks',jsonEncode(updateTask) );
              } ,
              ), // لعدم تكرار كود الليست
            
           
            
            
       
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
     ),
    );
  }
}