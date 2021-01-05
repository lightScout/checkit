import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/screens/home_screen.dart';
import 'package:ciao_app/screens/info_screen.dart';
import 'package:ciao_app/screens/intro_screen.dart';
import 'package:ciao_app/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'model/category.dart';
import 'model/flags.dart';
import 'screens/task_list_screen.dart';
import 'screens/splash_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const initializationSettingsAndriod =
      AndroidInitializationSettings('app_icon_v2');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {});

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndriod, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload' + payload);
    }
  });

  //*
  //* Hive initialisation
  //*
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  //*
  //*Hive adpters registration
  //*
  Hive.registerAdapter(
    TaskAdapter(),
  );
  Hive.registerAdapter(
    CategoryAdapter(),
  );
  Hive.registerAdapter(
    FlagsAdapter(),
  );

  //*
  //* Hive boxes creation
  //*
  final tasksBox = await Hive.openBox(
    'tasks',
    compactionStrategy: (int total, int deleted) {
      return deleted > 0;
    },
  );
  final categoriesBox = await Hive.openBox(
    'categories',
    compactionStrategy: (int total, int deleted) {
      return deleted > 0;
    },
  );
  final flagsBox = await Hive.openBox(
    'flags',
    compactionStrategy: (int total, int deleted) {
      return deleted > 0;
    },
  );

  //
  //Adding permanent category 'General' to categories box
  //
  // categoriesBox.clear();
  // tasksBox.clear();
  runApp(ValueListenableBuilder(
      valueListenable: flagsBox.listenable(),
      builder: (context, box, widget) => ValueListenableBuilder(
            valueListenable: categoriesBox.listenable(),
            builder: (context, box, widget) => ValueListenableBuilder(
                valueListenable: tasksBox.listenable(),
                builder: (context, box, widget) => MyApp()),
          )));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Hive.box('flags').add(Flags(name: 'toggleAddCategoryScreen', value: false));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        TaskListScreen.id: (context) => TaskListScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        InfoScreen.id: (context) => InfoScreen(),
        TestScreen.id: (context) => TestScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        IntroScreen.id: (context) => IntroScreen(),
      },
      home: HomeScreen(),
    );
  }

  @override
  void dispose() {
    Hive.box('tasks').compact();
    Hive.box('categories').compact();
    Hive.close();
    super.dispose();
  }
}
