import 'package:animate_icons/animate_icons.dart';

import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/model/flags.dart';
import 'package:ciao_app/model/theme_manager.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/widgets/info_alert.dart';

import 'package:ciao_app/widgets/no_name_alert.dart';
import 'package:ciao_app/widgets/title_bubble.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ciao_app/widgets/custom_cliprrect.dart';
import 'package:provider/provider.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key key}) : super(key: key);

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen>
    with TickerProviderStateMixin {
  //* ANIMATION VARIALBES AND CONTROLLER

  AnimateIconController _animateIconController;
  AnimationController _glowAnimationController;
  AnimationController _rotateAnimationController;
  AnimationController _scaleAnimationController;
  Animation _glowAnimation;

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double topBorderRadius = 0;
  bool isPageClosed = false;
  bool internalStateChange = false;

  //* TEXT FIELD CONTROLLER
  final textFieldController = TextEditingController();
  //* String to hold the new category title
  String newCategoryTitle;
  Box categoriesBox = Hive.box('categories');

  //* ToolTip

  void stateCheck() {
    //*add category case
    if (!isPageClosed &&
        (((Hive.box('flags').getAt(5)) as Flags).value &&
            Hive.box('flags').getAt(5) != null)) {
      Hive.box('flags')
          .putAt(5, Flags(name: 'openAddCategoryScreen', value: false));
    }
    if (isPageClosed &&
        (((Hive.box('flags').getAt(5)) as Flags).value &&
            Hive.box('flags').getAt(5) != null)) {
      yOffset = 0;
      topBorderRadius = 0;
      isPageClosed = false;
      Hive.box('flags')
          .putAt(5, Flags(name: 'openAddCategoryScreen', value: false));
      if (_animateIconController.isEnd()) {
        _animateIconController.animateToStart();
      }
    }
    //* add task case
    if (!isPageClosed &&
        categoriesBox.isNotEmpty &&
        (((Hive.box('flags').getAt(0)) as Flags).value &&
            Hive.box('flags').getAt(0) != null)) {
      yOffset = MediaQuery.of(context).size.height / 1.40;
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
    _animateIconController = AnimateIconController();
    _rotateAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scaleAnimationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _glowAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1750));
    _glowAnimation =
        Tween(begin: 1.0, end: 77.0).animate(_glowAnimationController)
          ..addListener(() {
            setState(() {});
          });

    _glowAnimationController.repeat(reverse: true);
    super.initState();
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
                    //* SCREEN MAIN Stack
                    //*
                    body: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: categoriesBox.isEmpty
                              ? Radius.circular(0)
                              : Radius.circular(topBorderRadius),
                          topRight: categoriesBox.isEmpty
                              ? Radius.circular(0)
                              : Radius.circular(topBorderRadius),
                        ),
                        gradient:
                            (Provider.of<ThemeNotifier>(context).getThemeMode ==
                                    'dark')
                                ? KBGGradientDark
                                : LinearGradient(
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
                      child: Stack(
                        children: [
                          //*BG Texture
                          ScaleTransition(
                            scale: CurvedAnimation(
                                parent: Tween(begin: 1.0, end: 0.0)
                                    .animate(_scaleAnimationController),
                                curve: Curves.easeInBack),
                            child: RotationTransition(
                              turns: Tween(begin: 0.0, end: 1.0)
                                  .animate(_rotateAnimationController),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/textures/add_category_screen_texture2.png'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //* Page Content
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //*
                                //* NAVEGATION BUTTON & SCREEN TITLE
                                //*
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .95,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 28,
                                      bottom: 20,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                colors: (Provider.of<
                                                                    ThemeNotifier>(
                                                                context)
                                                            .getThemeMode ==
                                                        'dark')
                                                    ? KButtonsBGGrandientColorsDark
                                                    : [KMainRed, Colors.orange],
                                                child: AnimateIcons(
                                                  controller:
                                                      _animateIconController,
                                                  startIcon: Icons
                                                      .keyboard_arrow_down_rounded,
                                                  startTooltip: 'Icons.add',
                                                  endTooltip: 'Icons.close',
                                                  endIcon: Icons
                                                      .keyboard_arrow_up_rounded,
                                                  color:
                                                      (Provider.of<ThemeNotifier>(
                                                                      context)
                                                                  .getThemeMode ==
                                                              'dark')
                                                          ? Colors.white
                                                          : Colors
                                                              .blueAccent[700],
                                                  size: 33,
                                                  onStartIconPress: () {
                                                    if (categoriesBox.isEmpty) {
                                                      Category newCategory =
                                                          Category(
                                                              name: 'General');
                                                      Hive.box('categories')
                                                          .add(newCategory);
                                                    }
                                                    setState(() {
                                                      topBorderRadius = 50;
                                                      yOffset =
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              1.40;
                                                      isPageClosed = true;
                                                      internalStateChange =
                                                          true;
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
                                              //* INFO BUTTON
                                              customClipRRect(
                                                colors: [
                                                  Colors.yellow[50]
                                                      .withOpacity(.5),
                                                  Colors.white12
                                                ],
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      infoAlert(
                                                          context,
                                                          'Create catgory to organize tasks',
                                                          'AddCategory');
                                                    },
                                                    child: Icon(
                                                        Icons
                                                            .error_outline_rounded,
                                                        color: Colors.white60),
                                                  ),
                                                ),
                                              ),
                                              //*
                                              //* SCREEN TITLE
                                              //*
                                              // TitleBubble(
                                              //   borderColor: Colors.orange,
                                              //   insideColor: Colors.white24,
                                              //   child: Text(
                                              //     'Add category',
                                              //     style: Klogo.copyWith(
                                              //       fontSize: 32,
                                              //       shadows: [
                                              //         Shadow(
                                              //           color: Colors.red,
                                              //           blurRadius: 1,
                                              //           offset:
                                              //               Offset(5.0, 5.0),
                                              //         )
                                              //       ],
                                              //       color: Colors.blue[50],
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //*
                                //* TEXT FEILD AND ADD BUTTON
                                //*

                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 28,
                                      ),

                                      //*                              <--- FIRST: TEXTFEILD 'ADD CATEGORY HERE'
                                      TextField(
                                        cursorColor: Colors.white,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        controller: textFieldController,
                                        style: Klogo.copyWith(
                                          fontSize: 22,
                                          fontFamily: 'DMSerifTextRegular',
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
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          filled: false,
                                          fillColor: Colors.white24,
                                        ),
                                        autofocus: false,
                                        onChanged: (value) {
                                          newCategoryTitle = value;
                                        },
                                      ),

                                      //*
                                      //*SECOND: ADD CATEGORY BUTTON
                                      //*
                                      SizedBox(
                                        height: 130,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 140,
                                            width: 140,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white60,
                                                  offset: Offset(0, 0), //(x,y)
                                                  blurRadius: .5,
                                                ),
                                                BoxShadow(
                                                  color: Colors.orange[300]
                                                      .withOpacity(.4),
                                                  blurRadius:
                                                      _glowAnimation.value,
                                                  spreadRadius:
                                                      _glowAnimation.value,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: FloatingActionButton(
                                                  heroTag:
                                                      'ADDCATEGORYSCREEN-FAB',
                                                  splashColor: KMainOrange,
                                                  backgroundColor: KMainOrange,
                                                  onPressed: () {
                                                    //! checking to see if category title is null or blank
                                                    if (newCategoryTitle ==
                                                            null ||
                                                        newCategoryTitle
                                                                .trim() ==
                                                            '') {
                                                      noNameAlert(
                                                          context, 'Category');
                                                    } else {
                                                      //! Adding new category to categoriesBox

                                                      Category newCategory =
                                                          Category(
                                                              name:
                                                                  newCategoryTitle);
                                                      Hive.box('categories')
                                                          .add(newCategory);
                                                      _scaleAnimationController
                                                          .forward()
                                                          .then(
                                                            (value) =>
                                                                _scaleAnimationController
                                                                    .reverse(),
                                                          );

                                                      //! bottom bar event anuncing successful addtiong of new category
                                                      Flushbar(
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                              messageText: Text(
                                                                'Category added successfuly.',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      KTextFontFamily,
                                                                  color: Colors
                                                                      .white,
                                                                  shadows: [],
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              flushbarStyle:
                                                                  FlushbarStyle
                                                                      .FLOATING)
                                                          .show(context);
                                                      textFieldController
                                                          .clear();
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      newCategoryTitle = null;
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.fingerprint,
                                                    size: 60,
                                                    color: Colors.white38,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
