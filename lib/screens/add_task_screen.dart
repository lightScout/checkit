import 'package:animate_icons/animate_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/model/flags.dart';
import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/model/theme_manager.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/widgets/custom_cliprrect.dart';
import 'package:ciao_app/widgets/info_alert.dart';
import 'package:ciao_app/widgets/list_builder.dart';
import 'package:ciao_app/widgets/no_name_alert.dart';
import 'package:ciao_app/widgets/carousel_item.dart';
import 'package:ciao_app/widgets/title_bubble.dart';
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
import 'package:provider/provider.dart';
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

  final _carouselController = CarouselController();

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
        return buildCupertinoDatePicker(context);
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
        duration: Duration(milliseconds: 1500),
        messageText: Text(
          'Pick a future date or time',
          style: TextStyle(
            fontFamily: KTextFontFamily,
            color: Colors.white,
            shadows: [],
            fontSize: 14,
          ),
        ),
        flushbarStyle: FlushbarStyle.FLOATING,
      ).show(context);
      result = false;
    } else if (selectedDate.isAfter(DateTime.now())) {
      result = true;
    }
    return result;
  }

  //* This builds cupertion date picker
  buildCupertinoDatePicker(BuildContext context) {
    // print(selectedDate);
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
                    colors: (Provider.of<ThemeNotifier>(context).getThemeMode ==
                            'dark')
                        ? [
                            Colors.transparent.withOpacity(.80),
                            Color(0xFF54525E)
                          ]
                        : [Colors.transparent.withOpacity(.80), Colors.indigo]),
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
                        backgroundColor:
                            (Provider.of<ThemeNotifier>(context).getThemeMode ==
                                    'dark')
                                ? KMainRed
                                : KMainPurple,
                        radius: 40,
                        child: GestureDetector(
                            child: Icon(
                              Icons.remove_rounded,
                              size: 33,
                              color: Colors.white,
                            ),
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
                            Icons.add_rounded,
                            color: Colors.white,
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
                            fontFamily: KTextFontFamily,
                            fontSize: 24,
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
                          // print(selectedDate);
                          // print(
                          //     'day: ${selectedDate.day}, month: ${selectedDate.month}, year: ${selectedDate.year},');
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
    //*clean carouselCateogryList and grabbing reference to categoriesBox keys
    carouselCategoriesList.clear();
    List listOfKey = categoriesBox.keys.toList();
    if (categoriesBox.isEmpty) {
      categoriesBoxLength = 0;
    }
//* check if category box has items
    if (categoriesBoxLength == 0 && categoriesBox.length > 0) {
      categoriesBoxLength = categoriesBox.length;
      selectedCategory =
          (categoriesBox.get(categoriesBox.keys.last) as Category).name;
    }
//* check if new category was added
    if ((categoriesBox.isNotEmpty) &&
        categoriesBoxLength < categoriesBox.length) {
      selectedCategory =
          (categoriesBox.get(categoriesBox.keys.last) as Category).name;
      categoriesBoxLength = categoriesBox.length;

      _carouselController.animateToPage(0);
    }
//* adding elements to carouselCategory list
    listOfKey.forEach((element) {
      carouselCategoriesList.insert(
          0,
          CarouselItem(
              categoryTitle: (categoriesBox.get(element) as Category).name));
    });

    //* syncing the carousel when task list screen carousel get its page turned

    if ((Hive.box('flags').getAt(3) as Flags).value) {
      var indexName = (Hive.box('flags').getAt(3) as Flags).data;
      carouselCategoriesList.forEach((element) {
        if ((element as CarouselItem).categoryTitle == indexName) {
          //* syncing the carousel
          _carouselController
              .animateToPage(carouselCategoriesList.indexOf(element));
          //* storing category valeu
          selectedCategory =
              (carouselCategoriesList[carouselCategoriesList.indexOf(element)]
                      as CarouselItem)
                  .categoryTitle;
          categoriesBoxLength = categoriesBox.length;

          //* flag to signal synced carousel
          Hive.box('flags').putAt(
              3,
              Flags(
                name: 'taskListScreenCarouselPageTurned',
                value: false,
                data: null,
              ));
        }
      });
    }
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
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(90.0),
                          topRight: Radius.circular(90.0),
                          bottomLeft: Radius.circular(90.0),
                          bottomRight: Radius.circular(90.0)),
                    ),
                    height: 70,
                    width: MediaQuery.of(context).size.width * .85,
                    child: CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        viewportFraction: .38,
                        aspectRatio: 11,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          if (carouselCategoriesList.isNotEmpty) {
                            setState(() {
                              selectedCategory = (carouselCategoriesList
                                      .elementAt(index) as CarouselItem)
                                  .categoryTitle;
                              //* flag to signal sync carousel acrros the app
                              Hive.box('flags').putAt(
                                  2,
                                  Flags(
                                      name: 'ADDTASKCAROUSELPAGETURNED',
                                      value: true,
                                      data: (carouselCategoriesList[index]
                                              as CarouselItem)
                                          .categoryTitle));
                            });
                            // print(selectedCategory);
                          }
                        },
                      ),
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
          // print(box.keys);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            //*
            //* SCREEN MAIN CONTAINER
            //*
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: (Provider.of<ThemeNotifier>(context).getThemeMode ==
                          'dark')
                      ? AssetImage(
                          'assets/textures/add_task_screen_texture_dark.png')
                      : AssetImage(
                          'assets/textures/add_task_screen_texture.png'),
                ),
                border: Border.all(
                  color: Colors.white54,
                  width: 10,
                ),
                gradient:
                    (Provider.of<ThemeNotifier>(context).getThemeMode == 'dark')
                        ? KBGGradientDark
                        : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                                Colors.indigo[900],
                                Colors.purple[700],
                              ]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  //*
                  //* Notification Button & Screen title
                  //*

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 28.0,
                      right: 20.0,
                      left: 22.0,
                    ),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //*
                          //* BUTTON
                          //*
                          CustomClipRRect.customClipRRect(
                            colors: (Provider.of<ThemeNotifier>(context)
                                        .getThemeMode ==
                                    'dark')
                                ? KButtonsBGGrandientColorsDark
                                : [
                                    KMainPurple,
                                    Colors.purple,
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

                          //* INFO BUTTON
                          customClipRRect(
                            colors: [
                              Colors.yellow[50].withOpacity(.5),
                              Colors.white12
                            ],
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: () {
                                  infoAlert(
                                    context,
                                    'Choose your category and add your task',
                                  );
                                },
                                child: Icon(Icons.error_outline_rounded,
                                    color: Colors.white60),
                              ),
                            ),
                          ),
                          //*
                          //* SCREEN TITLE
                          //*
                          // TitleBubble(
                          //   borderColor:
                          //       Colors.white12.withOpacity(.045),
                          //   insideColor:
                          //       Colors.indigo[400].withOpacity(.2),
                          //   child: Text(
                          //     'Add task',
                          //     style: Klogo.copyWith(
                          //       fontSize: 32,
                          //       shadows: [
                          //         Shadow(
                          //           color: Colors.tealAccent
                          //               .withOpacity(.2),
                          //           blurRadius: 1,
                          //           offset: Offset(5.0, 5.0),
                          //         ),
                          //         Shadow(
                          //           color: Colors.white24,
                          //           blurRadius: 1,
                          //           offset: Offset(2.0, 2.0),
                          //         )
                          //       ],
                          //       color: Colors.blue[50],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 125,
                  ),
                  //*
                  //* CATGORY CAROUSEL
                  //*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder(
                          valueListenable: Hive.box('flags').listenable(),
                          builder: (context, box, widget) {
                            return Container(
                              child: categoriesCarousel(),
                            );
                          }),
                    ],
                  ),

                  SizedBox(
                    height: 0,
                  ),
                  //*
                  //* TEXTFEILD 'ADD TASK HERE'
                  //*
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: TextField(
                      cursorColor: Colors.white,
                      textCapitalization: TextCapitalization.sentences,
                      controller: textFieldController,
                      style: Klogo.copyWith(
                        fontSize: 22,
                        fontFamily: 'DMSerifTextRegular',
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
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        filled: false,
                        fillColor: Colors.white24,
                      ),
                      autofocus: false,
                      onChanged: (value) {
                        newTaskTitle = value;
                        // print(newTaskTitle);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //*
                  //*FOURTH: ADD TASK BUTTON
                  //*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(90)),
                        child: Container(
                          height: MediaQuery.of(context).size.height * .12,
                          width: MediaQuery.of(context).size.height * .12,
                          decoration: BoxDecoration(
                            boxShadow: [
                              (Provider.of<ThemeNotifier>(context)
                                          .getThemeMode ==
                                      'dark')
                                  ? BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-10.0, -15.0), //(x,y)
                                      blurRadius: 22.0,
                                    )
                                  : BoxShadow(
                                      color: Colors.purple[800],
                                      offset: Offset(-10.0, -15.0),
                                      blurRadius: 22.0,
                                    ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton(
                                splashColor: KMainOrange,
                                backgroundColor:
                                    (Provider.of<ThemeNotifier>(context)
                                                .getThemeMode ==
                                            'dark')
                                        ? KMainOrange
                                        : Colors.black,
                                onPressed: () {
                                  if (newTaskTitle == null ||
                                      newTaskTitle.trim() == '') {
                                    noNameAlert(context, 'Task');
                                  } else {
                                    if (notificationOn &&
                                        _validateSelectedDate(context)) {
                                      Task task = Task();
                                      task.name = newTaskTitle;
                                      task.category = selectedCategory;
                                      task.dueDateTime =
                                          notificationOn ? selectedDate : null;
                                      task.isDone = false;
                                      addTask(task);

                                      _scheduleNotification(
                                          selectedCategory, newTaskTitle);
                                      setState(() {
                                        newTaskTitle = null;
                                        notificationOn = false;
                                      });

                                      Flushbar(
                                        duration: Duration(milliseconds: 1500),
                                        messageText: Text(
                                          'Task and reminder added successfuly.',
                                          style: TextStyle(
                                              fontFamily: KTextFontFamily,
                                              shadows: [],
                                              fontSize: 14),
                                        ),
                                        flushbarStyle: FlushbarStyle.FLOATING,
                                      ).show(context);
                                      textFieldController.clear();
                                      FocusScope.of(context).unfocus();
                                    } else if (!notificationOn) {
                                      Task task = Task();
                                      task.name = newTaskTitle;
                                      task.category = selectedCategory;
                                      task.dueDateTime = null;
                                      task.isDone = false;
                                      addTask(task);
                                      setState(() {
                                        newTaskTitle = null;
                                      });

                                      Flushbar(
                                        duration: Duration(milliseconds: 1500),
                                        messageText: Text(
                                          'Task added successfuly.',
                                          style: TextStyle(
                                              fontFamily: KTextFontFamily,
                                              color: Colors.white,
                                              shadows: [],
                                              fontSize: 14),
                                        ),
                                        flushbarStyle: FlushbarStyle.FLOATING,
                                      ).show(context);
                                      textFieldController.clear();
                                      FocusScope.of(context).unfocus();
                                    }
                                  }
                                },
                                child: Icon(
                                  Icons.fingerprint_rounded,
                                  size:
                                      MediaQuery.of(context).size.height * .06,
                                  color: (Provider.of<ThemeNotifier>(context)
                                              .getThemeMode ==
                                          'dark')
                                      ? Colors.white
                                      : Colors.pink[100],
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
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

  void _scheduleNotification(String category, String task) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(_timezone));

    var andriodPlatformChannelSpecifics = AndroidNotificationDetails(
      'checKit_notif',
      'checKit_notif',
      'Channel for checKit notification',
      icon: 'app_icon_v2',
      importance: Importance.max,
      priority: Priority.high,
    );
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
      category,
      'Reminder: $task',
      _nextNotificationInstance(selectedDate),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
