import 'package:ciao_app/screens/add_category_screen.dart';
import 'package:ciao_app/screens/add_task_screen.dart';
import 'package:flutter/material.dart';
import 'task_list_screen.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'HomeScreen';
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(children: [
        AddTaskScreen(),
        AddCategoryScreen(),
        TaskListScreen(),
      ]),
    );
  }
}
