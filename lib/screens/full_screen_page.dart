import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/others/constants.dart';

import 'package:ciao_app/widgets/list_builder.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:animations/animations.dart';
import 'add_task_screen2.dart';

class FullScreenPage extends StatefulWidget {
  final String category;

  const FullScreenPage({this.category});

  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  bool wasAllTaskToggled = false;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isPageMinimized = false;
  double topBorderRadius = 0;

  @override
  Widget build(BuildContext context) {
    String category = widget.category;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        heroTag: 'FULLSCREENPAGEFAB',
        backgroundColor: Color(0xFF071F86),
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
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.category,
          style: TextStyle(
            fontFamily: KMainFontFamily,
            fontSize: 14,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFF071F86),
                  child: InkWell(
                    onTap: () {
                      _toggleAllTask();
                    },
                    child: Icon(Icons.delete_forever),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  radius: 60,
                  backgroundColor:
                      wasAllTaskToggled ? Colors.blue[800] : Colors.red,
                  child: InkWell(
                    onTap: () {
                      _toggleAllTask();
                    },
                    child: Icon(Icons.done_all),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      //* STACK
      body: Stack(
        children: [
          AddTaskScreen2(
            category: category,
          ),
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
                            color: Colors.white12,
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
                                listCategory: category,
                                tasksBox: Hive.box('tasks'),
                                isBgGradientInverted: true,
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
