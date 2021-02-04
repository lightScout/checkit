import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

void deleteTaskUnderCategory(int categoryKey) {
  Category category = Hive.box('categories').get(categoryKey) as Category;
  List listOfTaksKeys = Hive.box('tasks').keys.toList();
  listOfTaksKeys.forEach((element) {
    if (category.name == (Hive.box('tasks').get(element) as Task).category) {
      //print((tasksBox.get(element) as Task).category);
      Hive.box('tasks').delete(element);
    }
  });
  Hive.box('categories').delete(categoryKey);
}

void deleteCategoryAlert(BuildContext context, int categoryKey) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    animType: AnimType.LEFTSLIDE,
    btnOkOnPress: () {
      deleteTaskUnderCategory(categoryKey);
    },
    btnOkColor: KMainOrange,
    btnCancelOnPress: () =>
        Navigator.of(context).popUntil((route) => route.isCurrent),
    headerAnimationLoop: false,
    body: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              'Are you sure you want to delete this category?',
              textAlign: TextAlign.center,
              style: Klogo.copyWith(
                fontFamily: KTextFontFamily,
                fontSize: 22,
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.red,
                    offset: Offset(5.0, 5.0),
                  ),
                ],
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
    dialogBackgroundColor: Colors.red[800].withOpacity(0.75),
  )..show();
}
