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

  void addTask(Task task) {
    final tasksBox = Hive.box('tasks');
    tasksBox.add(task);
  }

  @override
  Widget build(BuildContext context) {
//    Size size = MediaQuery.of(context).size;
    var random = new Random();
    return Container(
        child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black, Colors.black]),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
        ),
      ),
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
                Text(
                  'Add Task',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PoiretOne',
                    fontSize: 22.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
                          helperText: 'Task Name',
                          hintText: 'Buy Mangos',
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
                    //Task Date selection switch
                    /*'WHen' and 'Category' selectors - PRO*/
//                    Text(
//                      'When?',
//                      style: TextStyle(
//                        fontFamily: 'PoiretOne',
//                        fontWeight: FontWeight.w700,
//                        color: Colors.white,
//                      ),
//                    ),
//                    SizedBox(
//                      height: 3,
//                    ),
//
//                    ToggleSwitch(
//                      minWidth: 80.0,
//                      initialLabelIndex: 0,
//                      activeBgColor: Color(0xFFA3320B),
//                      activeTextColor: Colors.white,
//                      inactiveBgColor: Colors.grey[900],
//                      inactiveTextColor: Colors.white,
//                      labels: ['Today', 'Tomorrow', 'Date'],
//                      onToggle: (index) {
//                        setState(() {
//                          if (index == 0) {
//                            taskDueDate = DateTime.now();
//                          } else if (index == 1) {
//                            taskDueDate = taskDueDate.add(Duration(days: 1));
//                          } else if (index == 2) {
//                            DatePicker.showDatePicker(context,
//                                showTitleActions: true,
////                              minTime: DateTime(2018, 3, 5),
////                              maxTime: DateTime(2019, 6, 7),
//                                theme: DatePickerTheme(
//                                  headerColor: Color(0xFFA3320B),
//                                  backgroundColor: Colors.black,
//                                  itemStyle: TextStyle(
//                                      color: Colors.white,
//                                      fontWeight: FontWeight.bold,
//                                      fontSize: 18),
//                                  doneStyle: TextStyle(
//                                    color: Colors.white,
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 18,
//                                    fontFamily: 'PoiretOne',
//                                  ),
//                                  cancelStyle: TextStyle(
//                                    color: Colors.grey[400],
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 18,
//                                    fontFamily: 'PoiretOne',
//                                  ),
//                                ), onChanged: (date) {
//                              print('change $date in time zone ' +
//                                  date.timeZoneOffset.inHours.toString());
//                            }, onConfirm: (date) {
//                              taskDueDate = date;
//                              print('confirm $date');
//                            },
//                                currentTime: DateTime.now(),
//                                locale: LocaleType.en);
//                          }
//                        });
//                        print('switched to: $index');
//                      },
//                    ),
//                    SizedBox(
//                      height: 30,
//                    ),
//                    //Task Category selection switch
//                    Text(
//                      'Category',
//                      style: TextStyle(
//                        fontFamily: 'PoiretOne',
//                        fontWeight: FontWeight.w700,
//                        color: Colors.white,
//                      ),
//                    ),
//                    SizedBox(
//                      height: 3,
//                    ),
//                    ToggleSwitch(
//                      minWidth: 80.0,
//                      initialLabelIndex: 0,
//                      activeBgColor: Color(0xFFA3320B),
//                      activeTextColor: Colors.white,
//                      inactiveBgColor: Colors.grey[900],
//                      inactiveTextColor: Colors.white,
//                      labels: ['Main', 'Dream'],
//                      onToggle: (index) {
//                        setState(() {
//                          if (index == 0) {
//                            newTaskCategory = 'Main';
//                          } else if (index == 1) {
//                            newTaskCategory = 'Dream';
//                          }
//                        });
//
////                        print('switched to: $index $newTaskCategory');
//                      },
//                    ),

//                    Row(
//                      mainAxisSize: MainAxisSize.min,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        //Dream task button
//                        InkWell(
//                          onTap: () {
//                            setState(() {
//                              isDreamTask = !isDreamTask;
//                              if (isMustDo) {
//                                isMustDo = false;
//                              }
//                              if (isDreamTask) {
//                                newTaskCategory = 'Dream';
//                              } else if (!isDreamTask) {
//                                newTaskCategory = 'Main';
//                              }
//                              print(newTaskCategory);
//                              // print('$isDreamTask $newTaskCategory');
//                            });
//                          },
//                          child: Icon(
//                            Icons.stars,
//                            color:
//                                isDreamTask ? Color(0xFFfff95b) : Colors.grey,
//                            size: 45,
//                          ),
//                        ),
//                        SizedBox(
//                          width: 100,
//                        ),
//                        //Must Do button
//                        InkWell(
//                          onTap: () {
//                            setState(() {
//                              isMustDo = !isMustDo;
//                              if (isDreamTask) {
//                                isDreamTask = false;
//                              }
//                              if (isMustDo) {
//                                newTaskCategory = 'MustDo';
//                              } else if (!isMustDo) {
//                                newTaskCategory = 'Main';
//                              }
//                              print(newTaskCategory);
//                              // print('$isDreamTask $newTaskCategory');
//                            });
//                          },
//                          child: Icon(
//                            Icons.brightness_7,
//                            color: isMustDo ? Colors.redAccent : Colors.grey,
//                            size: 45,
//                          ),
//                        ),
//                      ],
//                    ),
//                    SizedBox(
//                      height: 30.0,
//                    ),
                    //Add button
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            onPressed: () {
                              //Add task to the list
                              Task task = Task();
                              task.name = newTaskTile;
                              task.category = newTaskCategory;
                              task.dueDate = formattedDate;
                              task.isDone = false;
                              addTask(task);
                              // Provider.of<TaskData>(context, listen: false)
                              //     .addTaskToDB(
                              //         taskId: random.nextInt(1000000),
                              //         title: newTaskTile,
                              //         category: newTaskCategory,
                              //         dueDate: formattedDate,
                              //         isDone: 0);
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.redAccent,
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
    ));
  }
}
