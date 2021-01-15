import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/others/constants.dart';

import 'package:ciao_app/widgets/list_builder.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dynamic_overflow_menu_bar/dynamic_overflow_menu_bar.dart';
import 'add_task_screen2.dart';

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

  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController(
      text: "${widget.category}",
    );
    _titleTextController.addListener(() {
      setState(() {});
    });
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
                child: IconButton(
                  tooltip: "Delete Category",
                  icon: Icon(
                    Icons.delete_forever,
                    size: 33,
                  ),
                  onPressed: () {},
                ),
                label: "Delete all",
                onPressed: () {}),
            OverFlowMenuItem(
                child: IconButton(
                  splashColor: Color(0xFF000328).withBlue(-20),
                  splashRadius: 22.2,
                  tooltip: 'checKit all',
                  icon: Icon(
                    Icons.done_all,
                    size: 33,
                  ),
                  onPressed: () {
                    _toggleAllTask();
                  },
                ),
                label: 'checKit all',
                onPressed: () {}),
            OverFlowMenuItem(
              child: IconButton(
                  tooltip: 'Add task',
                  splashColor: Color(0xFF000328).withBlue(-20),
                  splashRadius: 22.2,
                  onPressed: () {
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
                  },
                  icon: Icon(
                    Icons.add,
                    size: 33,
                  )),
              label: 'Add Task',
              onPressed: () {},
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
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.indigo[900], Colors.indigo]),
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
                                isBgGradientInverted: true,
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
