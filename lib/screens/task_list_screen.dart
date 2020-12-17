import 'package:carousel_slider/carousel_slider.dart';
import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/others/constants.dart' as Constant;
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/screens/settings_screen.dart';
import 'package:ciao_app/widgets/new_category_alert.dart';
import 'package:ciao_app/widgets/no_category_alert.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ciao_app/widgets/custom_cliprrect.dart' as CustomClipRRect;
import 'package:animate_icons/animate_icons.dart';

import '../widgets/list_builder.dart';

final Color bgColor = Color(0xFF4A5A58);

class TaskListScreen extends StatefulWidget {
  static const id = 'dashboardScreen';

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with SingleTickerProviderStateMixin {
  // int _current = 0;
  final tasksBox = Hive.box('tasks');
  final categoriesBox = Hive.box('categories');
  String newTaskCategory;

  ScrollController hideButtonController =
      ScrollController(keepScrollOffset: true);
  AnimationController _animationController;
  AnimateIconController _animateIconController;
  // Animation _animation;
  List<Widget> carouselList = [];
  List listOfCategoriesKeys = [];
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double topBorderRadius = 0;
  bool newTaskScreenToggle = false;

  // void _showDeleteAllTasksDialog() {
  //   // flutter defined function
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: Text("Delete all tasks?"),
  //         content: Text("This will delete all tasks from this device."),
  //         actions: <Widget>[
  //           // usually buttons at the bottom of the dialog
  //           FlatButton(
  //             child: Text("Accept"),
  //             onPressed: () {
  //               var keysList = Hive.box('tasks').keys;
  //               Hive.box('tasks').deleteAll(keysList);
  //               Navigator.of(context).pop();
  //             },
  //           ),

  //           FlatButton(
  //             child: Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

//TODO: create alert for delete category confirmation

  @override
  void initState() {
    super.initState();
    buildCarouselList();
    _animateIconController = AnimateIconController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 190),
    );
    // _animation =
    //     CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    // _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    hideButtonController.removeListener(() {});
    _animationController.dispose();
  }

  void deleteCategory(int categoryKey) {
    categoriesBox.delete(categoryKey);
    buildCarouselList();
  }

  void buildCarouselList() {
    carouselList.clear();

    listOfCategoriesKeys = categoriesBox.keys.toList();
    listOfCategoriesKeys.forEach((element) {
      Category a = categoriesBox.get(element) as Category;
      a.key = element;

      carouselList.add(carouselItem(
        a.categoryName,
        a.key,
        tasksBox,
        categoriesBox,
        () {
          deleteCategory(a.key);
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (t) {
        // if (t is ScrollStartNotification) {
        //   _hideFabController.reverse();
        // } else if (t is ScrollEndNotification) {
        //   _hideFabController.forward();
        // }
        return true;
      },
      child: AnimatedContainer(
        curve: Curves.ease,
        transform: Matrix4.translationValues(
          xOffset,
          yOffset,
          0,
        )..scale(scaleFactor),
        duration: Duration(milliseconds: 800),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          floatingActionButton: FabCircularMenu(
              ringDiameter: MediaQuery.of(context).size.width * 0.75,
              ringWidth: (MediaQuery.of(context).size.width * 0.7) * 0.22,
              animationDuration: Duration(milliseconds: 300),
              fabCloseColor: Color(0xFF071F86),
              fabElevation: 2,
              fabMargin: EdgeInsets.only(right: 40, bottom: 40),
              fabOpenColor: Color(0xFFFF1d1d),
              ringColor: Color(0xFFFA9700),
              fabCloseIcon: Icon(
                Icons.close,
                size: 33,
                color: Colors.white,
              ),
              fabOpenIcon: Icon(
                Icons.fingerprint,
                size: 41,
                color: Colors.white,
              ),
              children: <Widget>[
                InkWell(
                    child: Icon(
                      Icons.settings_sharp,
                      size: 35,
                      color: Color(0xFFf8f0bc),
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
                    }),
                InkWell(
                  child: Icon(
                    Icons.category_sharp,
                    color: Color(0xFFf8f0bc),
                    size: 35,
                  ),
                  onTap: () {
                    newCategoryAlert(context);
                  },
                ),
                GestureDetector(
                  child: Icon(
                    Icons.add,
                    color: Color(0xFFf8f0bc),
                    size: 44,
                  ),
                  onTap: () {
                    if (categoriesBox.isEmpty) {
                      noCategoriesAvailableDialog(context);
                    }
                    setState(() {
                      topBorderRadius = 50;
                      yOffset = MediaQuery.of(context).size.height / 1.2;

                      newTaskScreenToggle = true;
                    });

                    if (_animateIconController.isStart()) {
                      _animateIconController.animateToEnd();
                    }
                  },
                ),
              ]),
          body: Container(
            // color: Color(0xFF8ddffd),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(topBorderRadius),
                topRight: Radius.circular(topBorderRadius),
              ),
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [KTopBGColor, KBottomBGColor]),
            ),
            child: Column(
              children: <Widget>[
                //
                //Top bar section - Menu bar, title and more
                //
                Container(
                  padding:
                      EdgeInsets.only(left: 0, right: 0, top: 48, bottom: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //
                      // Menu Button and Title
                      //
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 22,
                          right: 22,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomClipRRect.customClipRRect(
                              child: AnimateIcons(
                                controller: _animateIconController,
                                startIcon: Icons.add,
                                startTooltip: 'Icons.add',
                                endTooltip: 'Icons.close',
                                endIcon: Icons.close,
                                color: Color(0xFF071F86),
                                size: 41,
                                onStartIconPress: () {
                                  if (categoriesBox.isEmpty) {
                                    noCategoriesAvailableDialog(context);
                                  }
                                  setState(() {
                                    topBorderRadius = 50;
                                    yOffset =
                                        MediaQuery.of(context).size.height /
                                            1.2;
                                    newTaskScreenToggle = true;
                                  });
                                  return true;
                                },
                                onEndIconPress: () {
                                  setState(() {
                                    topBorderRadius = 0;
                                    yOffset = 0;
                                    newTaskScreenToggle = false;
                                  });
                                  return true;
                                },
                              ),
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
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 10.0),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.end,
                            //     children: <Widget>[
                            //       //
                            //       // Number of Tasks - Text Widget show the number of taks in de database
                            //       //
                            //       Text(
                            //         '${tasksBox.length}',
                            //         style: Constant.Klogo.copyWith(
                            //           fontSize: 44,
                            //           shadows: [
                            //             Shadow(
                            //               blurRadius: 2.0,
                            //               color: Colors.blue,
                            //               offset: Offset(5.0, 5.0),
                            //             ),
                            //             Shadow(
                            //               color: Colors.white,
                            //               blurRadius: 6.0,
                            //               offset: Offset(2.0, 2.0),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
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
                            valueListenable:
                                Hive.box('categories').listenable(),
                            builder: (context, box, widget) {
                              buildCarouselList();
                              return ValueListenableBuilder(
                                  valueListenable: tasksBox.listenable(),
                                  builder: (context, box, widget) {
                                    return CarouselSlider(
                                      options: CarouselOptions(
                                          aspectRatio: .60,
                                          enlargeCenterPage: false,
                                          enableInfiniteScroll: false,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              // _current = index;
                                            });
                                          }),
                                      items: carouselList,
                                    );
                                  });
                            }),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: carouselList.map((item) {
                        //     int index = carouselList.indexOf(item);
                        //     return Container(
                        //       width: 8.0,
                        //       height: 8.0,
                        //       margin: EdgeInsets.symmetric(
                        //           vertical: 10.0, horizontal: 2.0),
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: _current == index
                        //             ? Color.fromRGBO(0, 0, 0, 0.9)
                        //             : Color.fromRGBO(0, 0, 0, 0.4),
                        //       ),
                        //     );
                        //   }).toList(),
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///
///Windget utilize for creation of task lists by category
///
Widget carouselItem(String category, int categoryKey, Box tasksBox,
    Box categoriesBox, Function function) {
  return Column(
    children: [
      Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white24,
              gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.topRight,
                  colors: [Colors.white12, Color(0xFFEBF8FF)]),
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
      //
      //Item
      //
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(
              bottom: 10.0, left: 0, top: 0.0, right: 00.0),
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
                color: Colors.blueAccent[400],
                offset: Offset(0.0, 5.0), //(x,y)
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //
              //Delete category buttom
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomClipRRect.customClipRRect(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: 45,
                          height: 45,
                          child: InkWell(
                            onTap: function,
                            child: Icon(
                              Icons.delete,
                              size: 28,
                              color: KMainPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child:
                      //TODO: work on delete tasks when category is deleted
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

Widget addCategoryButton(Function function) {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    FloatingActionButton(
        heroTag: 'addCategory',
        elevation: 5,
        splashColor: Color(0xFF9bdeff),
        backgroundColor: Color(0xFF071F86),
        child: Icon(
          Icons.category,
          size: 33,
          color: Colors.white,
        ),
        onPressed: function),
    Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Text(
        'Add Category',
        style: Klogo.copyWith(fontSize: 14),
      ),
    ),
  ]);
}
