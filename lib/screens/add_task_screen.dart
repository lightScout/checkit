import 'package:animate_icons/animate_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/widgets/add_category_alert.dart';
import 'package:ciao_app/widgets/no_name_alert.dart';
import 'package:ciao_app/widgets/carousel_item.dart';
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

class AddTaskScreen extends StatefulWidget {
  static DateFormat dateFormat = DateFormat('DD-MM-yyyy');

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  //* String var used to host the new task tile
  String newTaskTitle;
  //* Int Var used to host categoriesBox length
  int categoriesBoxLength = 0;

  String newTaskCategory;

//* Support var for the notification functionalities
  DateTime selectedDate;
  bool notificationDateSelected = false;
  bool notificationOn = false;
  String _timezone = 'Unknown';

//* Var used to register the category selected through the categories carousel
  var selectedCategory;

//* List of widgets used by categories carousel
  List<Widget> carouselCategoriesList = <Widget>[];

//* TextField Controller
  final textFieldController = TextEditingController();

//* AnimatedIcon Controller
  AnimateIconController _animateIconController;
//* Reference to Hive box Categories
  final categoriesBox = Hive.box('categories');

//* Add task to Hive box support function
  void addTask(Task task) {
    final tasksBox = Hive.box('tasks');
    tasksBox.add(task);
  }

  //* Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformLocation() async {
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
    if (selectedDate.isBefore(DateTime.now())) {
      selectedDate = DateTime.now();
    }
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

//* This is used to check if the selected date is valid (in the fature)
  bool _validateSelectedDate(BuildContext context) {
    bool result;
    if (selectedDate.isBefore(DateTime.now())) {
      Flushbar(
        duration: Duration(seconds: 2),
        messageText: Text(
          'Pick a future date or time',
          style: Klogo.copyWith(color: Colors.white, shadows: [], fontSize: 14),
        ),
        flushbarStyle: FlushbarStyle.FLOATING,
      ).show(context);
      result = false;
    } else if (selectedDate.isAfter(DateTime.now())) {
      // Flushbar(
      //   duration: Duration(seconds: 2),
      //   messageText: Text(
      //     'Date and time selected successfully',
      //     style: Klogo.copyWith(color: Colors.white, shadows: [], fontSize: 14),
      //   ),
      //   flushbarStyle: FlushbarStyle.FLOATING,
      // ).show(context);
      result = true;
    }
    return result;
  }

  //* This builds material date picker in Android
  //TODO: code is now showing the time picker but 'date' and 'time' need to be merged into a DateTime variable to be verified

