import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/model/theme_manager.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/screens/calendar_screen.dart';
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
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'model/category.dart';
import 'model/flags.dart';
import 'screens/dashboard.dart';
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
//* Initializing flags
  flagsBox.deleteAll(flagsBox.keys.toList());

  Hive.box('flags')
      .add(Flags(name: 'closeAddCategoryScreen', value: false, data: null));
  Hive.box('flags').putAt(
      0, Flags(name: 'closeAddCategoryScreen', value: false, data: null));
  Hive.box('flags')
      .add(Flags(name: 'openAddCategoryScreen', value: false, data: null));

  Hive.box('flags')
      .add(Flags(name: 'searchPageIsOpen', value: false, data: null));
  Hive.box('flags')
      .putAt(1, Flags(name: 'searchPageIsOpen', value: false, data: null));

  Hive.box('flags').add(
      Flags(name: 'addTaskScreenCarouselPageTurned', value: false, data: null));
  Hive.box('flags').putAt(2,
      Flags(name: 'addTaskScreenCarouselPageTurned', value: false, data: null));

  Hive.box('flags').add(Flags(
      name: 'taskListScreenCarouselPageTurned', value: false, data: null));
  Hive.box('flags').putAt(
      3,
      Flags(
          name: 'taskListScreenCarouselPageTurned', value: false, data: null));

  Hive.box('flags')
      .add(Flags(name: 'searchInProgress', value: false, data: null));

  Hive.box('flags')
      .putAt(4, Flags(name: 'searchInProgress', value: false, data: null));

  Hive.box('flags')
      .putAt(5, Flags(name: 'openAddCategoryScreen', value: false, data: null));

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
                builder: (context, box, widget) =>
                    ChangeNotifierProvider<ThemeNotifier>(
                        create: (_) => ThemeNotifier(), child: MyApp())),
          )));
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
    return Consumer<ThemeNotifier>(
      builder: (contex, theme, _) => MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            // ResponsiveBreakpoint.autoScale(800, name: TABLET),
            // ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          Dashboard.id: (context) => Dashboard(),
          SplashScreen.id: (context) => SplashScreen(),
          InfoScreen.id: (context) => InfoScreen(),
          TestScreen.id: (context) => TestScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          IntroScreen.id: (context) => IntroScreen(),
          CalendarScreen.id: (context) => CalendarScreen(),
        },
        theme: theme.getTheme(),
        home: HomeScreen(),
      ),
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

// class DefaultTheme extends CustomThemeData {
//   static final _default = DefaultTheme();

//   static DefaultTheme of(BuildContext context) =>
//       CustomThemes.of(context) ?? _default;

//   final TextStyle screensTitleTextStyle = TextStyle(
//     fontFamily: KPageTitleFontFamily,
//     fontSize: 43,
//     shadows: [
//       Shadow(
//         blurRadius: 2.0,
//         color: Colors.blue,
//         offset: Offset(5.0, 5.0),
//       ),
//       Shadow(
//         color: Colors.white,
//         blurRadius: 6.0,
//         offset: Offset(2.0, 2.0),
//       ),
//     ],
//   );
//   final TextStyle dashboardCarouselItemTitleStyle = TextStyle(
//     color: KMainPurple,
//     fontFamily: 'DMSerifTextRegular',
//     fontWeight: FontWeight.bold,
//     fontSize: 22,
//     shadows: [
//       Shadow(
//         blurRadius: 2.0,
//         color: Colors.blue,
//         offset: Offset(3.3, 3.3),
//       ),
//       Shadow(
//         color: Colors.white,
//         blurRadius: 6.0,
//         offset: Offset(2.0, 2.0),
//       ),
//     ],
//   );
//   final TextStyle dashboardTaskTileTitleStyle = TextStyle(
//     fontFamily: 'DMSerifTextRegular',
//     color: Colors.blue[50],
//     fontSize: 20,
//   );
//   final Gradient dashboardGradientColors = KMainLinearGradient;
// }
