import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';

// database table and column names
final String tableTasks = 'tasks';
final String columnId = '_id';
final String columnTaskTitle = 'taskTitle';
final String columnCategory = 'category';
final String columnDueDate = 'dueDate';
final String columnIsDone = 'isDone';
//final String columnFrequency = 'frequency';

// data model class
class TaskDB {
  String name;
  String category;
  String dueDate;
  int isDone;
  int id;
  TaskDB({this.id, this.name, this.category, this.dueDate, this.isDone});

  factory TaskDB.fromMap(Map<String, dynamic> json) => TaskDB(
        id: json[columnId],
        name: json[columnTaskTitle],
        category: json[columnCategory],
        dueDate: json[columnDueDate],
        isDone: json[columnIsDone],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTaskTitle: name,
      columnCategory: category,
      columnDueDate: dueDate,
      columnIsDone: isDone,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  int toggleDone() {
    if (isDone == 0) {
      isDone = 1;
    } else {
      isDone = 0;
    }
    int result = isDone;
    return result;
  }

  // TaskDB.fromJson(Map<String, dynamic> json)
  //     : id = json[columnId],
  //       name = json[columnTaskTitle],
  //       category = json[columnCategory],
  //       dueDate = json[columnDueDate],
  //       isDone = json[columnIsDone];

  // convenience constructor to create a Task object
  // TaskDB.fromMap(Map<String, dynamic> map) {}

  // convenience method to create a Map from this Task object
  // Map<String, dynamic> toJson() => {
  //       columnId: id,
  //       columnTaskTitle: name,
  //       columnCategory: category,
  //       columnDueDate: dueDate,
  //       columnIsDone: isDone,
  //     };

}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableTasks (
                $columnId INTEGER PRIMARY KEY,
                $columnTaskTitle TEXT NOT NULL,
                $columnCategory TEXT NOT NULL,
                $columnDueDate TEXT NOT NULL,
                $columnIsDone INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:

  newTask(TaskDB newTask) async {
    final dbConnection = await database;
    var res = await dbConnection.insert(
      tableTasks,
      newTask.toMap(),
    );
    return res;
  }

  deleteTask(int id) async {
    final db = await database;
    db.delete("$tableTasks", where: "_id = ?", whereArgs: [id]);
  }

  count() async {
    Database dbConnection = await database;
    var x = await dbConnection.rawQuery('SELECT COUNT (*) from $tableTasks');
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  getAllTasks() async {
    final dbConnection = await database;
    var res = await dbConnection.rawQuery('SELECT * from $tableTasks');
    List<TaskDB> list =
        res.isNotEmpty ? res.map((c) => TaskDB.fromMap(c)).toList() : [];
    print(list);
    return list;
  }

  Future<TaskDB> queryTask(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableTasks,
        columns: [columnId, columnTaskTitle, columnCategory, columnDueDate],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return TaskDB.fromMap(maps.first);
    }
    return null;
  }

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}
