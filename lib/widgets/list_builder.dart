import 'package:ciao_app/model/database_helpers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ciao_app/model/task_data.dart';
import 'must_do_tile.dart';
import 'task_tile.dart';
import 'package:ciao_app/model/task.dart';

class ListBuilder extends StatelessWidget {
  final String listCategory;
  ListBuilder({this.listCategory});
  @override
  Widget build(BuildContext context) {
    // final tasksBox = Hive.box('tasks');
    return WatchBoxBuilder(
        box: Hive.box('tasks'),
        builder: (context, tasksBox) {
          return SingleChildScrollView(
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              controller: ScrollController(keepScrollOffset: true),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print(tasksBox.keys);
                print(tasksBox.keys.toList()[index]);
                final task =
                    tasksBox.get(tasksBox.keys.toList()[index]) as Task;
                return Dismissible(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Color(0xFFF9B16E), Color(0xFFF68080)]),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Center(
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.transparent,
                  ),
                  dismissThresholds: {DismissDirection.endToStart: 1.0},
                  onDismissed: (DismissDirection direction) {
                    tasksBox.deleteAt(index);
                  },
                  key: Key('${task.name}${index.toString()}'),
                  direction: DismissDirection.horizontal,
                  child: TaskTile(
                    title: task.name,
                    category: task.category,
                    dueDate: task.dueDate,
                    isChecked: task.isDone,
                    isCheckCallBack: () {
                      task.toggleDone();
                      return tasksBox.putAt(index, task);
                    },
                    deleteTask: () {
                      tasksBox.deleteAt(index);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 16,
                );
              },
              itemCount: tasksBox.length,
            ),
          );
        });
  }
}

// PageView.builder(
// physics: ScrollPhysics(),
// controller: PageController(viewportFraction: 0.8),
// scrollDirection: Axis.horizontal,
// pageSnapping: true,
// itemBuilder: (context, index) {
// final task = taskData.tasksList(listCategory)[index];
// return MustDoTaskTile(
// title: task.name,
// isChecked: task.isDone,
// isCheckCallBack: () {
// taskData.updateTask(task);
// print(task.isDone);
// },
// deleteTask: () {
// taskData.deleteTask(listCategory, task);
// },
// );
// },
// itemCount: taskData.taskCount(listCategory),
// );
