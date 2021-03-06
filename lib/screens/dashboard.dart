import 'package:carousel_slider/carousel_slider.dart';
import 'package:ciao_app/Paint/circle_painter.dart';
import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/model/flags.dart';
import 'package:ciao_app/model/theme_manager.dart';

import 'package:ciao_app/others/constants.dart' as Constant;
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/screens/calendar_screen.dart';
import 'package:ciao_app/screens/full_screen_page.dart';
import 'package:ciao_app/screens/search_screen.dart';
import 'package:ciao_app/screens/settings_screen.dart';
import 'package:ciao_app/widgets/carousel_item_for_task_screen.dart';
import 'package:ciao_app/widgets/delete_category_alert.dart';

import 'package:ciao_app/widgets/no_name_alert.dart';
import 'package:ciao_app/widgets/slider_side_menu.dart';
import 'package:ciao_app/widgets/title_bubble.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ciao_app/widgets/custom_cliprrect.dart' as CustomClipRRect;
import 'package:animate_icons/animate_icons.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../widgets/list_builder.dart';

final Color bgColor = Color(0xFF4A5A58);

class Dashboard extends StatefulWidget {
  static const id = 'task_list_screen';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  final tasksBox = Hive.box('tasks');
  final categoriesBox = Hive.box('categories');
  String newTaskCategory;

  ScrollController hideButtonController =
      ScrollController(keepScrollOffset: true);
  AnimationController _animationController;
  AnimateIconController _animateIconController;

  //* Circle wave animation controller and variables
  double waveRadius = 0.0;
  double waveGap = 10.0;
  Animation<double> _waveAnimation;
  AnimationController _waveAnimationController;

  //* Carousel Controller
  final _carouselController = CarouselController();

  List<Widget> carouselList = [];
  List listOfCategoriesKeys = [];
  double xOffset = 0;
  double yOffsetPage = 0;
  double yOffsetFrontContainer = 0;
  double scaleFactor = 1;
  double topBorderRadius = 0;
  double topBorderRadiusContainer = 0;
  String newSearchName;
  int carouselIndex = 0;
  bool carouselIndexNeedsUpdate = false;

