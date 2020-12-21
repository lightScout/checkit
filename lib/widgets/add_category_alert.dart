import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

Future addCategoryAlert(BuildContext context) {
  String newTaskCategory;
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        backgroundColor: Colors.red[800].withOpacity(0.75),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            // 'New Category' alert title
            //
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 14.0, bottom: 0, left: 14.0, right: 14.0),
                child: Text(
                  "New Category",
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
            ),
          ],
        ),
        actions: <Widget>[
          Column(
            children: [
              Container(
                height: 80,
                width: 300,
                child: TextField(
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: Klogo.copyWith(
                      fontSize: 22,
                      color: Colors.white,
                      shadows: [
                        // Shadow(
                        //   color: Colors.greenAccent,
                        //   blurRadius: 6.0,
                        //   offset: Offset(0.6, 0.6),
                        // )
                      ]),
                  decoration: InputDecoration(
                    border: KInputFieldRoundedCorners,
                    filled: true,
                    fillColor: Colors.black,
                  ),
                  autofocus: true,
                  onChanged: (value) {
                    newTaskCategory = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: Material(
                    color: Color(0xFFDD0426),
                    elevation: 1,
                    child: GestureDetector(
                      child: Icon(
                        Icons.add,
                        size: 50,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Category newCategory = Category(name: newTaskCategory);
                        Hive.box('categories').add(newCategory);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}
