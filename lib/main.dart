import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/screens/info_screen.dart';
import 'package:ciao_app/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'model/category.dart';
import 'screens/dashboard_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  //
  // Hive initialisation
  //
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  //
  //Hive adpters registration
  //
  Hive.registerAdapter(
    TaskAdapter(),
  );
  Hive.registerAdapter(
    CategoryAdapter(),
  );

  //
  //Hive box creation
  //
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
  //
  //Adding permanent category 'Daily' to categories box
  //
  if (categoriesBox.isEmpty) {
    categoriesBox.add(Category(name: 'Daily'));
  } else {
    categoriesBox.putAt(0, Category(name: 'Daily'));
  }

  runApp(ValueListenableBuilder(
    valueListenable: categoriesBox.listenable(),
    builder: (context, box, widget) => ValueListenableBuilder(
        valueListenable: tasksBox.listenable(),
        builder: (context, box, widget) => MyApp()),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        StackLayout.id: (context) => StackLayout(),
        SplashScreen.id: (context) => SplashScreen(),
        InfoScreen.id: (context) => InfoScreen(),
        TestScreen.id: (context) => TestScreen(),
      },
      home: StackLayout(),
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
