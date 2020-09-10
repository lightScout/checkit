import 'package:flutter/foundation.dart';
import 'task.dart';
import 'dart:collection';
import 'database_helpers.dart';

class TaskData extends ChangeNotifier {
  List<TaskDB> _tasksListMain = [];

  List<Task> _tasksListDream = [];

  List<Task> _tasksListMustDo = [];

  bool _isDreamTaskCategoryOn = false;

  int _taskCounter = 0;
  int _taskOverallCounter = 0;

  void addTaskToDataBase(int id) {
    addTaskToDB(
        taskId: id, title: 'a', category: 'Main', dueDate: '2020', isDone: 0);
    notifyListeners();
  }

  bool isDreamTaskCategory() {
    return _isDreamTaskCategoryOn;
  }

  void toggleDreamTaskCategory() {
    _isDreamTaskCategoryOn = !_isDreamTaskCategoryOn;
    notifyListeners();
  }

  //Return a List<Task> according to the category
  UnmodifiableListView<TaskDB> tasksList(String category) {
    UnmodifiableListView<TaskDB> list;

    if (category == 'Main') {
      list = UnmodifiableListView(_tasksListMain);
    } else if (category == 'Dream') {
      list = UnmodifiableListView(_tasksListMain);
    } else if (category == 'MustDo') {
      list = UnmodifiableListView(_tasksListMain);
    }

    return list;
  }

  //safe way to tap into the list without being able to modify it.
  UnmodifiableListView<TaskDB> get tasksListMain {
    return UnmodifiableListView(_tasksListMain);
  }

  UnmodifiableListView<Task> get tasksListDream {
    return UnmodifiableListView(_tasksListDream);
  }

  UnmodifiableListView<Task> get tasksListMustDo {
    return UnmodifiableListView(_tasksListMustDo);
  }

  int taskCount(String category) {
    int size;

    if (category == 'Main') {
      size = _tasksListMain.length;
    } else if (category == 'Dream') {
      size = _tasksListDream.length;
    } else if (category == 'MustDo') {
      size = _tasksListMustDo.length;
    }

    return size;
  }

  ///
  ///
  /// Get's
  ///
  /// **/
  ///
  ///

  int get taskOverallCount {
    return _taskOverallCounter;
  }

  int get taskDoneCount {
    return _taskCounter;
  }

  int get taskCountMain {
    return _tasksListMain.length;
  }

  int get taskCountDream {
    return _tasksListDream.length;
  }

  int get taskCountMustDo {
    return _tasksListMustDo.length;
  }

  int get tasksCountAll {
    //not adding value coming from MustDo list just yet
    return (_tasksListDream.length + _tasksListMain.length);
  }

  bool get isEmpty {
    return taskCountMain == 0;
  }

  String taskCategory(Task task) {
    return task.category;
  }

  void generateTaskList() async {
    final dbHelper = DatabaseHelper.instance;
    List<TaskDB> list = await dbHelper.getAllTasks();
    _tasksListMain = list;
  }

  void addTaskToDB(
      {int taskId,
      String title,
      String category,
      String dueDate,
      int isDone}) async {
    final dbHelper = DatabaseHelper.instance;
    TaskDB task = TaskDB();
    task.id = taskId;
    task.name = title;
    task.category = category;
    task.dueDate = dueDate;
    task.isDone = isDone;
    int id = await dbHelper.newTask(task);
    print('inserted row $id');
    _taskOverallCounter++;
    addTask(task);
    notifyListeners();
  }

  void deleteTask(TaskDB task) async {
    await DatabaseHelper.instance.deleteTask(task.id);
    deleteTaskMain(task);
    notifyListeners();
  }

  void addTask(TaskDB task) {
    _tasksListMain.add(task);
    _taskCounter++;
    notifyListeners();
  }

  void updateTask(TaskDB task) {
    int a = task.toggleDone();
    if (a == 1) {
      _taskCounter--;
    } else {
      _taskCounter++;
    }
    notifyListeners();
  }

  void deleteTaskMain(TaskDB task) {
    _tasksListMain.remove(task);
    notifyListeners();
  }

  void deleteTaskDream(TaskDB task) {
    _tasksListDream.remove(task);
    notifyListeners();
  }

  void deleteTaskMustDo(TaskDB task) {
    _tasksListMustDo.remove(task);
    notifyListeners();
  }

  void deleteAllTasks() {
    _tasksListMain.clear();
    _tasksListDream.clear();
    _tasksListMustDo.clear();
    notifyListeners();
  }
}
