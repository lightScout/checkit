import 'package:ciao_app/screens/add_task_screen2.dart';
import 'package:flutter/material.dart';
import 'task_list_screen.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'HomeScreen';
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        AddTaskScreen2(),
        TaskListScreen(),
      ]),
    );
  }
}
