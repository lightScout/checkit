import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/model/theme_manager.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/widgets/delete_all_tasks_alert.dart';

import 'package:ciao_app/widgets/list_builder.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dynamic_overflow_menu_bar/dynamic_overflow_menu_bar.dart';
import 'package:provider/provider.dart';
import 'add_task_screen2.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';

class FullScreenPage extends StatefulWidget {
  final String category;

  const FullScreenPage({this.category});

  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  TextEditingController _titleTextController;
  bool wasAllTaskToggled = false;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isPageMinimized = false;
  double topBorderRadius = 0;
  final GlobalKey<ListBuilderState> _listBuilderKey = GlobalKey();
  CustomPopupMenuController _controller = CustomPopupMenuController();
  List<ItemModel> menuItems;

  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController(
      text: "${widget.category}",
    );
    _titleTextController.addListener(() {
      setState(() {});
    });

    menuItems = [
      ItemModel('Add task', Icons.add_rounded, () {
        if (isPageMinimized) {
          setState(() {
            isPageMinimized = false;
            yOffset = 0;
            topBorderRadius = 0;
          });
        } else {
          setState(() {
            topBorderRadius = 50;
            yOffset = MediaQuery.of(context).size.height / 2.5;
            isPageMinimized = true;
          });
        }
      }),
      ItemModel('checKit all tasks', Icons.done_all_rounded, () {
        _toggleAllTask();
      }),
      ItemModel('Delete all tasks', Icons.delete_rounded, () {
        deleteCategoryAlert(
            context, _listBuilderKey.currentState.emptyList, widget.category);
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    String category = widget.category;

    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: DynamicOverflowMenuBar(
          title: Text(
            _titleTextController.text,
            style: TextStyle(
              fontFamily: 'DMSerifTextRegular',
              fontSize: 22,
            ),
          ),
          actions: <OverFlowMenuItem>[
            OverFlowMenuItem(
              onPressed: () {},
              label: 'Menu',
              child: CustomPopupMenu(
                showArrow: false,
                child: Container(
                  child: Icon(
                    Icons.more_vert_rounded,
                    size: 26,
                  ),
                  padding: EdgeInsets.all(20),
                ),
                menuBuilder: () => ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: const Color(0xFF4C4C4C),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: menuItems
                            .map(
                              (item) => GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _controller.hideMenu();
                                  item.function();
                                },
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        item.icon,
                                        size: 26,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            item.title,
                                            style: TextStyle(
                                              fontFamily: KTextFontFamily,
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
                pressType: PressType.singleClick,
                verticalMargin: -10,
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
      //* STACK
      body: Stack(
        children: [
          //* Back container
          AddTaskScreen2(
            category: category,
          ),
          //* Front container
          AnimatedContainer(
            curve: Curves.ease,
            transform: Matrix4.translationValues(
              0,
              yOffset,
              0,
            )..scale(scaleFactor),
            duration: Duration(milliseconds: 600),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(topBorderRadius),
                  topRight: Radius.circular(topBorderRadius),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                            gradient: (Provider.of<ThemeNotifier>(context)
                                        .getThemeMode ==
                                    'dark')
                                ? KBGGradientDark
                                : LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                        Colors.indigo[900],
                                        Colors.indigo
                                      ]),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                          child: ValueListenableBuilder(
                            valueListenable: Hive.box('tasks').listenable(),
                            builder: (context, box, widget) {
                              return ListBuilder(
                                key: _listBuilderKey,
                                listCategory: category,
                                tasksBox: Hive.box('tasks'),
                                isBgGradientInverted:
                                    (Provider.of<ThemeNotifier>(context)
                                                .getThemeMode ==
                                            'dark')
                                        ? false
                                        : true,
                                isTaskScreen: false,
                              );
                            },
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleAllTask() {
    if (Hive.box('tasks').isNotEmpty) {
      setState(() {
        wasAllTaskToggled = !wasAllTaskToggled;
      });
      List listOfTaksKeys = Hive.box('tasks').keys.toList();
      // print(listOfKeys);

      listOfTaksKeys.forEach((element) {
        Task task = Hive.box('tasks').get(element) as Task;
        if (task.category == widget.category) {
          task.toggleDone();
          Hive.box('tasks').put(element, task);
        }
      });
    }
  }
}

class ItemModel {
  String title;
  IconData icon;
  Function function;
  ItemModel(this.title, this.icon, this.function);
}
