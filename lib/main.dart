import 'package:flutter/material.dart';
import 'widgets/stack_layout.dart';
import 'package:provider/provider.dart';
import 'model/task_data.dart';
import 'package:flutter/services.dart';
import 'package:ciao_app/screens/dashboard.dart';
import 'package:ciao_app/screens/intro_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
}
