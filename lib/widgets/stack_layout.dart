import 'package:ciao_app/screens/add_task_screen2.dart';
import 'package:ciao_app/screens/menu_screen.dart';
import 'package:ciao_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'curve_painter_menu.dart';
import 'package:ciao_app/screens/dashboard.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:ciao_app/screens/add_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:ciao_app/model/task_data.dart';
import 'package:ciao_app/icons/add_task_icon_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ciao_app/others/constants.dart' as Constant;

import 'list_builder.dart';

final Color bgColor = Color(0xFF4A5A58);

class StackLayout extends StatefulWidget {
  static const id = 'stackLayout';
  @override
  _StackLayoutState createState() => _StackLayoutState();
}

class _StackLayoutState extends State<StackLayout>
    with SingleTickerProviderStateMixin {
  final tasksBox = Hive.box('tasks');
  // user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Delete all tasks?"),
          content: Text("This will delete all tasks from this device."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Accept"),
              onPressed: () {
                var keysList = Hive.box('tasks').keys;
                Hive.box('tasks').deleteAll(keysList);
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              child: Text('Cancel'),
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FabCircularMenu(
          ringDiameter: MediaQuery.of(context).size.width * 0.65,
          ringWidth: (MediaQuery.of(context).size.width * 0.7) * 0.22,
          animationDuration: Duration(milliseconds: 300),
          fabCloseColor: Color(0xFF071F86),
          fabElevation: 10,
          fabMargin: EdgeInsets.only(right: 40, bottom: 40),
          fabOpenColor: Color(0xFFFF1d1d),
          ringColor: Color(0xFFFA9700),
          fabCloseIcon: Icon(
            Icons.close,
            size: 33,
            color: Colors.white,
          ),
          fabOpenIcon: Icon(
            Icons.add,
            size: 35,
            color: Colors.white,
          ),
          children: <Widget>[
            InkWell(
                child: Icon(
                  Icons.minimize,
                  size: 55,
                  color: Color(0xFFf8f0bc),
                ),
                onTap: () {
                  _showDialog();
                }),
            GestureDetector(
                child: Icon(
                  Icons.add,
                  color: Color(0xFFf8f0bc),
                  size: 55,
                ),
                onTap: () {
                  // Navigator.pushNamed(context, AddTaskScreen.id);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: AddTaskScreen2(),
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                  );
                })
          ]),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF8DE9D5), Color(0xFF0F8099)]),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(left: 22, right: 22, top: 48, bottom: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    child: Icon(
//                            isCollapsed ? Icons.menu : LineIcons.hand_o_right,
                      Icons.menu,
                      color: Color(0xFFFFFFFF),
                      size: 33,
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                            child: Container(
                          child: SettingsScreen(),
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                        )),
                        backgroundColor: Colors.transparent,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 55.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${tasksBox.length}',
                          style: Constant.Klogo.copyWith(
                            fontSize: 44,
                            shadows: [
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.blue,
                                offset: Offset(5.0, 5.0),
                              ),
                              Shadow(
                                color: Colors.white,
                                blurRadius: 6.0,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'checKit',
                          style: Constant.Klogo.copyWith(
                            fontSize: 20,
                            shadows: [
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.blue,
                                offset: Offset(5.0, 5.0),
                              ),
                              Shadow(
                                color: Colors.white,
                                blurRadius: 6.0,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // DashboardScreen(),
                ],
              ),
            ),
            Hive.box('tasks').isNotEmpty
                ? Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ListBuilder(listCategory: 'Main'),
                    ),
                  )

                /**
             * NO task section
             * **/
                : SizedBox(
                    width: 1,
                  ),
          ],
        ),
      ),
    );
  }
}

//FabCircularMenu(
//ringDiameter: MediaQuery.of(context).size.width * 0.55,
//ringWidth: (MediaQuery.of(context).size.width * 0.7) * 0.20,
//animationDuration: Duration(milliseconds: 400),
//fabCloseColor: Colors.white,
//fabOpenColor: Colors.white,
//ringColor: Colors.black54,
//fabOpenIcon: Icon(Icons.filter_list),
//children: <Widget>[
//InkWell(
//child: Icon(
//Icons.delete_forever,
//size: 35,
//color: Colors.white,
//),
//onTap: () {
//Provider.of<TaskData>(context, listen: false)
//    .deleteAllTasks();
//}),
//InkWell(
//child: Icon(
//LineIcons.pencil,
//color: Colors.white,
//size: 45,
//),
//onTap: () {
//showModalBottomSheet(
//context: context,
//isScrollControlled: true,
//builder: (context) => SingleChildScrollView(
//child: Container(
//child: AddTaskScreen(),
//padding: EdgeInsets.only(
//bottom:
//MediaQuery.of(context).viewInsets.bottom),
//)),
//backgroundColor: Colors.transparent,
//);
//})
//]),
