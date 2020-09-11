import 'package:ciao_app/model/task.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widgets/stack_layout.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'model/task_data.dart';
import 'package:flutter/services.dart';
import 'package:ciao_app/screens/intro_screen.dart';

void main() async {
  // Hive initialisation
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TaskAdapter());
  final tasksBox =
      await Hive.openBox('tasks', compactionStrategy: (int total, int deleted) {
    return deleted > 0;
  });
  runApp(WatchBoxBuilder(box: tasksBox, builder: (context, box) => MyApp()));
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
    return ChangeNotifierProvider<TaskData>(
      create: (context) => TaskData(),
      child: MaterialApp(
        initialRoute: StackLayout.id,
        routes: {
          StackLayout.id: (context) => StackLayout(),
          IntroScreen.id: (context) => IntroScreen(),
        },
        home: StackLayout(),
      ),
    );
  }

  @override
  void dispose() {
    Hive.box('tasks').compact();
    Hive.close();
    super.dispose();
  }
}

// FutureBuilder(
// future: Hive.openBox('tasks'),
// builder: (BuildContext context, AsyncSnapshot snapshot) {
// if (snapshot.connectionState == ConnectionState.done) {
// if (snapshot.hasError) {
// return Text(snapshot.error.toString());
// } else {
// return StackLayout();
// }
// } else {
// return Center(
// child: CircularProgressIndicator(),
// );
// }
// },
// ),
