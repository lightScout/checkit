import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/widgets/no_name_alert.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textFieldController = TextEditingController();
    String newCategoryTitle;

    return ValueListenableBuilder(
        valueListenable: Hive.box('categories').listenable(),
        builder: (context, box, widget) {
          print(box.keys);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            //*
            //* SCREEN MAIN CONTAINER
            //*
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      KMainRed,
                      KMainOrange,
                    ]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                            ),

                            //!
                            //! COMPONENTS SECTION
                            //!

                            Container(
                              //
                              child: Padding(
                                padding: const EdgeInsets.all(22.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    //*
                                    //*FIRST: INFO TEXT
                                    //*
                                    Text(
                                      'Create a catgory to organize your tasks:',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: KMainFontFamily,
                                          fontSize: 14,
                                          color: Colors.blue[50]),
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    //*
                                    //*SECOND: TEXTFEILD 'ADD CATEGORY HERE'
                                    //*
                                    TextField(
                                      controller: textFieldController,
                                      style: Klogo.copyWith(
                                        fontSize: 18,
                                        color: Colors.white,
                                        shadows: [],
                                      ),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: 'Category name here',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[350],
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white24,
                                      ),
                                      autofocus: false,
                                      onChanged: (value) {
                                        newCategoryTitle = value;
                                        print(newCategoryTitle);
                                      },
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),

                                    //*
                                    //*SECOND: ADD CATEGORY BUTTON
                                    //*
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(90)),
                                          child: Container(
                                            height: 140,
                                            width: 140,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white60,
                                                  offset: Offset(
                                                      -10.0, -15.0), //(x,y)
                                                  blurRadius: 25.0,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: FloatingActionButton(
                                                  splashColor: KMainOrange,
                                                  backgroundColor: KMainOrange,
                                                  onPressed: () {
                                                    if (newCategoryTitle ==
                                                            null ||
                                                        newCategoryTitle
                                                                .trim() ==
                                                            '') {
                                                      noNameAlert(
                                                          context, 'Category');
                                                    } else {
                                                      //unfocusing the keyboard to avoid pixel overflow
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      //Add task to the list

                                                      Category newCategory =
                                                          Category(
                                                              name:
                                                                  newCategoryTitle);
                                                      Hive.box('categories')
                                                          .add(newCategory);
                                                      Flushbar(
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              messageText: Text(
                                                                'Task added successfuly.',
                                                                style: Klogo.copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                    shadows: [],
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              flushbarStyle:
                                                                  FlushbarStyle
                                                                      .FLOATING)
                                                          .show(context);
                                                      textFieldController
                                                          .clear();
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.fingerprint,
                                                    size: 60,
                                                    color: Colors.white38,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                ],
              ),
            ),
          );
        });
  }
}
