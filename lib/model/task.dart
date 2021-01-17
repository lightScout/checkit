import 'package:hive/hive.dart';
import 'package:vibration/vibration.dart';

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
  @HiveField(5)
  DateTime dueDateTime;

  Task(
      {this.name,
      this.isDone = false,
      this.category,
      this.dueDate,
      this.dueDateTime,
      this.key});

  Future<bool> toggleDone() async {
    isDone = !isDone;
    bool result = isDone;
    if (await Vibration.hasVibrator()) {
      if (await Vibration.hasAmplitudeControl()) {
        Vibration.vibrate(amplitude: 128);
      } else {
        Vibration.vibrate();
      }
    }
    return result;
  }
}
