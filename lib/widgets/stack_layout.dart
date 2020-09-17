import 'package:ciao_app/screens/menu_screen.dart';
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

final Color bgColor = Color(0xFF4A5A58);

class StackLayout extends StatefulWidget {
  static const id = 'stackLayout';
  @override
  _StackLayoutState createState() => _StackLayoutState();
}

class _StackLayoutState extends State<StackLayout>
    with SingleTickerProviderStateMixin {
  final Duration duration = Duration(milliseconds: 150);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  double screenWidth, screenHeight;

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
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.6).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset(0, 0),
    ).animate(_controller);
    Provider.of<TaskData>(context, listen: false).generateTaskList();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Color(0xFFFFFFF),
      child: CustomPaint(
        painter: CurvePainterMenu(),
        child: Container(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FabCircularMenu(
                ringDiameter: MediaQuery.of(context).size.width * 0.65,
                ringWidth: (MediaQuery.of(context).size.width * 0.7) * 0.22,
                animationDuration: Duration(milliseconds: 300),
                fabCloseColor: Colors.white,
                fabElevation: 10,
                fabMargin: EdgeInsets.only(right: 40, bottom: 40),
                fabOpenColor: Color(0xFF071F86),
                ringColor: Color(0xFFFA9700),
                fabCloseIcon: Icon(Icons.close, size: 30, color: Colors.white),
                fabOpenIcon: Icon(
                  Icons.add,
                  size: 35,
                  color: Color(0xFF071F86),
                ),
                children: <Widget>[
                  InkWell(
                      child: Icon(
                        Icons.minimize,
                        size: 44,
                        color: Colors.white,
                      ),
                      onTap: () {
                        _showDialog();
                      }),
                  InkWell(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 44,
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => SingleChildScrollView(
                              child: Container(
                            child: AddTaskScreen(),
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                          )),
                          backgroundColor: Colors.transparent,
                        );
                      })
                ]),
            body: Stack(
              children: <Widget>[
                MenuScreen(
                  slideAnimation: _slideAnimation,
                ),
                DashboardScreen(
                  width: size.width,
                  height: size.height,
                  duration: duration,
                  controller: _controller,
                  scaleAnimation: _scaleAnimation,
                ),
              ],
            ),
          ),
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
