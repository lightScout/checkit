import 'package:carousel_slider/carousel_slider.dart';
import 'package:ciao_app/model/category.dart';
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
  final categoriesBox = Hive.box('categories');

  ScrollController hideButtonController =
      ScrollController(keepScrollOffset: true);
  AnimationController _hideFabController;
  Animation _hideFabAnimation;
  List<Widget> carouselList = [];
  List listOfCategoriesKeys = [];
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
    buildCarouselList();
    _hideFabController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 190));
    _hideFabAnimation =
        CurvedAnimation(parent: _hideFabController, curve: Curves.easeIn);
    _hideFabController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    hideButtonController.removeListener(() {});
    _hideFabController.dispose();
  }

  void buildCarouselList() {
    carouselList.clear();

    listOfCategoriesKeys = categoriesBox.keys.toList();
    listOfCategoriesKeys.forEach((element) {
      Category a = categoriesBox.get(element) as Category;

      carouselList.add(carouselItem(a.categoryName, tasksBox));
    });
    carouselList.add(addCategoryButton());
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
          // color: Color(0xFF8ddffd),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF9bdeff), Color(0xFFEBF8FF)]),
          ),
          child: Column(
            children: <Widget>[
              //
              //Top bar section - Menu bar, title and more
              //
              Container(
                padding:
                    EdgeInsets.only(left: 22, right: 22, top: 48, bottom: 0),
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
                        //
                        // Task counter
                        //
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
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
                  ],
                ),
              ),
              //
              //Bottom bar section - Task List builder
              //
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ValueListenableBuilder(
                          valueListenable: Hive.box('categories').listenable(),
                          builder: (context, box, widget) {
                            buildCarouselList();
                            return ValueListenableBuilder(
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
                                    items: carouselList,
                                  );
                                });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: carouselList.map((item) {
                          int index = carouselList.indexOf(item);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                  : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
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
Widget carouselItem(String category, Box tasksBox) {
  return Column(
    children: [
      //
      //Task list
      //
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            margin: const EdgeInsets.only(
                bottom: 20.0, left: 10.0, top: 10.0, right: 10.0),
            decoration: BoxDecoration(
              // border: Border.all(
              //   color: Colors.blue.withOpacity(.1.8),
              // ),
              gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFF9bdeff), Color(0xFFEBF8FF)]),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent,
                  offset: Offset(0.0, 5.0), //(x,y)
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //
                //Category Title
                //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          // gradient: LinearGradient(
                          //     begin: Alignment.center,
                          //     end: Alignment.topRight,
                          //     colors: [Colors.white12, Color(0xFFEBF8FF)]),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            category,
                            style: Constant.Klogo.copyWith(
                              fontSize: 15,
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
                ),
                Expanded(
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
      ),
    ],
  );
}

Widget addCategoryButton() {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    FloatingActionButton(
        elevation: 5,
        splashColor: Color(0xFFFF1d1d),
        backgroundColor: Color(0xFF071F86).withOpacity(.9),
        child: Icon(Icons.add),
        onPressed: () {
          print('test');
        }),
    Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Text(
        'Add Category',
        style: Constant.Klogo.copyWith(fontSize: 14),
      ),
    ),
  ]);
}
