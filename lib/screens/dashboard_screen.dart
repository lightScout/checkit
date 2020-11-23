import 'package:carousel_slider/carousel_slider.dart';
import 'package:ciao_app/others/constants.dart' as Constant;
import 'package:ciao_app/screens/add_task_screen2.dart';
import 'package:ciao_app/screens/settings_screen.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/list_builder.dart';

final Color bgColor = Color(0xFF4A5A58);

class StackLayout extends StatefulWidget {
  static const id = 'dashboardScreen';

  @override
  _StackLayoutState createState() => _StackLayoutState();
}

class _StackLayoutState extends State<StackLayout>
    with SingleTickerProviderStateMixin {
  int _current = 0;
  final tasksBox = Hive.box('tasks');
  ScrollController hideButtonController =
      ScrollController(keepScrollOffset: true);
  AnimationController _hideFabController;
  Animation _hideFabAnimation;
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
    _hideFabController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 190));
    _hideFabAnimation =
        CurvedAnimation(parent: _hideFabController, curve: Curves.easeIn);
    _hideFabController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    hideButtonController.removeListener(() {});
    _hideFabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (t) {
        if (t is ScrollStartNotification) {
          _hideFabController.reverse();
        } else if (t is ScrollEndNotification) {
          _hideFabController.forward();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: ScaleTransition(
          scale: _hideFabAnimation,
          alignment: Alignment.bottomRight,
          child: FabCircularMenu(
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
                      size: 44,
                      color: Color(0xFFf8f0bc),
                    ),
                    onTap: () {
                      _showDialog();
                    }),
                GestureDetector(
                    child: Icon(
                      Icons.add,
                      color: Color(0xFFf8f0bc),
                      size: 44,
                    ),
                    onTap: () {
                      // Navigator.pushNamed(context, AddTaskScreen.id);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: AddTaskScreen2(),
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                      );
                    })
              ]),
        ),
        body: Container(
          color: Color(0xFF8ddffd),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.topRight,
          //       end: Alignment.bottomLeft,
          //       colors: [Color(0xFF9bdeff), Color(0xFFEBF8FF)]),
          // ),
          child: Column(
            children: <Widget>[
              //
              //Top bar section - Menu bar, title and more
              //
              Container(
                padding:
                    EdgeInsets.only(left: 22, right: 22, top: 48, bottom: 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //
                    // Menu Button and Title
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.menu,
                            color: Color(0xFF071F86),
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
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                              )),
                              backgroundColor: Colors.transparent,
                            );
                          },
                        ),
                        //
                        //Title
                        //
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
                        ),
                      ],
                    ),

                    //
                    // Task counter
                    //
                    Padding(
                      padding: const EdgeInsets.only(top: 55.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          //
                          // Number of Tasks - Text Widget show the number of taks in de database
                          //
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //
              //Bottom bar section - Task List builder
              //
              Column(
                children: [
                  ValueListenableBuilder(
                      valueListenable: tasksBox.listenable(),
                      builder: (context, box, widget) {
                        return CarouselSlider(
                          options: CarouselOptions(
                              aspectRatio: 1.0,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              }),
                          items: [
                            createTaskList('General', box),
                            addCategoryButton(),
                          ],
                        );
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

///
///Windget utilize for creation of task lists by category
///
Widget createTaskList(String category, Box tasksBox) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xff70D7FD),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                category,
                style: Constant.Klogo.copyWith(
                  fontSize: 18,
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
            ),
          ),
        ],
      ),
      Expanded(
        flex: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff70D7FD),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child:
                      ListBuilder(listCategory: category, tasksBox: tasksBox),
                ),
              )
            ],
          ),
        ),
      ),
    ],
  );
}

Widget addCategoryButton() {
  return Container(
    height: 80,
    width: 80,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white24,
    ),
    child: GestureDetector(
        onTap: () {
          print('test');
        },
        child: Icon(
          Icons.add,
          color: Colors.grey,
          size: 40,
        )),
  );
}
