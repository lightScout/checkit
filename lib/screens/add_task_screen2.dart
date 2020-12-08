import 'package:carousel_slider/carousel_slider.dart';
import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  List<Widget> sliderUserCategoriesList = <Widget>[];

  void addTask(Task task) {
    final tasksBox = Hive.box('tasks');
    tasksBox.add(task);
  }

  void _showNewCategoryDialog(Box box) {
//TODO: updated UI with new customClipRRect

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          backgroundColor: Colors.red[800].withOpacity(0.75),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //
              // 'New Category' alert title
              //
              CustomClipRRect.customClipRRect(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    "New Category",
                    style: Klogo.copyWith(
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.red,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                      color: Colors.yellowAccent[700],
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Column(
              children: [
                Container(
                  height: 80,
                  width: 300,
                  child: TextField(
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: Klogo.copyWith(
                        fontSize: 22,
                        color: Colors.white,
                        shadows: [
                          // Shadow(
                          //   color: Colors.greenAccent,
                          //   blurRadius: 6.0,
                          //   offset: Offset(0.6, 0.6),
                          // )
                        ]),
                    decoration: InputDecoration(
                      border: KInputFieldRoundedCorners,
                      filled: true,
                      fillColor: Colors.black,
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
                  child: CustomClipRRect.customClipRRect(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        backgroundColor: Color(0xFFDD0426),
                        heroTag: 'NewCategoryAlertFAB',
                        onPressed: () {
                          Category newCategory =
                              Category(name: newTaskCategory);
                          box.add(newCategory);
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.add,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
                // Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.all(Radius.circular(25)),
                //     child: Material(
                //       color: Color(0xFFDD0426),
                //       elevation: 1,
                //       child: GestureDetector(
                //         child: Icon(
                //           Icons.add,
                //           size: 50,
                //           color: Colors.white,
                //         ),
                //         onTap: () {
                //           Category newCategory =
                //               Category(name: newTaskCategory);
                //           box.add(newCategory);
                //           Navigator.of(context).pop();
                //         },
                //       ),
                //     ),
                //   ),
                // ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          backgroundColor: Colors.redAccent.withOpacity(.75),
          title: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            child: Container(
              color: Colors.white12,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Attetion!",
                  style: Klogo.copyWith(
                    fontSize: 18,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.red,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          content: CustomClipRRect.customClipRRect(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Task without a name can not be added.",
                style: Klogo.copyWith(
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.red,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                  color: Colors.yellowAccent[700],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            // Button at the bottom of the dialog
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: FloatingActionButton(
                    heroTag: 'NoTaskNameFAB',
                    splashColor: Colors.blue,
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: Klogo.copyWith(
                        color: Colors.redAccent[200],
                        fontSize: 22,
                        shadows: [
                          Shadow(
                            offset: Offset(5, 5),
                            color: Colors.yellowAccent[700],
                            blurRadius: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
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
        //TODO: clean this part
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
    Category a =
        Hive.box('categories').get(Hive.box('categories').keys.toList().first);
    selectedCategory = a.name;
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
                                    autofocus: true,
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
                                              backgroundColor: Colors.teal,
                                              onPressed: () {
                                                _showNewCategoryDialog(box);
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
                                            Radius.circular(30)),
                                        child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: FloatingActionButton(
                                              heroTag: 'addTaskScreenFAB2',
                                              splashColor: Colors.teal,
                                              backgroundColor:
                                                  Color(0xFFDD0426),
                                              onPressed: () {
                                                if (newTaskTile == null) {
                                                  _showNoTaskNameDialog();
                                                } else {
                                                  //unfocusing the keyboard to avoid UI break
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  //Add task to the list

                                                  Task task = Task();
                                                  task.name = newTaskTile;
                                                  task.category =
                                                      selectedCategory;
                                                  task.dueDate = formattedDate;
                                                  task.isDone = false;
                                                  addTask(task);
                                                }
                                              },
                                              child: Icon(
                                                Icons.add_sharp,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            )),
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
