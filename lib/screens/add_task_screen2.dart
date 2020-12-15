import 'package:carousel_slider/carousel_slider.dart';
import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/widgets/new_category_alert.dart';
import 'package:ciao_app/widgets/no_task_name_alert.dart';
import 'package:flutter/cupertino.dart';
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

  DateTime selectedDate = DateTime.now();

  bool wasDateSelected = false;

  var selectedCategory;

  int sliderIndex = 0;

  List<Widget> sliderUserCategoriesList = <Widget>[];

  final textFieldController = TextEditingController();

  void addTask(Task task) {
    final tasksBox = Hive.box('tasks');
    tasksBox.add(task);
  }

  _selectDate(BuildContext context) async {
    setState(() {
      selectedDate = DateTime.now();
    });
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  /// This builds material date picker in Android
  buildMaterialDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  /// This builds cupertion date picker in iOS
  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext builder) {
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: KMainRed,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              height: MediaQuery.of(context).copyWith().size.height / 2.5,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: KMainFontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (picked) {
                    if (picked != null && picked != selectedDate)
                      setState(() {
                        selectedDate = picked;
                      });
                  },
                  initialDateTime: selectedDate,
                  minimumYear: 2020,
                  maximumYear: 2030,
                ),
              ),
            ),
          );
        });
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Icon(
                  Icons.category,
                  color: Colors.white,
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
                                  const EdgeInsets.only(top: 30.0, left: 15),
                              child: Text('Add Task',
                                  style: KAddTaskScreenTitles.copyWith(
                                    fontSize: 33,
                                    color: Colors.white.withOpacity(.1),
                                  )),
                            ),

                            SizedBox(
                              height: 15,
                            ),
                            //
                            //OTHER COMPONESTS ON THE PAGE
                            //
                            CustomClipRRect.customClipRRect(
                              child: Padding(
                                padding: const EdgeInsets.all(22.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    //
                                    //'NAME' - TEXTFIELD TITLE
                                    //

                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('Name',
                                          style: KAddTaskScreenTitles),
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),
                                    //
                                    // TEXT FIELD - in charge of capting the new task name
                                    //
                                    TextField(
                                      controller: textFieldController,
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
                                    SizedBox(
                                      height: 20,
                                    ),
                                    //
                                    //ADD BUTTON - used to triger the addition of the new task into the database
                                    //

                                    Row(
                                      mainAxisAlignment:
                                          Hive.box('categories').isEmpty
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        //
                                        //ADD CATEGORY BUTTON
                                        //
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: FloatingActionButton(
                                                heroTag: 'addTaskScreenFAB1',
                                                splashColor: Colors.red,
                                                backgroundColor:
                                                    Hive.box('categories')
                                                            .isEmpty
                                                        ? KMainRed
                                                        : KMainPurple,
                                                onPressed: () {
                                                  newCategoryAlert(context);
                                                },
                                                child: Icon(
                                                  Hive.box('categories').isEmpty
                                                      ? Icons.priority_high
                                                      : Icons.category,
                                                  size: 33,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ),

                                        //
                                        //ADD REMINDER BUTTON
                                        //
                                        Row(
                                          children: [
                                            Switch(
                                              value: wasDateSelected,
                                              onChanged: (value) {
                                                setState(() {
                                                  wasDateSelected = value;
                                                });
                                              },
                                              activeTrackColor:
                                                  Colors.lightGreenAccent,
                                              activeColor: Colors.green,
                                            ),
                                            Hive.box('categories').isEmpty
                                                ? SizedBox()
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        child: Container(
                                                          height: 50,
                                                          child:
                                                              FloatingActionButton(
                                                            heroTag:
                                                                'addTaskScreenFAB2',
                                                            splashColor:
                                                                Colors.red,
                                                            backgroundColor:
                                                                Hive.box('categories')
                                                                        .isEmpty
                                                                    ? KMainRed
                                                                    : KMainPurple,
                                                            onPressed: () =>
                                                                _selectDate(
                                                                    context),
                                                            child: Icon(
                                                              Icons
                                                                  .notifications,
                                                              size: 23,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //
                                        //ADD TASK BUTTON
                                        //
                                        Hive.box('categories').isEmpty
                                            ? SizedBox()
                                            : ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25)),
                                                child: RaisedButton(
                                                  color: KMainOrange,
                                                  onPressed: () {
                                                    if (newTaskTile == null) {
                                                      noTaskNameAlert(context);
                                                    } else {
                                                      //unfocusing the keyboard to avoid UI break
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      //Add task to the list

                                                      Task task = Task();
                                                      task.name = newTaskTile;
                                                      task.category =
                                                          selectedCategory;
                                                      task.dueDate = wasDateSelected
                                                          ? "${selectedDate.toLocal()}"
                                                              .split(' ')[0]
                                                          : 'Alert not set';
                                                      task.isDone = false;
                                                      addTask(task);
                                                      setState(() {
                                                        newTaskTile = null;
                                                      });
                                                      Flushbar(
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              messageText: Text(
                                                                'Task added successfuly.',
                                                                style: Klogo.copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                    shadows: [],
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              flushbarStyle:
                                                                  FlushbarStyle
                                                                      .FLOATING)
                                                          .show(context);
                                                      textFieldController
                                                          .clear();
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
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
