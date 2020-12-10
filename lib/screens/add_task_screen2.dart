import 'package:carousel_slider/carousel_slider.dart';
import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/widgets/new_category_alert.dart';
import 'package:ciao_app/widgets/no_task_name_alert.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:ciao_app/widgets/custom_cliprrect.dart' as CustomClipRRect;

class AddTaskScreen2 extends StatefulWidget {
  static DateFormat dateFormat = DateFormat('DD-MM-yyyy');

  @override
  _AddTaskScreen2State createState() => _AddTaskScreen2State();
}

class _AddTaskScreen2State extends State<AddTaskScreen2> {
  String newTaskTile;

  String newTaskCategory;

  String formattedDate = AddTaskScreen2.dateFormat.format(DateTime.now());

  var selectedCategory;

  int sliderIndex = 0;

  final snackBar = SnackBar(
    content: Text('Yay! A SnackBar!'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  List<Widget> sliderUserCategoriesList = <Widget>[];

  void addTask(Task task) {
    final tasksBox = Hive.box('tasks');
    tasksBox.add(task);
  }

  Widget carouselCategoryBuilder(Box box) {
    sliderUserCategoriesList.clear();
    List listOfKey = box.keys.toList();
    if (listOfKey.isNotEmpty && listOfKey.length == 1) {
      Category a = box.get(box.keys.first) as Category;
      selectedCategory = a.name;
    }

    listOfKey.forEach((element) {
      Category category = box.get(element) as Category;
      category.key = element;
      // print(category.name);
      Widget a = GestureDetector(
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
                  "Category",
                  style: KAddTaskScreenTitles,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          //
          //CarouselSlider containg the list of categories available
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                            bottomLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0)),
                      ),
                      height: 70,
                      width: 300,
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //TODO: work on this
    // Category a =
    //     Hive.box('categories').get(Hive.box('categories').keys.toList().first);
    // selectedCategory = a.name;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('categories').listenable(),
        builder: (context, box, widget) {
          print(box.keys);
          return Scaffold(
            // backgroundColor: Color(0xFF2A9D8F),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFF2A9D8F),
                      Color(0xFF9bdeff),
                    ]),
              ),
              child: Column(
                children: [
                  ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 35.0, left: 15),
                              child: Text('Add Task',
                                  style: KAddTaskScreenTitles.copyWith(
                                    fontSize: 33,
                                    color: Colors.white.withOpacity(.1),
                                  )),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            //
                            //OTHER COMPONESTS ON THE PAGE
                            //
                            Padding(
                              padding: const EdgeInsets.all(22.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //
                                  //'NAME' - TEXTFIELD TITLE
                                  //
                                  Text('Name', style: KAddTaskScreenTitles),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //
                                  // TEXT FIELD - in charge of capting the new task name
                                  //
                                  TextField(
                                    //TODO: add controller to clear filed after add task
                                    style: Klogo.copyWith(
                                      fontSize: 18,
                                      color: Colors.white,
                                      shadows: [],
                                    ),
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white24,
                                    ),
                                    autofocus: false,
                                    onChanged: (value) {
                                      newTaskTile = value;
                                      print(newTaskTile);
                                    },
                                  ),

                                  //
                                  //Task Categories carousel and new category button
                                  //
                                  Container(
                                    child: carouselCategoryBuilder(box),
                                  ),

                                  //
                                  //ADD BUTTON - used to triger the addition of the new task into the database
                                  //

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: FloatingActionButton(
                                              heroTag: 'addTaskScreenFAB1',
                                              splashColor: Colors.red,
                                              backgroundColor: KMainRed,
                                              onPressed: () {
                                                newCategoryAlert(context);
                                              },
                                              child: Icon(
                                                Icons.category_outlined,
                                                size: 33,
                                                color: Colors.white,
                                              ),
                                            )),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        child: RaisedButton(
                                          color: KMainOrange,
                                          onPressed: () {
                                            if (newTaskTile == null) {
                                              noTaskNameAlert(context);
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
                                              Flushbar(
                                                      duration:
                                                          Duration(seconds: 1),
                                                      messageText: Text(
                                                        'Task added successfuly.',
                                                        style: Klogo.copyWith(
                                                            color: Colors.white,
                                                            shadows: [],
                                                            fontSize: 14),
                                                      ),
                                                      flushbarStyle:
                                                          FlushbarStyle
                                                              .FLOATING)
                                                  .show(context);
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text('Add',
                                                style: Klogo.copyWith(
                                                  shadows: [],
                                                  fontSize: 19,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
                ],
              ),
            ),
          );
        });
  }
}

//  if (newTaskTile == null) {
//                                                   _showNoTaskNameDialog();
//                                                 } else {
//                                                   //unfocusing the keyboard to avoid UI break
//                                                   FocusScope.of(context)
//                                                       .unfocus();
//                                                   //Add task to the list

//                                                   Task task = Task();
//                                                   task.name = newTaskTile;
//                                                   task.category =
//                                                       selectedCategory;
//                                                   task.dueDate = formattedDate;
//                                                   task.isDone = false;
//                                                   addTask(task);
//                                                 }
//                                               },

Widget sliderCategoryItem(String categoryTitle) {
  String title = categoryTitle;
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Container(
      height: 25,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.white,
        ),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [Colors.red[600], Color(0xFFDD0426)]),
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
    ),
  );
}
