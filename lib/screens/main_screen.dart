
import 'package:flutter/material.dart';
import 'package:todo_app/screens/complete_task_screen.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/profile_screen.dart';
import 'package:todo_app/screens/task_screen.dart';

class MainScreen extends StatefulWidget {
MainScreen({super.key});

  @override
State<MainScreen> createState ()=>_MainScreenState();
}

class _MainScreenState extends State<MainScreen>  {
  final List<Widget> _screen = [
    HomeScreen(),
    TasksScreen(),
    CompleteTaskScreen(),
    ProfileScreen(),
  ];
  int _cuentscreen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
       onTap: (int? index){
setState(() {
  _cuentscreen = index ?? 0;
});

       },
  backgroundColor: const Color(0xFF181818),
  type: BottomNavigationBarType.fixed,
  selectedItemColor: const Color(0xFF15B86C),
  unselectedItemColor: const Color(0xFFC6C6C6),

  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: "Home",
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.check_box_outline_blank),
      activeIcon: Icon(Icons.check_box),
      label: "To Do",
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.task_alt_outlined),
      activeIcon: Icon(Icons.task_alt),
      label: "Completed",
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: "Profile",
    ),
  ],
),
    body:_screen [_cuentscreen],
    );
  }
}