  buildMaterialDatePicker(BuildContext context) async {
    DateTime date;
    TimeOfDay time;
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2222),
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        date = picked;
      });
    }

    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null)
      setState(() {
        time = t;
      });

    // if (picked != null && picked != selectedDate)
    //   setState(() {
    //     selectedDate = picked;
    //   });
  }

  //* This builds cupertion date picker in iOS
  buildCupertinoDatePicker(BuildContext context) {
    print(selectedDate);
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
                            onTap: () {
                              setState(() {
                                notificationOn = false;
                              });

                              Navigator.of(context).pop();
                            }),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_validateSelectedDate(context)) {
                            setState(() {
                              notificationOn = true;
                            });
                            //! work on another way to dismiss the page
                            //! this method is interfering with the flush bar
                            //* successful selection of date and time flush bar disable
                            //* the line of code below can be used to pop all but the first route in the stack
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          }
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: KMainOrange,
                          child: Icon(
                            Icons.add,
                            size: 60,
                          ),
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
                        mode: CupertinoDatePickerMode.dateAndTime,
                        onDateTimeChanged: (picked) {
                          setState(() {
                            selectedDate = picked;
                          });
                          print(selectedDate);
                          print(
                              'day: ${selectedDate.day}, month: ${selectedDate.month}, year: ${selectedDate.year},');
                        },
                        initialDateTime: selectedDate,
                        minimumYear: 2020,
                        maximumYear: 2222,
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

    if (categoriesBox.isNotEmpty &&
        (categoriesBoxLength < categoriesBox.length ||
            categoriesBox.length == 1)) {
      selectedCategory =
          (categoriesBox.get(categoriesBox.keys.last) as Category).name;
      categoriesBoxLength = categoriesBox.length;
    }

    listOfKey.forEach((element) {
      //category.key = element;
      // print(category.name);

      carouselCategoriesList.insert(
          0,
          CarouselItem(
              categoryTitle: (categoriesBox.get(element) as Category).name));
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformLocation();
    selectedDate = DateTime.now();
    _animateIconController = AnimateIconController();
  }

  //*
  //* CATEGORY CAROUSEL BUILDER
  //*
  Widget categoriesCarousel() {
    buildCarouselList();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //*
            //* CATEGORY CAROUSEL SLIDER: containg the list of categories available
            //*
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(90)),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        // BoxShadow(
                        //   color: Colors.greenAccent,
                        //   offset: Offset(5.0, 5.0), //(x,y)
                        //   blurRadius: 30.0,
                        // ),
                      ],
                      color: Colors.teal.withOpacity(.7),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(90.0),
                          topRight: Radius.circular(90.0),
                          bottomLeft: Radius.circular(90.0),
                          bottomRight: Radius.circular(90.0)),
                    ),
                    height: 70,
                    width: MediaQuery.of(context).size.width * .85,
                    child: CarouselSlider(
                      options: CarouselOptions(
                          viewportFraction: .43,
                          aspectRatio: 3.8,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              selectedCategory = (carouselCategoriesList
                                      .elementAt(index) as CarouselItem)
                                  .categoryTitle;
                            });
                            print(selectedCategory);
                          }),
                      items: carouselCategoriesList,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
            //*
            //* SCREEN MAIN CONTAINER
            //*
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/textures/add_task_screen_texture5.png'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: Colors.white54,
                  width: 10,
                ),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.teal[400],
                      Colors.green[900],
                    ]),
              ),
              child: Column(
                children: [
                  ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),

                              //*
                              //* Notification Button & Screen title
                              //*

                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 20.0,
                                  left: 22.0,
                                  bottom: 20,
                                ),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //*
                                      //* BUTTON
                                      //*
                                      CustomClipRRect.customClipRRect(
                                        colors: [
                                          KMainPurple,
                                          Colors.teal,
                                        ],
                                        child: AnimateIcons(
                                          controller: _animateIconController,
                                          startIcon: notificationOn
                                              ? Icons.check
                                              : Icons.notifications,
                                          startTooltip: 'Icons.add',
                                          endTooltip: 'Icons.close',
                                          endIcon: notificationOn
                                              ? Icons.check
                                              : Icons.notifications,
                                          color: Colors.blue[50],
                                          size: 31,
                                          onStartIconPress: () {
                                            selectedDate = DateTime.now();
                                            _selectDate(context);
                                            return true;
                                          },
                                          onEndIconPress: () {
                                            selectedDate = DateTime.now();
                                            _selectDate(context);
                                            return true;
                                          },
                                        ),
                                      ),
                                      //*
                                      //* SCREEN TITLE
                                      //*
                                      Text(
                                        'Add task',
                                        style: Klogo.copyWith(
                                          fontSize: 16,
                                          shadows: [
                                            Shadow(
                                              color: KMainPurple,
                                              blurRadius: 1,
                                              offset: Offset(5.0, 5.0),
                                            )
                                          ],
                                          color: Colors.blue[50],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //*
                              //*FIRST: CATGORY CAROUSEL
                              //*
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //*
                                  //* TASK CATEGORIES CAROUSEL
                                  //*

                                  Container(
                                    child: categoriesCarousel(),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 20,
                              ),
                              //*
                              //* SECOND: TEXTFEILD 'ADD TASK HERE'
                              //*
                              TextField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: textFieldController,
                                style: Klogo.copyWith(
                                  fontSize: 13,
                                  color: Colors.white,
                                  shadows: [],
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'Task name here',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[350],
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                    borderSide: BorderSide(
                                        color: Colors.white70, width: 5.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white70, width: 5.0),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.teal,
                                ),
                                autofocus: false,
                                onChanged: (value) {
                                  newTaskTitle = value;
                                  print(newTaskTitle);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              //*
                              //* THIRD: Notification buttom
                              //*

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: [],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              //*
                              //*FOURTH: ADD TASK BUTTON
                              //*
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(90)),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .17,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              .17,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: KTopLinearGradientColor,
                                            offset:
                                                Offset(-10.0, -15.0), //(x,y)
                                            blurRadius: 22.0,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FloatingActionButton(
                                            splashColor: KMainOrange,
                                            backgroundColor: KMainPurple,
                                            onPressed: () {
                                              if (newTaskTitle == null ||
                                                  newTaskTitle.trim() == '') {
                                                noNameAlert(context, 'Task');
                                              } else {
                                                if (notificationOn &&
                                                    _validateSelectedDate(
                                                        context)) {
                                                  Task task = Task();
                                                  task.name = newTaskTitle;
                                                  task.category =
                                                      selectedCategory;
                                                  task.dueDate = notificationOn
                                                      ? "${DateFormat.yMd().add_jm().format(selectedDate)}"
                                                      : null;
                                                  task.isDone = false;
                                                  addTask(task);
                                                  setState(() {
                                                    newTaskTitle = null;
                                                    notificationOn = false;
                                                  });

                                                  Flushbar(
                                                    duration:
                                                        Duration(seconds: 2),
                                                    messageText: Text(
                                                      'Task and reminder added successfuly.',
                                                      style: Klogo.copyWith(
                                                          color: Colors.white,
                                                          shadows: [],
                                                          fontSize: 14),
                                                    ),
                                                    flushbarStyle:
                                                        FlushbarStyle.FLOATING,
                                                  ).show(context);
                                                  textFieldController.clear();
                                                  _scheduleNotification();
                                                } else if (!notificationOn) {
                                                  Task task = Task();
                                                  task.name = newTaskTitle;
                                                  task.category =
                                                      selectedCategory;
                                                  task.dueDate = notificationOn
                                                      ? "${selectedDate.toLocal()}"
                                                          .split(' ')[0]
                                                      : null;
                                                  task.isDone = false;
                                                  addTask(task);
                                                  setState(() {
                                                    newTaskTitle = null;
                                                  });

                                                  Flushbar(
                                                    duration:
                                                        Duration(seconds: 2),
                                                    messageText: Text(
                                                      'Task added successfuly.',
                                                      style: Klogo.copyWith(
                                                          color: Colors.white,
                                                          shadows: [],
                                                          fontSize: 14),
                                                    ),
                                                    flushbarStyle:
                                                        FlushbarStyle.FLOATING,
                                                  ).show(context);
                                                  textFieldController.clear();
                                                }
                                              }
                                            },
                                            child: Icon(
                                              Icons.fingerprint,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .09,
                                              color: Colors.greenAccent,
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          );
        });
  }

  tz.TZDateTime _nextNotificationInstance(DateTime selectedDate) {
    // final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedDate.hour,
        selectedDate.minute,
        selectedDate.second);
    return scheduledDate;
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
      _nextNotificationInstance(selectedDate),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
