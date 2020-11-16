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

  var selectedCategory = "Daily";

  List<String> userCategoriesList = <String>['Daily', 'Work'];

  List<Widget> sliderUserCategoriesList = <Widget>[];

  void buildSliderList() {
    userCategoriesList.forEach((element) {
      sliderUserCategoriesList.add(sliderCategory(element));
    });
  }

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
          backgroundColor: Colors.black,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "New Category",
                style:
                    TextStyle(fontFamily: 'PressStart2P', color: Colors.white),
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 300,
                  child: TextField(
                    maxLines: null,
                    decoration: InputDecoration(
//                          prefixIcon: Icon(
//                            LineIcons.font,
//                            color: Colors.black,
//                          ),
//                           helperText: 'Task Name',
                      hintText: 'Home',
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
                      newTaskCategory = value;
                      print(newTaskCategory);
                    },
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: Color(0xFFF4a780),
                  ),
                  color: Color(0xFFf6e3d1),
                  onPressed: () {
                    Category newCategory = Category(name: newTaskCategory);
                    box.add(newCategory);
                    Navigator.of(context).pop();
                  },
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

  Widget categorySelector(Box box) {
    if (sliderUserCategoriesList.isNotEmpty) {
      sliderUserCategoriesList.clear();
    }

    box.keys.forEach((element) {
      Category category = box.getAt(element) as Category;
      print(category.name);
      sliderUserCategoriesList.add(sliderCategory(category.name));
    });

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFF1d1d),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
        ),
      ),
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 33.0),
            child: Text(
              "Task Category",
              style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Colors.white,
                  fontSize: 22),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          //
          //CarouselSlider containg the list of categories available
          //
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //
              //Category slider
              //
              Container(
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0)),
                ),
                height: 100,
                width: 250,
                child: CarouselSlider(
                  options: CarouselOptions(
                      viewportFraction: .48,
                      aspectRatio: 3.8,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        Category category = box.getAt(index) as Category;
                        setState(() {
                          selectedCategory = category.name;
                        });
                        print(selectedCategory);
                      }),
                  items: sliderUserCategoriesList,
                ),
              ),
            ],
          ),
          //
          //
          //
          Padding(
            padding: const EdgeInsets.only(top: 33.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //
                //Add new category flat button
                //
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    _showNewCategoryDialog(box);
                  },
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: Color(0xFFF4a780),
                  ),
                  color: Color(0xFFf6e3d1),
                ),
                //
                //Select/Dismiss page flat button
                //
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.done,
                    size: 30,
                    color: Color(0xFFF4a780),
                  ),
                  color: Color(0xFFf6e3d1),
                ),
              ],
            ),
          )
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
          child: categorySelector(box),
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
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Task Category',
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
                      //
                      //FlatButton used to navigate to the task gategory page bottomsheet
                      //
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _showTaskCategoryBottomSheet(box);
                        },
                        child: Text(selectedCategory),
                        color: Color(0xFFf6e3d1),
                      ),
                      //
                      //Flatbutton used to triger the addition of the new task into the database
                      //
                      Padding(
                        padding: const EdgeInsets.all(25.0),
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

sliderCategory(String categoryTitle) {
  String title = categoryTitle;
  return Container(
    height: 75,
    width: 75,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.all(
        Radius.circular(50.0),
      ),
    ),
    child: Center(
        child: Text(
      title,
      style: TextStyle(
          fontFamily: 'PressStart2P', fontSize: 11, color: Colors.white),
    )),
  );
}
