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
  int itemCount = 0;

  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//
  Future<void> _loadItems() async {
    dataFromBox.clear();
    itemList.clear();
    var future = Future(() {});
    if (widget.taskList != null) {
      dataFromBox = widget.taskList;
    } else {
      List listOfTaksKeys = widget.tasksBox.keys.toList();
      listOfTaksKeys.forEach(
        (element) async {
          Task task = widget.tasksBox.get(element) as Task;
          task.key = element;

          if (task.category == widget.listCategory) {
            dataFromBox.insert(0, task);
          }
        },
      );
      if (dataFromBox.isNotEmpty) {
        for (var i = 0; i < dataFromBox.length; i++) {
          future = future.then((_) {
            return Future.delayed(Duration(milliseconds: 100), () {
              itemList.insert(i, dataFromBox[i]);
              if (_listKey.currentState != null) {
                _listKey.currentState
                    .insertItem(i, duration: const Duration(milliseconds: 300));
              }
            });
          });
        }
      }
      itemCount = widget.tasksBox.length;
    }
  }

  Future<void> _stateCheck() async {
    int boxSize = widget.tasksBox.length;
    if (itemCount > boxSize) {
      _loadItems();
    }
    if (widget.tasksBox.isEmpty) {
      itemCount = 0;
    }

    if (itemCount < boxSize) {
      int lastKey = widget.tasksBox.keys.last;
      Task task = widget.tasksBox.get(lastKey) as Task;
      task.key = lastKey;
      if (task.category == widget.listCategory) {
        itemList.insert(0, task);
        if (_listKey.currentState != null) {
          _listKey.currentState
              .insertItem(0, duration: const Duration(milliseconds: 600));
        }
      }

      itemCount = boxSize;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    _stateCheck();
    return AnimatedList(
      key: _listKey,
      scrollDirection: Axis.vertical,
      controller: widget.hideButtonController,
      shrinkWrap: true,
      itemBuilder: (context, index, animation) {
        if (itemList.isNotEmpty && index <= itemList.length - 1) {
          final task = itemList[index];

          return _buildItem(context, task, animation, itemList, _listKey, index,
              widget.isBgGradientInverted);
        } else
          //* Animated List needs to received null when the list becomes empty
          return null;
      },
      initialItemCount: itemList.length,
    );
  }
}

//* list item builder
Widget _buildItem(
  BuildContext context,
  Task item,
  animation,
  List<Task> itemList,
  GlobalKey<AnimatedListState> listKey,
  int index,
  bool isBgInverted,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset(0, 0),
    ).animate(animation),
    child: TaskTile(
      title: item.name,
      category: item.category,
      dueDate: item.dueDateTime,
      isChecked: item.isDone,
      isCheckCallBack: () {
        item.toggleDone();
        return Hive.box('tasks').put(item.key, item);
      },
      deleteTask: () {
        Hive.box('tasks').delete(item.key);
        itemList.remove(item);

        listKey.currentState.removeItem(
            index,
            (_, animation) => _deletedItem(context, item, animation, itemList,
                listKey, index, isBgInverted),
            duration: Duration(milliseconds: 600));
      },
      isBgGradientInverted: isBgInverted,
    ),
  );
}

//* list deleted item builder
Widget _deletedItem(
  BuildContext context,
  Task item,
  animation,
  List<Task> itemList,
  GlobalKey<AnimatedListState> listKey,
  int index,
  bool isBgInverted,
) {
  return FadeTransition(
    opacity: animation,
    child: TaskTile(
      title: item.name,
      category: item.category,
      dueDate: item.dueDateTime,
      isChecked: item.isDone,
      isBgGradientInverted: isBgInverted,
    ),
  );
}
