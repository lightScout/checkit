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
                  textAlign: TextAlign.start,
                  textScaleFactor: 1.11,
                  style: Klogo.copyWith(
                    fontSize: 16,
                    shadows: [
                      // Shadow(
                      //   blurRadius: 2.0,
                      //   color: Colors.blue,
                      //   offset: Offset(-5.55, -4.44),
                      // ),
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.red,
                        offset: Offset(5.55, 4.44),
                      ),
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(-3.3, -3.3),
                      ),
                      Shadow(
                        color: Colors.white,
                        blurRadius: 2.2,
                        offset: Offset(0.6, 0.6),
                      )
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
                      color: Colors.yellow[50],
                      shadows: [
                        Shadow(
                          color: Colors.white,
                          blurRadius: 2.2,
                          offset: Offset(0.6, 0.6),
                        )
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
                        color: Colors.pink[50].withOpacity(.70),
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
