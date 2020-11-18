import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  String name;
  @HiveField(1)
  String category;
  @HiveField(2)
  String dueDate;
  @HiveField(3)
  bool isDone;
  @HiveField(4)
  int key;

  Task({this.name, this.isDone = false, this.category, this.dueDate, this.key});

  bool toggleDone() {
    isDone = !isDone;
    bool result = isDone;
    return result;
  }
}