  @override
  void initState() {
    super.initState();
    buildCarouselList();
    _animateIconController = AnimateIconController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 190),
    );
    _waveAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));

    _waveAnimationController.forward();

    _waveAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _waveAnimationController.reset();
      } else if (status == AnimationStatus.dismissed) {
        _waveAnimationController.forward();
      }
    });
    // _animation =
    //     CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    // _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    hideButtonController.dispose();
    _animationController.dispose();
  }

  void deleteCategory(int categoryKey) {
    deleteCategoryAlert(context, categoryKey);
  }

  void buildCarouselList() {
    carouselList.clear();
    listOfCategoriesKeys = categoriesBox.keys.toList();

    if (carouselIndex == 0 && categoriesBox.length > 0) {
      carouselIndex = categoriesBox.length;
    }
    if ((categoriesBox.isNotEmpty && carouselIndex < categoriesBox.length)) {
      carouselIndex = categoriesBox.length;
    }

    listOfCategoriesKeys.forEach((element) {
      Category a = categoriesBox.get(element) as Category;
      a.key = element;

      carouselList.insert(
          0,
          CarouselItemForTaskScreen(
            a.name,
            a.key,
            tasksBox,
            categoriesBox,
            () {
              deleteCategory(a.key);
            },
            () {
              //* flag trigger to minimize close search container
              if ((Hive.box('flags').getAt(1) as Flags).value) {
                setState(() {
                  yOffsetFrontContainer = 0;
                  topBorderRadiusContainer = 0;
                  topBorderRadius = 0;
                  //* flag triger to minimize add category screen
                  Hive.box('flags').putAt(
                      1, Flags(name: 'toggleAddCategoryScreen', value: false));
                  //* tringer for animated icon

                  if (_animateIconController.isEnd()) {
                    _animateIconController.animateToStart();
                  }
                });
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FullScreenPage(
                          category: a.categoryName,
                        )),
              );
            },
            context,
          ));
    });

    //* sycning the carousel when add task screen carousel get its page turned
    if ((Hive.box('flags').getAt(2) as Flags).value != null) {
      if ((Hive.box('flags').getAt(2) as Flags).value) {
        var indexName = (Hive.box('flags').getAt(2) as Flags).data;
        carouselList.forEach((element) {
          if ((element as CarouselItemForTaskScreen).category == indexName) {
            _carouselController.animateToPage(carouselList.indexOf(element));
            //* flag to signal synced carousel
            Hive.box('flags').putAt(
                2,
                Flags(
                  name: 'addTaskScreenCarouselPageTurned',
                  value: false,
                  data: null,
                ));
          }
        });
      }
    }
  }

  Widget categoryCarousel() {
    buildCarouselList();
    return carouselList.isNotEmpty
        ? CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              aspectRatio: .68,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                Hive.box('flags').putAt(
                    3,
                    Flags(
                        name: 'taskListScreenCarouselPageTurned',
                        value: true,
                        data: (carouselList[index] as CarouselItemForTaskScreen)
                            .category));
              },
              onScrolled: (index) {},
            ),
            items: carouselList,
          )
        : SizedBox(
            height: 0,
            width: 0,
          );
  }

  void checkState() {
    if (Hive.box('flags').getAt(4) != null) {
      if ((Hive.box('flags').getAt(4) as Flags).value) {
        setState(() {
          yOffsetFrontContainer = MediaQuery.of(context).size.height / 1.2;
        });
        //* flag for search in progress
        Hive.box('flags').putAt(
            4, Flags(name: 'searchInProgress', value: false, data: null));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkState();

    _waveAnimation =
        Tween(begin: 0.0, end: waveGap).animate(_waveAnimationController)
          ..addListener(() {
            setState(() {
              waveRadius = _waveAnimation.value;
            });
          });
    return Consumer<ThemeNotifier>(
      builder: (contex, theme, _) => AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        transform: Matrix4.translationValues(
          0,
          yOffsetPage,
          0,
        )..scale(scaleFactor),
        duration: Duration(milliseconds: 1000),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            //* FAB Page Controller
            floatingActionButton: FabCircularMenu(
                ringDiameter: MediaQuery.of(context).size.width * 0.75,
                ringWidth: (MediaQuery.of(context).size.width * 0.7) * 0.22,
                animationDuration: Duration(milliseconds: 300),
                fabCloseColor:
                    (Provider.of<ThemeNotifier>(context).getThemeMode == 'dark')
                        ? KMainOrange
                        : Color(0xFF071F86),
                fabElevation: 6,
                fabMargin: EdgeInsets.only(right: 47, bottom: 40),
                fabOpenColor: Color(0xFFFF1d1d),
                ringColor: Color(0xFFFA9700),
                //* close icon
                fabCloseIcon: CustomClipRRect.customClipRRect(
                  colors: [
                    Colors.pinkAccent,
                    KMainRed,
                  ],
                  child: Padding(
                    padding: const EdgeInsets.all(9.99),
                    child: Icon(
                      Icons.close,
                      size: 33,
                      color: Colors.white,
                    ),
                  ),
                ),
                //* open icon
                fabOpenIcon: Icon(
                  Icons.fingerprint,
                  size: 49,
                  color: Colors.white,
                ),
                children: <Widget>[
                  //* settings button
                  CustomClipRRect.customClipRRect(
                    colors: [
                      Colors.white24,
                      Colors.orange[600],
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(9.99),
                      child: InkWell(
                          child: Icon(
                            Icons.settings_sharp,
                            size: 35,
                            color: Color(0xFFf8f0bc),
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => SingleChildScrollView(
                                  child: Container(
                                child: SettingsScreen(),
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                              )),
                              backgroundColor: Colors.transparent,
                            );
                          }),
                    ),
                  ),

                  //* calendar button
                  CustomClipRRect.customClipRRect(
                    colors: [
                      Colors.white24,
                      Colors.orange[600],
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(9.99),
                      child: InkWell(
                        child: Icon(
                          Icons.calendar_today,
                          color: Color(0xFFf8f0bc),
                          size: 33,
                        ),
                        onTap: () {
                          //* flag trigger to minimize close search container
                          if ((Hive.box('flags').getAt(1) as Flags).value) {
                            setState(() {
                              yOffsetFrontContainer = 0;
                              topBorderRadiusContainer = 0;
                              topBorderRadius = 0;
                              //* flag triger to minimize add category screen
                              Hive.box('flags').putAt(
                                  1,
                                  Flags(
                                      name: 'searchPageIsOpen', value: false));
                              //* tringer for animated icon
                              if (_animateIconController.isEnd()) {
                                _animateIconController.animateToStart();
                              }
                            });
                          }

                          Navigator.of(context).pushNamed(CalendarScreen.id);
                        },
                      ),
                    ),
                  ),

                  //* add category button
                  CustomClipRRect.customClipRRect(
                    colors: [
                      Colors.white24,
                      Colors.orange[600],
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(9.99),
                      child: InkWell(
                        child: Icon(
                          Icons.category_sharp,
                          color: Color(0xFFf8f0bc),
                          size: 35,
                        ),
                        onTap: () {
                          //* triger for animated container

                          if ((Hive.box('flags').getAt(1) as Flags).value) {
                            setState(() {
                              yOffsetFrontContainer = 0;
                              topBorderRadiusContainer = 50;
                              //* flag triger to minimize search screen
                              Hive.box('flags').putAt(
                                  1,
                                  Flags(
                                      name: 'searchPageIsOpen', value: false));
                            });
                          }
                          //* triger for animated container
                          setState(() {
                            topBorderRadius = 50;
                            topBorderRadiusContainer = 50;
                            yOffsetPage =
                                MediaQuery.of(context).size.height / 1.15;
                          });
                          //* tringer for animated icon
                          if (_animateIconController.isStart()) {
                            _animateIconController.animateToEnd();
                          }
                          //* flag triger to opem add category screen if closed
                          Hive.box('flags').putAt(
                              5,
                              Flags(
                                  name: 'openAddCategoryScreen', value: true));
                        },
                      ),
                    ),
                  ),

                  //* add task button
                  CustomClipRRect.customClipRRect(
                    colors: [
                      Colors.white24,
                      Colors.orange[600],
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(9.99),
                      child: InkWell(
                        child: Icon(
                          Icons.add,
                          color: Color(0xFFf8f0bc),
                          size: 35,
                        ),
                        onTap: () {
                          if ((Hive.box('flags').getAt(1) as Flags).value) {
                            setState(() {
                              yOffsetFrontContainer = 0;
                              topBorderRadiusContainer = 50;
                              //* flag triger to minimize add category screen
                              Hive.box('flags').putAt(
                                  1,
                                  Flags(
                                      name: 'searchPageIsOpen', value: false));
                            });
                          }
                          //* triger for animated container
                          setState(() {
                            topBorderRadius = 50;
                            topBorderRadiusContainer = 50;
                            yOffsetPage =
                                MediaQuery.of(context).size.height / 1.15;
                          });
                          //* creates a 'General' category if there is no category available
                          if (categoriesBox.isEmpty) {
                            Category newCategory = Category(name: 'General');
                            Hive.box('categories').add(newCategory);
                          }
                          //* tringer for animated icon
                          if (_animateIconController.isStart()) {
                            _animateIconController.animateToEnd();
                          }
                          //* flag triger to minimize add category screen
                          Hive.box('flags').putAt(
                              0,
                              Flags(
                                  name: 'toggleAddCategoryScreen',
                                  value: true));
                        },
                      ),
                    ),
                  ),
                ]),
            body: Stack(children: [
              //* Back container
              SearchScreen(
                topBorderRadius: topBorderRadiusContainer,
              ),
              //* Front container
              AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                transform: Matrix4.translationValues(
                  0,
                  yOffsetFrontContainer,
                  0,
                )..scale(scaleFactor),
                duration: Duration(milliseconds: 600),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(topBorderRadius),
                      topRight: Radius.circular(topBorderRadius),
                    ),
                    gradient:
                        (Provider.of<ThemeNotifier>(context).getThemeMode ==
                                'dark')
                            ? Constant.KBGGradientDark
                            : Constant.KDashboardBGGradient,
                    border: Border.all(
                      color: Colors.white54,
                      width: 10,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink[300],
                        offset: Offset(0.0, -4.0), //(x,y)
                        blurRadius: 100.0,
                      ),
                      BoxShadow(
                        color: Colors.pink[700],
                        offset: Offset(0.0, -2.0), //(x,y)
                        blurRadius: 11.1,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   image: AssetImage(
                        //       'assets/textures/task_list_screen_texture.png'),
                        // ),

                        ),
                    child: Stack(
                      children: [
                        //* Custom Paint
                        CustomPaint(
                          size: Size(double.infinity, double.infinity),
                          painter: CirclePainter(waveRadius),
                          child: Container(),
                        ),
                        //* Page Content
                        Column(
                          children: <Widget>[
                            //*
                            //* NAVEGATION BUTTON and Screen TITLE
                            //*
                            Container(
                              padding: EdgeInsets.only(
                                  left: 0, right: 0, top: 24, bottom: 0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 22,
                                      right: 22,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomClipRRect.customClipRRect(
                                          colors: (Provider.of<ThemeNotifier>(
                                                          context)
                                                      .getThemeMode ==
                                                  'dark')
                                              ? KButtonsBGGrandientColorsDark
                                              : KButtonsBGGrandientColors,
                                          child: AnimateIcons(
                                            controller: _animateIconController,
                                            startIcon: categoriesBox.isNotEmpty
                                                ? Icons.search
                                                : Icons.add,
                                            startTooltip: 'Icons.add',
                                            endTooltip: 'Icons.close',
                                            endIcon: Icons.close,
                                            color: (Provider.of<ThemeNotifier>(
                                                            context)
                                                        .getThemeMode ==
                                                    'dark')
                                                ? Colors.white
                                                : Color(0xFF071F86),
                                            size: 33,
                                            onStartIconPress: () {
                                              if (categoriesBox.isNotEmpty) {
                                                setState(() {
                                                  topBorderRadius = 50;
                                                  yOffsetFrontContainer =
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          2.6;
                                                  //* flag to signal search page is open
                                                  Hive.box('flags').putAt(
                                                      1,
                                                      Flags(
                                                          name:
                                                              'searchPageIsOpen',
                                                          value: true));
                                                });
                                              } else {
                                                setState(() {
                                                  topBorderRadius = 50;
                                                  topBorderRadiusContainer = 50;

                                                  yOffsetPage =
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          1.15;
                                                });
                                              }
                                              return true;
                                            },
                                            onEndIconPress: () {
                                              setState(() {
                                                topBorderRadius = 0;
                                                topBorderRadiusContainer = 0;
                                                yOffsetPage = 0;
                                                yOffsetFrontContainer = 0;

                                                //* flag to signal search page is closed
                                                Hive.box('flags').putAt(
                                                    1,
                                                    Flags(
                                                        name:
                                                            'searchPageIsOpen',
                                                        value: false));
                                                Hive.box('flags').putAt(
                                                    4,
                                                    Flags(
                                                        name:
                                                            'searchInProgress',
                                                        value: false,
                                                        data: null));
                                              });
                                              return true;
                                            },
                                          ),
                                        ),
                                        //*
                                        //* Title
                                        //*
                                        // Text(
                                        //   'checKit',
                                        //   style: (Provider.of<ThemeNotifier>(
                                        //                   context)
                                        //               .getThemeMode ==
                                        //           'dark')
                                        //       ? Constant
                                        //           .KDashboardScreenTitleDark
                                        //       : Constant.KDashboardScreenTitle,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //*
                            //* Category Carousel
                            //*
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ValueListenableBuilder(
                                        valueListenable:
                                            Hive.box('flags').listenable(),
                                        builder: (context, box, widget) {
                                          return ValueListenableBuilder(
                                              valueListenable:
                                                  Hive.box('categories')
                                                      .listenable(),
                                              builder: (context, box, widget) {
                                                return ValueListenableBuilder(
                                                    valueListenable:
                                                        tasksBox.listenable(),
                                                    builder:
                                                        (context, box, widget) {
                                                      return categoryCarousel();
                                                    });
                                              });
                                        }),

                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: carouselList.map((item) {
                                    //     int index = carouselList.indexOf(item);
                                    //     return Container(
                                    //       width: 8.0,
                                    //       height: 8.0,
                                    //       margin: EdgeInsets.symmetric(
                                    //           vertical: 10.0, horizontal: 2.0),
                                    //       decoration: BoxDecoration(
                                    //         shape: BoxShape.circle,
                                    //         color: _current == index
                                    //             ? Color.fromRGBO(0, 0, 0, 0.9)
                                    //             : Color.fromRGBO(0, 0, 0, 0.4),
                                    //       ),
                                    //     );
                                    //   }).toList(),
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Container(

              // ),
            ])),
      ),
    );
  }
}
