import 'package:ciao_app/model/task.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'task_tile.dart';

class ListBuilder extends StatelessWidget {
  final Box tasksBox;
  final listCategory;
  final Color dismissibleBackGroundColor1 = Color(0xFFF9B16E);
  final Color dismissibleBackGroundColor2 = Color(0xFFF68080);
  final ScrollController hideButtonController;

  ListBuilder({this.tasksBox, this.listCategory, this.hideButtonController});

  @override
  Widget build(BuildContext context) {
    List<Task> listOfTask = [];
    List listOfTaksKeys = tasksBox.keys.toList();
    // print(listOfKeys);

    listOfTaksKeys.forEach((element) {
      Task task = tasksBox.get(element) as Task;
      task.key = element;
      print(task.key);
      if (task.category == listCategory) {
        listOfTask.add(task);
      }
    });

    return ListView.separated(
      scrollDirection: Axis.vertical,
      controller: hideButtonController,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // print(box.keys);
        // print(box.keys.toList()[index]);
        final task = listOfTask[index];
        print(task.category);
        return Dismissible(
          background: DismissibleBackGround(
            color1: dismissibleBackGroundColor1,
            color2: dismissibleBackGroundColor2,
          ),
          secondaryBackground: Container(
            color: Colors.transparent,
          ),
          dismissThresholds: {DismissDirection.endToStart: 1.0},
          onDismissed: (DismissDirection direction) {
            tasksBox.delete(task.key);
            // listOfTask.remove(task);
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
              return tasksBox.put(task.key, task);
            },
            deleteTask: () {
              tasksBox.delete(key);
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 16,
        );
      },
      itemCount: listOfTask.length,
    );
  }
}

class DismissibleBackGround extends StatelessWidget {
  final Color color1;
  final Color color2;

  DismissibleBackGround({this.color1, this.color2});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [color1, color2]),
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
    );
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
