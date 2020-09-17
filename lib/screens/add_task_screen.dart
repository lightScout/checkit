import 'package:ciao_app/model/task.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:ciao_app/model/task_data.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:math';
import 'package:hive/hive.dart';

class AddTaskScreen extends StatefulWidget {
  //String newTask;
  static const id = 'addTaskScreen';
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  bool isDreamTask = false;
  bool isMustDo = false;
  String newTaskTile;
  String newTaskCategory = 'Main';
  static DateFormat dateFormat = DateFormat('DD-MM-yyyy');
  String formattedDate = dateFormat.format(DateTime.now());
  final Duration duration = Duration(milliseconds: 150);
  final String fontFamily = 'PressStart2P';

  void addTask(Task task) {
    final tasksBox = Hive.box('tasks');
    tasksBox.add(task);
  }

  @override
  Widget build(BuildContext context) {
//    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 50, bottom: 18, left: 18, right: 18),
        child: Container(
            child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xFF1D8CA0), Color(0xFF0F8099)]),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
              bottomLeft: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: 10.0,
                    left: 30.0,
                    right: 30.0,
                    bottom: 30.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            Text(
                              'Add Task',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: 22.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 45),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Task Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'PoiretOne',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          TextField(
                            maxLines: null,
                            decoration: InputDecoration(
//                          prefixIcon: Icon(
//                            LineIcons.font,
//                            color: Colors.black,
//                          ),
//                           helperText: 'Task Name',
                                hintText: 'Buy Mangoes',
                                hintStyle: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700,
                                ),
                                filled: true,
                                fillColor: Colors.white),
//                  textAlign: TextAlign.center,
                            autofocus: true,
                            onChanged: (value) {
                              newTaskTile = value;
                              print(newTaskTile);
                            },
                          ),

                          //Add button
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    //Add task to the list
                                    Task task = Task();
                                    task.name = newTaskTile;
                                    task.category = newTaskCategory;
                                    task.dueDate = formattedDate;
                                    task.isDone = false;
                                    addTask(task);
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: 30,
                                    color: Color(0xFFFA9700),
                                  ),
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //Page Title

                      //Title input TextFiled
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
