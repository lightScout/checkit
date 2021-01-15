import 'package:animate_icons/animate_icons.dart';
import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/model/flags.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/widgets/no_category_alert.dart';
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
  bool isPageClosed = false;

  //* TEXT FIELD CONTROLLER
  final textFieldController = TextEditingController();
  //* String to hold the new category title
  String newCategoryTitle;
  Box categoriesBox = Hive.box('categories');
  void stateCheck() {
    //*add category case
    if (categoriesBox.isEmpty && isPageClosed) {
      yOffset = 0;
      topBorderRadius = 0;
      isPageClosed = false;
      if (_animateIconController.isEnd()) {
        _animateIconController.animateToStart();
      }
    }
    //* add task case
    if (!isPageClosed &&
        categoriesBox.isNotEmpty &&
        (((Hive.box('flags').getAt(0)) as Flags).value &&
            Hive.box('flags').getAt(0) != null)) {
      yOffset = MediaQuery.of(context).size.height / 1.5;
      topBorderRadius = 50;
      isPageClosed = true;
      Hive.box('flags')
          .putAt(0, Flags(name: 'toggleAddCategoryScreen', value: false));

      if (_animateIconController.isStart()) {
        _animateIconController.animateToEnd();
      }
    }
  }

  //* INIT
  @override
  void initState() {
    super.initState();
    _animateIconController = AnimateIconController();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('flags').listenable(),
        builder: (context, box, widget) {
          return ValueListenableBuilder(
              valueListenable: Hive.box('categories').listenable(),
              builder: (context, box, widget) {
                stateCheck();
                return AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  transform: Matrix4.translationValues(
                    0,
                    yOffset,
                    0,
                  )..scale(scaleFactor),
                  duration: Duration(milliseconds: 600),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    resizeToAvoidBottomInset: false,
                    //*
                    //* SCREEN MAIN CONTAINER
                    //*
                    body: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/textures/add_category_screen_texture3.png'),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: categoriesBox.isEmpty
                              ? Radius.circular(0)
                              : Radius.circular(topBorderRadius),
                          topRight: categoriesBox.isEmpty
                              ? Radius.circular(0)
                              : Radius.circular(topBorderRadius),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            KMainRed,
                            KMainOrange,
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white54,
                          width: 10,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.limeAccent[100],
                            offset: Offset(0.0, -4.0), //(x,y)
                            blurRadius: 10.1,
                          ),
                          BoxShadow(
                            color: Colors.yellow[900],
                            offset: Offset(0.0, -2.0), //(x,y)
                            blurRadius: 5.1,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //*
                          //* NAVEGATION BUTTON & SCREEN TITLE
                          //*
                          Container(
                            width: MediaQuery.of(context).size.width * .95,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 28,
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
                                          colors: [KMainRed, Colors.orange],
                                          child: AnimateIcons(
                                            controller: _animateIconController,
                                            startIcon: Icons
                                                .keyboard_arrow_down_rounded,
                                            startTooltip: 'Icons.add',
                                            endTooltip: 'Icons.close',
                                            endIcon:
                                                Icons.keyboard_arrow_up_rounded,
                                            color: Colors.blueAccent[700],
                                            size: 21,
                                            onStartIconPress: () {
                                              if (categoriesBox.isEmpty) {
                                                Category newCategory =
                                                    Category(name: 'General');
                                                Hive.box('categories')
                                                    .add(newCategory);
                                              }
                                              setState(() {
                                                topBorderRadius = 50;
                                                yOffset = MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.5;
                                                isPageClosed = true;
                                              });
                                              return true;
                                            },
                                            onEndIconPress: () {
                                              setState(() {
                                                topBorderRadius = 0;
                                                yOffset = 0;
                                                isPageClosed = false;
                                                Hive.box('flags').putAt(
                                                    0,
                                                    Flags(
                                                        name:
                                                            'toggleAddCategoryScreen',
                                                        value: false));
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
                                            fontSize: 33,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                padding:
                                                    const EdgeInsets.all(22.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    //*
                                                    //*FIRST: INFO TEXT
                                                    //*
                                                    Text(
                                                      'Create catgory to organize tasks:',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              KMainFontFamily,
                                                          fontSize: 20,
                                                          color:
                                                              Colors.blue[50]),
                                                    ),
                                                    SizedBox(
                                                      height: 33,
                                                    ),
                                                    //*
                                                    //*SECOND: TEXTFEILD 'ADD CATEGORY HERE'
                                                    //*
                                                    TextField(
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .sentences,
                                                      controller:
                                                          textFieldController,
                                                      style: Klogo.copyWith(
                                                        fontSize: 22,
                                                        color: Colors.white,
                                                        shadows: [],
                                                      ),
                                                      maxLines: 1,
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Category name here',
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[350],
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(25),
                                                          ),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 1.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 1.0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(25),
                                                          ),
                                                        ),
                                                        filled: true,
                                                        fillColor:
                                                            Colors.white24,
                                                      ),
                                                      autofocus: false,
                                                      onChanged: (value) {
                                                        newCategoryTitle =
                                                            value;
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 40,
                                                    ),

                                                    //*
                                                    //*THIRD: ADD CATEGORY BUTTON
                                                    //*
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          90)),
                                                          child: Container(
                                                            height: 140,
                                                            width: 140,
                                                            decoration:
                                                                BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .white60,
                                                                  offset: Offset(
                                                                      -10.0,
                                                                      -15.0), //(x,y)
                                                                  blurRadius:
                                                                      25.0,
                                                                ),
                                                              ],
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  FloatingActionButton(
                                                                      heroTag:
                                                                          'ADDCATEGORYSCREEN-FAB',
                                                                      splashColor:
                                                                          KMainOrange,
                                                                      backgroundColor:
                                                                          KMainOrange,
                                                                      onPressed:
                                                                          () {
                                                                        //! checking to see if category title is null or blank
                                                                        if (newCategoryTitle ==
                                                                                null ||
                                                                            newCategoryTitle.trim() ==
                                                                                '') {
                                                                          noNameAlert(
                                                                              context,
                                                                              'Category');
                                                                        } else {
                                                                          //! Adding new category to categoriesBox

                                                                          Category
                                                                              newCategory =
                                                                              Category(name: newCategoryTitle);
                                                                          Hive.box('categories')
                                                                              .add(newCategory);

                                                                          //! bottom bar event anuncing successful addtiong of new category
                                                                          Flushbar(
                                                                                  duration: Duration(seconds: 2),
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
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .fingerprint,
                                                                        size:
                                                                            60,
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
                  ),
                );
              });
        });
  }
}
