class Task {
  String name;
  String category;
  String dueDate;
  bool isDone;

  Task({this.name, this.isDone = false, this.category, this.dueDate});

  bool toggleDone() {
    isDone = !isDone;
    bool result = isDone;
    return result;
  }
}
