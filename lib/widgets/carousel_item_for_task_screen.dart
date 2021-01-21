import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/model/theme_manager.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/screens/full_screen_page.dart';
import 'package:ciao_app/widgets/list_builder.dart';
import 'package:ciao_app/widgets/simple_list_builder.dart';
import 'package:ciao_app/widgets/slider_side_menu.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class CarouselItemForTaskScreen extends StatefulWidget {
  final String category;
  final int categoryKey;
  final Box tasksBox;
  final Box categoriesBox;
  final Function function;
  final Function function2;
  final BuildContext context;
  const CarouselItemForTaskScreen(
      this.category,
      this.categoryKey,
      this.tasksBox,
      this.categoriesBox,
      this.function,
      this.function2,
      this.context);

  @override
  _CarouselItemForTaskScreenState createState() =>
      _CarouselItemForTaskScreenState();
}

class _CarouselItemForTaskScreenState extends State<CarouselItemForTaskScreen> {
  bool isSliderMenuOpen = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //
          //Item
          //
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                  bottom: 15.0, left: 0.0, top: 15.0, right: 0.0),
              decoration: BoxDecoration(
                gradient:
                    (Provider.of<ThemeNotifier>(context).getThemeMode == 'dark')
                        ? KCarouselItemForTaskScreenBGGradientDark
                        : KCarouselItemForTaskScreenBGGradient,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                boxShadow: [
                  (Provider.of<ThemeNotifier>(context).getThemeMode == 'dark')
                      ? KCarouselItemBoxShadowDark
                      : KCarouselItemBoxShadow
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //*
                  //* Title & Slider Menu
                  //*

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              //* Title

                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  gradient: LinearGradient(
                                      begin: Alignment.center,
                                      end: Alignment.topLeft,
                                      colors: [
                                        (Provider.of<ThemeNotifier>(context)
                                                    .getThemeMode ==
                                                'dark')
                                            ? Colors.white
                                            : Colors.blue,
                                        Colors.white,
                                      ]),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                    topLeft: Radius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Opacity(
                                      opacity: isSliderMenuOpen ? .05 : 1.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Text(
                                          widget.category,
                                          style: (Provider.of<ThemeNotifier>(
                                                          context)
                                                      .getThemeMode ==
                                                  'dark')
                                              ? KCarouseItemForTaskScreenTitleStyleDark
                                              : KCarouseItemForTaskScreenTitleStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //* slider menu
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: SliderSideMenu(
                                    function: () {
                                      setState(() {
                                        isSliderMenuOpen = !isSliderMenuOpen;
                                      });
                                    },
                                    parentStartColor: Colors.white54,
                                    parentEndColor: Colors.white54,
                                    childrenData: [
                                      MenuItem(
                                        icon: Icon(
                                          Icons.delete,
                                          color: (Provider.of<ThemeNotifier>(
                                                          context)
                                                      .getThemeMode ==
                                                  'dark')
                                              ? Colors.white
                                              : KMainPurple,
                                        ),
                                        label: Text(""),
                                        onPressed: () {
                                          widget.function();
                                        },
                                      ),
                                      MenuItem(
                                        icon: Icon(
                                          Icons.open_in_full,
                                          color: (Provider.of<ThemeNotifier>(
                                                          context)
                                                      .getThemeMode ==
                                                  'dark')
                                              ? Colors.white
                                              : KMainPurple,
                                        ),
                                        label: Text(""),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FullScreenPage(
                                                category: widget.category,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                    description: "Category tools"),
                              )
                            ],
                          ),
                        )
                      ]),

                  SizedBox(
                    height: 5,
                  ),
                  //* Task list
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: SimpleListBuilder(
                        listCategory: (Hive.box('categories')
                                .get(widget.categoryKey) as Category)
                            .name,
                        tasksBox: widget.tasksBox,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
