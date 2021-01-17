import 'package:ciao_app/model/category.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/screens/full_screen_page.dart';
import 'package:ciao_app/widgets/list_builder.dart';
import 'package:ciao_app/widgets/simple_list_builder.dart';
import 'package:ciao_app/widgets/slider_side_menu.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
  bool isMenuOpen = false;

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
                  bottom: 10.0, left: 0, top: 0.0, right: 00.0),
              decoration: BoxDecoration(
                // border: Border.all(
                //   color: Colors.blue.withOpacity(.1.8),
                // ),
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xFF9bdeff), Color(0xFFEBF8FF)]),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent[400],
                    offset: Offset(5.0, 5.0), //(x,y)
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //*
                  //* Title, full-screen mode and delete categoru button
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
                                        Colors.blue,
                                        Colors.white,
                                      ]),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(30),
                                    topLeft: Radius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Text(
                                        isMenuOpen ? '' : widget.category,
                                        style: Klogo.copyWith(
                                          color: KMainPurple,
                                          fontFamily: 'DMSerifTextRegular',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 2.0,
                                              color: Colors.blue,
                                              offset: Offset(3.3, 3.3),
                                            ),
                                            Shadow(
                                              color: Colors.white,
                                              blurRadius: 6.0,
                                              offset: Offset(2.0, 2.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SliderSideMenu(
                                  function: () {
                                    setState(() {
                                      isMenuOpen = !isMenuOpen;
                                    });
                                    // print(isMenuOpen);
                                  },
                                  parentStartColor: Colors.white54,
                                  parentEndColor: Colors.white54,
                                  childrenData: [
                                    MenuItem(
                                      icon: Icon(
                                        Icons.delete,
                                        color: KMainPurple,
                                      ),
                                      label: Text(""),
                                      onPressed: () {
                                        widget.function();
                                      },
                                    ),
                                    MenuItem(
                                      icon: Icon(
                                        Icons.open_in_full,
                                        color: KMainPurple,
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
                                  description: "Sample tooltip message")
                            ],
                          ),
                        )
                      ]),

                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
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
