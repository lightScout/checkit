import 'package:ciao_app/screens/add_category_screen.dart';
import 'package:ciao_app/screens/add_task_screen.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'HomeScreen';
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(children: [
          AddTaskScreen(),
          AddCategoryScreen(),
          Dashboard(),
        ]),
      ),
    );
  }
}
