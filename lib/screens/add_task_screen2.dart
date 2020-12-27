import 'package:carousel_slider/carousel_slider.dart';
import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/widgets/add_category_alert.dart';
import 'package:ciao_app/widgets/no_task_name_alert.dart';
import 'package:ciao_app/widgets/slider_category_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ciao_app/main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:ciao_app/widgets/custom_cliprrect.dart' as CustomClipRRect;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class AddTaskScreen2 extends StatefulWidget {
  static DateFormat dateFormat = DateFormat('DD-MM-yyyy');

  @override
  _AddTaskScreen2State createState() => _AddTaskScreen2State();
}

class _AddTaskScreen2State extends State<AddTaskScreen2> {
  String newTaskTile;

  String _timezone = 'Unknown';

  String newTaskCategory;

  DateTime selectedDate = DateTime.now();

  bool wasDateSelected = false;

  var selectedCategory;

  List<Widget> carouselCategoriesList = <Widget>[];

  final textFieldController = TextEditingController();

  final categoriesBox = Hive.box('categories');

  void addTask(Task task) {
    final tasksBox = Hive.box('tasks');
    tasksBox.add(task);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String timezone;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      timezone = await FlutterNativeTimezone.getLocalTimezone();
    } on PlatformException {
      timezone = 'Failed to get the timezone.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _timezone = timezone;
    });
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
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.transparent.withOpacity(.80),
                      Colors.blueAccent
                    ]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              height: MediaQuery.of(context).copyWith().size.height / 2.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: GestureDetector(
                          child: Icon(Icons.remove),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: KMainOrange,
                        child: GestureDetector(
                          child: Icon(
                            Icons.add,
                            size: 60,
                          ),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      )
                    ],
                  ),
                  Expanded(
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
                          if (picked.isBefore(DateTime.now())) {
                            print('invalid date');
                          } else if (picked != null && picked != selectedDate)
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
                ],
              ),
            ),
          );
        });
  }

  void buildCarouselList() {
    carouselCategoriesList.clear();
    List listOfKey = categoriesBox.keys.toList();
    if (categoriesBox.isNotEmpty && categoriesBox.length == 1) {
      selectedCategory =
          (categoriesBox.get(categoriesBox.keys.last) as Category).name;
    }

    listOfKey.forEach((element) {
      //category.key = element;
      // print(category.name);

      carouselCategoriesList.insert(
          0,
          SliderCategoryItem(
              categoryTitle: (categoriesBox.get(element) as Category).name));
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Widget categoriesCarousel() {
    buildCarouselList();
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
                            viewportFraction: .44,
                            aspectRatio: 3.8,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                selectedCategory = (carouselCategoriesList
                                        .elementAt(index) as SliderCategoryItem)
                                    .categoryTitle;
                              });
                              print(selectedCategory);
                            }),
                        items: carouselCategoriesList,
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
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      KPersinanGreen,
                      KBabyBlue,
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
                            //ADD TASK AND CATEGORY BLOCK
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
                                    //TASK CATEGORIES CAROUSEL
                                    //
                                    Container(
                                      child: categoriesCarousel(),
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
                                                  addCategoryAlert(context);
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
                                        //ADD REMINDER BUTTON AND SWITCH
                                        //
                                        Hive.box('categories').isEmpty
                                            ? SizedBox()
                                            : Row(
                                                children: [
                                                  Switch(
                                                    value: wasDateSelected,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        wasDateSelected = value;
                                                      });
                                                    },
                                                    activeTrackColor:
                                                        Colors.green.shade200,
                                                    activeColor: KPersinanGreen,
                                                  ),
                                                  Hive.box('categories').isEmpty
                                                      ? SizedBox()
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
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
                                                                      Colors
                                                                          .red,
                                                                  backgroundColor:
                                                                      wasDateSelected
                                                                          ? KMainPurple
                                                                          : Colors
                                                                              .grey,
                                                                  onPressed: wasDateSelected
                                                                      ? () =>
                                                                          // _scheduleNotification()
                                                                          _selectDate(context)
                                                                      : () {},
                                                                  child: Icon(
                                                                    Icons
                                                                        .notifications,
                                                                    size: 23,
                                                                    color: Colors
                                                                        .white,
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
                                                      //unfocusing the keyboard to avoid pixel overflow
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
                                                          : null;
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

  void _scheduleNotification() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(_timezone));

    var andriodPlatformChannelSpecifics = AndroidNotificationDetails(
        'checKit_notif', 'checKit_notif', 'Channel for checKit notification',
        icon: 'app_icon_v2');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
        android: andriodPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'schedule title',
      'schedule body',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
