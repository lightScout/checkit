import 'package:ciao_app/model/task.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'task_tile.dart';

class SimpleListBuilder extends StatelessWidget {
  final Box tasksBox;
  //* if true, textile bg gradiente will be inverted to toggle task state
  final bool isBgGradientInverted;
  final listCategory;
  final Color dismissibleBackGroundColor1 = Color(0xFFF9B16E);
  final Color dismissibleBackGroundColor2 = Color(0xFFF68080);
  final ScrollController hideButtonController;
  final List<Task> taskList;

  SimpleListBuilder(
      {this.tasksBox,
      this.listCategory,
      this.hideButtonController,
      this.isBgGradientInverted = false,
      this.taskList});

  @override
  Widget build(BuildContext context) {
    List<Task> listOfTasks = [];

    // print(listOfKeys);

    if (taskList != null) {
      listOfTasks = taskList;
    } else {
      List listOfTaksKeys = tasksBox.keys.toList();
      listOfTaksKeys.forEach((element) {
        Task task = tasksBox.get(element) as Task;
        task.key = element;
        //print(task.key);
        if (task.category == listCategory) {
          listOfTasks.insert(0, task);
        }
      });
    }

    return ListView.separated(
      scrollDirection: Axis.vertical,
      controller: hideButtonController,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // print(box.keys);
        // print(box.keys.toList()[index]);
        final task = listOfTasks[index];
        // print(task.category);
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
            if (taskList != null) {
              listOfTasks.remove(task);
            }
          },
          key: Key('${task.name}${index.toString()}'),
          direction: DismissDirection.horizontal,
          child: TaskTile(
            title: task.name,
            category: task.category,
            dueDate: task.dueDateTime,
            isChecked: task.isDone,
            isCheckCallBack: () {
              task.toggleDone();
              return tasksBox.put(task.key, task);
            },
            deleteTask: () {
              if (taskList != null) {
                listOfTasks.remove(task);
              }
              tasksBox.delete(task.key);
            },
            isBgGradientInverted: isBgGradientInverted,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 16,
        );
      },
      itemCount: listOfTasks.length,
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
