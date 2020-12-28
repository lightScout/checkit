import 'package:animate_icons/animate_icons.dart';
import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/widgets/no_name_alert.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ciao_app/widgets/custom_cliprrect.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key key}) : super(key: key);

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen>
    with TickerProviderStateMixin {
  //* ANIMATION VARIALBES AND CONTROLLER

  AnimateIconController _animateIconController;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double topBorderRadius = 0;
  bool newTaskScreenToggle = false;

  //* TEXT FIELD CONTROLLER
  final textFieldController = TextEditingController();

  //* String to hold the new category title
  String newCategoryTitle;
  //* INIT
  @override
  void initState() {
    super.initState();
    _animateIconController = AnimateIconController();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.ease,
      transform: Matrix4.translationValues(
        xOffset,
        yOffset,
        0,
      )..scale(scaleFactor),
      duration: Duration(milliseconds: 600),
      child: ValueListenableBuilder(
          valueListenable: Hive.box('categories').listenable(),
          builder: (context, box, widget) {
            print(box.keys);
            return Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              //*
              //* SCREEN MAIN CONTAINER
              //*
              body: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(topBorderRadius),
                    topRight: Radius.circular(topBorderRadius),
                  ),
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
                    //*
                    //* NAVEGATION BUTTON & SCREEN TITLE
                    //*
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 48,
                          bottom: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 22,
                                right: 22,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //*
                                  //* NAVEGATION BUTTON
                                  //*
                                  customClipRRect(
                                    colors: (Hive.box('categories').isEmpty)
                                        ? [Colors.grey[600], Colors.transparent]
                                        : [KMainRed, Colors.orange],
                                    child: AnimateIcons(
                                      controller: _animateIconController,
                                      startIcon:
                                          Icons.keyboard_arrow_down_rounded,
                                      startTooltip: 'Icons.add',
                                      endTooltip: 'Icons.close',
                                      endIcon: Icons.keyboard_arrow_up_rounded,
                                      color: Color(0xFF071F86),
                                      size: 41,
                                      onStartIconPress: () {
                                        setState(() {
                                          topBorderRadius = 50;
                                          yOffset = MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1.5;
                                          newTaskScreenToggle = true;
                                        });
                                        return true;
                                      },
                                      onEndIconPress: () {
                                        setState(() {
                                          topBorderRadius = 0;
                                          yOffset = 0;
                                          newTaskScreenToggle = false;
                                        });
                                        return true;
                                      },
                                    ),
                                  ),
                                  //*
                                  //* SCREEN TITLE
                                  //*
                                  Text(
                                    'Add category',
                                    style: Klogo.copyWith(
                                      fontSize: 19,
                                      shadows: [
                                        Shadow(
                                          color: Colors.red,
                                          blurRadius: 1,
                                          offset: Offset(5.0, 5.0),
                                        )
                                      ],
                                      color: Colors.blue[50],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //*
                    //* INFO TEXT, TEXT FEILD AND ADD BUTTON COLLUMN
                    //*
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                  hintText:
                                                      'Category name here',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey[350],
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(25),
                                                    ),
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 1.0),
                                                    borderRadius:
                                                        BorderRadius.all(
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
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                90)),
                                                    child: Container(
                                                      height: 140,
                                                      width: 140,
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.white60,
                                                            offset: Offset(
                                                                -10.0,
                                                                -15.0), //(x,y)
                                                            blurRadius: 25.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                            FloatingActionButton(
                                                                splashColor:
                                                                    KMainOrange,
                                                                backgroundColor:
                                                                    KMainOrange,
                                                                onPressed: () {
                                                                  //! checking to see if category title is null or blank
                                                                  if (newCategoryTitle ==
                                                                          null ||
                                                                      newCategoryTitle
                                                                              .trim() ==
                                                                          '') {
                                                                    noNameAlert(
                                                                        context,
                                                                        'Category');
                                                                  } else {
                                                                    //! Unfocusing the keyboard
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();

                                                                    //! Adding new category to categoriesBox

                                                                    Category
                                                                        newCategory =
                                                                        Category(
                                                                            name:
                                                                                newCategoryTitle);
                                                                    Hive.box(
                                                                            'categories')
                                                                        .add(
                                                                            newCategory);
                                                                    //! bottom bar event anuncing successful addtiong of new category
                                                                    Flushbar(
                                                                            duration:
                                                                                Duration(seconds: 1),
                                                                            messageText: Text(
                                                                              'Category added successfuly.',
                                                                              style: Klogo.copyWith(color: Colors.white, shadows: [], fontSize: 14),
                                                                            ),
                                                                            flushbarStyle: FlushbarStyle.FLOATING)
                                                                        .show(context);
                                                                    textFieldController
                                                                        .clear();
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .fingerprint,
                                                                  size: 60,
                                                                  color: Colors
                                                                      .white38,
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
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
