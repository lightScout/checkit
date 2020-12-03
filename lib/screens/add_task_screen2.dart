import 'package:carousel_slider/carousel_slider.dart';
import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/model/task.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddTaskScreen2 extends StatefulWidget {
  static DateFormat dateFormat = DateFormat('DD-MM-yyyy');

  @override
  _AddTaskScreen2State createState() => _AddTaskScreen2State();
}

class _AddTaskScreen2State extends State<AddTaskScreen2> {
  final String fontFamily = 'PressStart2p';

  String newTaskTile;

  String newTaskCategory;

  String formattedDate = AddTaskScreen2.dateFormat.format(DateTime.now());

  var selectedCategory = "General";

  int sliderIndex = 0;

  List<Widget> sliderUserCategoriesList = <Widget>[];

  void addTask(Task task) {
    final tasksBox = Hive.box('tasks');
    tasksBox.add(task);
  }

  void _showNewCategoryDialog(Box box) {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          backgroundColor: Color(0xFF0E8DB4),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                    "New Category",
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      color: Colors.white,
                      //TODO: work on UI - title shadows
                      // shadows: [
                      //   Shadow(
                      //     blurRadius: 2.0,
                      //     color: Colors.blue,
                      //     offset: Offset(5.0, 5.0),
                      //   ),
                      //   Shadow(
                      //     color: Colors.white,
                      //     blurRadius: 6.0,
                      //     offset: Offset(2.0, 2.0),
                      //   ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 300,
                  child: TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                      filled: true,
                      fillColor: Color(0xFFf6e3d1),
                    ),
                    autofocus: true,
                    onChanged: (value) {
                      newTaskCategory = value;
                      print(newTaskCategory);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Icon(
                      Icons.control_point,
                      size: 40,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Category newCategory = Category(name: newTaskCategory);
                      box.add(newCategory);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _showNoTaskNameDialog() {
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

  Widget carouselCategoryBuilder(Box box) {
    sliderUserCategoriesList.clear();
    List listOfKey = box.keys.toList();

    listOfKey.forEach((element) {
      Category category = box.get(element) as Category;
      category.key = element;
      // print(category.name);
      Widget a = GestureDetector(
        onLongPress: () {
          box.delete(category.key);
          setState(() {
            newTaskCategory = 'General';
            selectedCategory = 'General';
            sliderIndex = 0;
          });
        },
        child: sliderCategoryItem(category.name),
      );
      sliderUserCategoriesList.add(a);
    });

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
        ),
      ),
      height: 135,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  "Task Category",
                  style: TextStyle(
                      fontFamily: 'PressStart2P',
                      color: Colors.white,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          //
          //CarouselSlider containg the list of categories available
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //
                  //Category slider
                  //
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                            bottomLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0)),
                      ),
                      height: 60,
                      width: 250,
                      child: CarouselSlider(
                        options: CarouselOptions(
                            initialPage: sliderIndex,
                            viewportFraction: .44,
                            aspectRatio: 3.8,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              Category category = box.getAt(index) as Category;
                              setState(() {
                                selectedCategory = category.name;
                                sliderIndex = index;
                              });
                              print(selectedCategory);
                            }),
                        items: sliderUserCategoriesList,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: GestureDetector(
                      onTap: () {
                        _showNewCategoryDialog(box);
                      },
                      child: Icon(
                        Icons.control_point_duplicate,
                        size: 34,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          //
          //
          //
          // Padding(
          //   padding: const EdgeInsets.only(top: 0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       //
          //       //Add new category flat button
          //       //
          //
          //       //
          //       //Select/Dismiss page flat button
          //       //
          //       FlatButton(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(15),
          //           ),
          //         ),
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //         child: Icon(
          //           Icons.done,
          //           size: 30,
          //           color: Color(0xFFF4a780),
          //         ),
          //         color: Color(0xFFf6e3d1),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  void _showTaskCategoryBottomSheet(Box box) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: carouselCategoryBuilder(box),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('categories').listenable(),
        builder: (context, box, widget) {
          print(box.keys);
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFF2A9D8F),
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
                            fontFamily: 'PressStart2P',
                            color: Colors.white,
                            fontSize: 12),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        maxLines: null,
                        decoration: InputDecoration(
//                          prefixIcon: Icon(
//                            LineIcons.font,
//                            color: Colors.black,
//                          ),
//                           helperText: 'Task Name',

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
                      // SizedBox(
                      //   height: 1,
                      // ),
                      // Text(
                      //   'Task Category',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontFamily: 'PoiretOne',
                      //     fontWeight: FontWeight.w700,
                      //     color: Color(0xFFf6e3d1),
                      //   ),
                      // ),

                      //
                      //FlatButton used to navigate to the task gategory page bottomsheet
                      //
                      Container(
                        child: carouselCategoryBuilder(box),
                      ),
                      // FlatButton(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.all(
                      //       Radius.circular(15),
                      //     ),
                      //   ),
                      //   onPressed: () {
                      //     FocusScope.of(context).unfocus();
                      //     _showTaskCategoryBottomSheet(box);
                      //   },
                      //   child: Text(selectedCategory),
                      //   color: Color(0xFFf6e3d1),
                      // ),
                      //
                      //Flatbutton used to triger the addition of the new task into the database
                      //
                      Row(
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
                                _showNoTaskNameDialog();
                              } else {
                                //unfocusing the keyboard to avoid UI break
                                FocusScope.of(context).unfocus();
                                //Add task to the list

                                Task task = Task();
                                task.name = newTaskTile;
                                task.category = selectedCategory;
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
//
//
//
                        ],
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
        });
  }
}

Widget sliderCategoryItem(String categoryTitle) {
  String title = categoryTitle;
  return Container(
    height: 25,
    width: 150,
    decoration: BoxDecoration(
      color: Color(0xFF264653),
      borderRadius: BorderRadius.all(
        Radius.circular(25.0),
      ),
    ),
    child: Center(
        child: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: 'PressStart2P', fontSize: 11, color: Colors.white),
    )),
  );
}
