import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

void noCategoriesAvailableDialog(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
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
            style: Klogo.copyWith(
              fontSize: 18,
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
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "A category is necessery in order to create a new task. Would you like to have a 'General' category created for you?",
            style: Klogo.copyWith(
              fontSize: 18,
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.red,
                  offset: Offset(5.0, 5.0),
                ),
              ],
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
                  heroTag: 'NoCategoryFAB1',
                  splashColor: Colors.blue,
                  backgroundColor: Colors.white38,
                  onPressed: () {
                    Category newCategory = Category(name: 'General');
                    Hive.box('categories').add(newCategory);

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Yes',
                    style: Klogo.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          offset: Offset(5, 5),
                          color: Colors.red[700],
                          blurRadius: 1,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                FloatingActionButton(
                  heroTag: 'NoCategoryFAB2',
                  splashColor: Colors.blue,
                  backgroundColor: Colors.white38,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: Klogo.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          offset: Offset(5, 5),
                          color: Colors.red[700],
                          blurRadius: 1,
                        )
                      ],
                    ),
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
