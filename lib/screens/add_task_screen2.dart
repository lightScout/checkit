import 'package:ciao_app/model/task.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AddTaskScreen2 extends StatefulWidget {
  static DateFormat dateFormat = DateFormat('DD-MM-yyyy');

  @override
  _AddTaskScreen2State createState() => _AddTaskScreen2State();
}

class _AddTaskScreen2State extends State<AddTaskScreen2> {
  final String fontFamily = 'PressStart2p';

  String newTaskTile;

  String newTaskCategory = 'Main';

  String formattedDate = AddTaskScreen2.dateFormat.format(DateTime.now());

  void addTask(Task task) {
    final tasksBox = Hive.box('tasks');
    tasksBox.add(task);
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.black,
          content: Text(
            "Task without a name can not be added.",
            style: TextStyle(fontFamily: 'PressStart2P', color: Colors.white),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(fontFamily: 'PressStart2P'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFF1d1d),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
        ),
      ),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 44.0),
            child: Text(
              'Add Task',
              style: TextStyle(
                color: Color(0xFFf6e3d1),
                fontSize: 25,
                fontFamily: fontFamily,
                // shadows: [
                //   BoxShadow(
                //     color: Colors.white,
                //     offset: Offset(0.0, 0.0),
                //     blurRadius: 10.0,
                //     spreadRadius: 5.4,
                //   ),
                // ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Task Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'PoiretOne',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFf6e3d1),
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
                    fillColor: Color(0xFFf6e3d1),
                  ),
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
                          if (newTaskTile == null) {
                            _showDialog();
                          } else {
                            FocusScope.of(context).unfocus();
                            //Add task to the list
                            Task task = Task();
                            task.name = newTaskTile;
                            task.category = newTaskCategory;
                            task.dueDate = formattedDate;
                            task.isDone = false;
                            addTask(task);
                            Navigator.pop(context);
                          }
                        },
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Color(0xFFF4a780),
                        ),
                        color: Color(0xFFf6e3d1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
//          SizedBox(
//            height: 20,
//          ),
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: SingleChildScrollView(
//              child: ListView(
//                shrinkWrap: true,
//                children: <Widget>[
//                  ListTile(
//                    leading: LiteRollingSwitch(
//                      //initial value
//                      animationDuration: Duration(milliseconds: 200),
//                      value: true,
//                      textOn: 'ON',
//                      textOff: 'OFF',
//                      colorOn: Colors.greenAccent[700],
//                      colorOff: Colors.redAccent[700],
//                      iconOn: Icons.done,
//                      iconOff: Icons.remove_circle_outline,
//                      textSize: 16.0,
//                      onChanged: (bool state) {
//                        //Use it to manage the different states
//                        print('Current State of SWITCH IS: $state');
//                      },
//                    ),
//                    title: Text(
//                      'Dream Category',
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 19,
//                          fontWeight: FontWeight.w700,
//                          fontFamily: 'PoiretOne'),
//                    ),
//                  )
//                ],
//              ),
//            ),
//          )
        ],
      ),
    );
  }
}
