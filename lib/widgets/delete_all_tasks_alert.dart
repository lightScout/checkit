import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

void deleteCategoryAlert(
    BuildContext context, Function function, String category) {
  void _deleteAllTask() {
    List listOfKeys = Hive.box('tasks').keys.toList();

    listOfKeys.forEach((element) {
      if ((Hive.box('tasks').get(element) as Task).category == category) {
        Hive.box('tasks').delete(element);
      }
    });
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(32.0),
          ),
        ),
        backgroundColor: Colors.red[800].withOpacity(0.75),
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Attetion!",
            textAlign: TextAlign.center,
            style: KAlertTextStyleTitle,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Are you sure you want to delete all tasks under this category?",
            style: KAlertTextStyleInfoText.copyWith(
              color: Colors.yellowAccent[700],
            ),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  heroTag: 'deleteCategoryFAB1',
                  splashColor: Colors.blue,
                  backgroundColor: Colors.white38,
                  onPressed: () {
                    function();
                    _deleteAllTask();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Yes',
                    style: KAlertTextStyleInfoText,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                FloatingActionButton(
                  heroTag: 'deleteCategoryFAB2',
                  splashColor: Colors.blue,
                  backgroundColor: Colors.white38,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: KAlertTextStyleInfoText,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
