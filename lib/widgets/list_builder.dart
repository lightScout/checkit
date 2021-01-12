import 'package:ciao_app/model/task.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'task_tile.dart';

class ListBuilder extends StatefulWidget {
  final Box tasksBox;
  //* if true, textile bg gradiente will be inverted to toggle task state
  final bool isBgGradientInverted;
  final listCategory;
  final ScrollController hideButtonController;
  final List<Task> taskList;

  ListBuilder({
    this.tasksBox,
    this.listCategory,
    this.hideButtonController,
    this.isBgGradientInverted = false,
    this.taskList,
  });

  @override
  _ListBuilderState createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  final Color dismissibleBackGroundColor1 = Color(0xFFF9B16E);

  final Color dismissibleBackGroundColor2 = Color(0xFFF68080);
  List<Task> dataFromBox = [];
  List<Task> itemList = [];

  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//
  Future<void> _loadItems() async {
    dataFromBox.clear();
    var future = Future(() {});
    if (widget.taskList != null) {
      dataFromBox = widget.taskList;
    } else {
      List listOfTaksKeys = widget.tasksBox.keys.toList();
      listOfTaksKeys.forEach((element) async {
        Task task = widget.tasksBox.get(element) as Task;
        task.key = element;
        //print(task.key);
        if (task.category == widget.listCategory) {
          dataFromBox.insert(0, task);
        }
      });
      for (var i = 0; i < dataFromBox.length; i++) {
        future = future.then((_) {
          return Future.delayed(Duration(milliseconds: 100), () {
            itemList.insert(i, dataFromBox[i]);
            if (_listKey.currentState != null) {
              _listKey.currentState
                  .insertItem(i, duration: const Duration(milliseconds: 400));
            }
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    // print(listOfKeys);

    return AnimatedList(
      key: _listKey,
      scrollDirection: Axis.vertical,
      controller: widget.hideButtonController,
      shrinkWrap: true,
      itemBuilder: (context, index, animation) {
        final task = itemList[index];

        return _slideIt(
            context,
            TaskTile(
              title: task.name,
              category: task.category,
              dueDate: task.dueDateTime,
              isChecked: task.isDone,
              isCheckCallBack: () {
                task.toggleDone();
                return widget.tasksBox.put(task.key, task);
              },
              deleteTask: () {
                widget.tasksBox.delete(task.key);
                itemList.remove(task);
                AnimatedListRemovedItemBuilder builder = (context, animation) {
                  return _buildItem(animation);
                };
                _listKey.currentState.removeItem(index, builder);
              },
              isBgGradientInverted: widget.isBgGradientInverted,
            ),
            animation);
      },
      initialItemCount: itemList.length,
    );
  }
}

Widget _slideIt(BuildContext context, TaskTile item, animation) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset(0, 0),
    ).animate(animation),
    child: item,
  );
}

Widget _buildItem(Animation animation) {
  return SizeTransition(
    sizeFactor: animation,
    child: SizedBox(
      height: 0,
      width: 0,
    ),
  );
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
