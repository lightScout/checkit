import 'package:ciao_app/model/database_helpers.dart';
import 'package:flutter/material.dart';
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
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return SingleChildScrollView(
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            controller: ScrollController(keepScrollOffset: true),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              taskData.generateTaskList();
              final task = taskData.tasksList(listCategory)[index];
              return Dismissible(
                key: Key('${task.name}${index.toString()}'),
                direction: DismissDirection.horizontal,
                child: TaskTile(
                  title: task.name,
                  category: task.category,
                  dueDate: task.dueDate,
                  isChecked: task.isDone,
                  isCheckCallBack: () {
                    taskData.updateTask(task);
                    print(task.isDone);
                  },
                  deleteTask: () {
                    taskData.deleteTask(task);
                  },
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 16,
              );
            },
            itemCount: taskData.taskCount(listCategory),
          ),
        );
      },
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
