import 'package:ciao_app/screens/settings_screen.dart';
import 'package:ciao_app/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:ciao_app/widgets/curve_painter_dashboard.dart';
import 'package:provider/provider.dart';
import 'package:ciao_app/model/task_data.dart';
import 'package:ciao_app/widgets/list_builder.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ciao_app/icons/menu_bar_icon_icons.dart';
import 'dart:math';

class DashboardScreen extends StatefulWidget {
  final Duration duration;
  final double height;
  final double width;

  final Animation<double> scaleAnimation;
  final AnimationController controller;

  DashboardScreen(
      {this.duration,
      this.width,
      this.height,
      this.controller,
      this.scaleAnimation});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isCollapsed = true;
  bool isMainSelected = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      curve: Curves.ease,
      duration: widget.duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.3 * widget.width,
      right: isCollapsed ? 0 : -0.5 * widget.width,
      child: ScaleTransition(
        scale: widget.scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF6B0F1A), Color(0xFF31081F)]),
          ),
          child: CustomPaint(
            painter: CurvePainterDashboard(),
            child: Material(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: Colors.transparent,
              //elevation: 280,
//            shadowColor: Colors.red,
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Top Section 'AppBar'
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        InkWell(
                          child: Icon(
//                            isCollapsed ? Icons.menu : LineIcons.hand_o_right,
                            LineIcons.cog,
                            color: Color(0xFFFFFFFF),
                            size: isCollapsed ? 33 : 55,
                          ),
                          onTap: () {
//                            setState(() {
//                              if (isCollapsed) {
//                                widget.controller.forward();
//                              } else {
//                                widget.controller.reverse();
//                              }
//                              isCollapsed = !isCollapsed;
//                            });
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
                          },
                        ),
                        Text(
                          'checKit.',
                          style: TextStyle(
                              fontSize: 32,
                              color: Color(0xFFdb4c40),
                              fontWeight: FontWeight.w100,
                              fontFamily: 'PoiretOne'),
                        ),
//                        Icon(Icons.settings, color: Colors.white),
                      ],
                    ),

                    /// 'Must Do' Row
//                    Text(
//                      'Most Do',
//                      style: TextStyle(
//                        color: Color(0xFFdb4c40),
//                        fontSize: 16,
//                        fontWeight: FontWeight.w100,
//                        fontFamily: 'BungeeInLine',
//                      ),
//                    ),

//                    Container(
//                      height: 70,
//                      child: ListBuilder(
//                        listCategory: 'MustDo',
//                      ),
//                    ),
                    SizedBox(
                      height: 70,
                    ),
                    !Provider.of<TaskData>(context).isEmpty
                        ? Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${Provider.of<TaskData>(context).taskCountMain}',
                                    style: TextStyle(
                                      color: Color(0xFFdb4c40),
                                      fontSize: 100,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'PoiretOne',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 60),
                                    child: Text(
                                      'To do',
                                      style: TextStyle(
                                        color: Color(0xFFdb4c40),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'PoiretOne',
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              ///
                              ///
                              ///Separator and more
                              ///
                              ///
//                              Row(
//                                mainAxisSize: MainAxisSize.max,
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceEvenly,
//                                children: <Widget>[
//                                  //Categories
//                                  Expanded(
//                                    child: Container(
//                                      decoration: BoxDecoration(
////                              borderRadius:
////                                  BorderRadius.all(Radius.circular(80)),
//                                        border: isMainSelected
//                                            ? Border(
//                                                bottom: BorderSide(
//                                                    width: .5,
//                                                    color: Colors.white),
//                                              )
//                                            : Border(
//                                                bottom: BorderSide(
//                                                    width: .5,
//                                                    color: Colors.white),
//                                              ),
//                                      ),
////                            child: Text(
////                              'Main',
////                              textAlign: TextAlign.right,
////                              style: TextStyle(
////                                  fontFamily: 'PoiretOne',
////                                  color: isMainSelected
////                                      ? Color(0xFFdb4c40)
////                                      : Colors.white,
////                                  fontSize: isMainSelected ? 27 : 20,
////                                  fontWeight: FontWeight.w100),
////                            ),
//                                    ),
//                                  ),
//                                  Provider.of<TaskData>(context)
//                                          .isDreamTaskCategory()
//                                      ? Expanded(
//                                          child: Container(
//                                            decoration: isMainSelected
//                                                ? BoxDecoration(
//                                                    border: Border(
//                                                      bottom: BorderSide(
//                                                          width: .5,
//                                                          color: Colors.white),
//                                                    ),
//                                                  )
//                                                : BoxDecoration(
//                                                    border: Border(
//                                                      bottom: BorderSide(
//                                                          width: 2.0,
//                                                          color: Colors.white),
//                                                    ),
//                                                  ),
//                                            child: FlatButton(
//                                              onPressed: () {
//                                                setState(() {
//                                                  if (isMainSelected)
//                                                    isMainSelected =
//                                                        !isMainSelected;
//                                                });
//                                              },
//                                              child: Text(
//                                                'Dream',
//                                                style: TextStyle(
//                                                    fontFamily: 'PoiretOne',
//                                                    color: isMainSelected
//                                                        ? Colors.white
//                                                        : Colors.redAccent,
//                                                    fontWeight: FontWeight.w100,
//                                                    fontSize: isMainSelected
//                                                        ? 20
//                                                        : 27),
//                                              ),
//                                            ),
//                                          ),
//                                        )
//                                      : SizedBox(),
//                                ],
//                              ),
                            ],
                          )

                        /// NO TASK text
                        : Padding(
                            padding: const EdgeInsets.only(top: 260),
                            child: Center(
                              child: Opacity(
                                opacity: .4,
                                child: Text('NO TASK',
                                    style: TextStyle(
                                        fontSize: 52,
                                        color: Color(0xFFdb4c40),
                                        fontWeight: FontWeight.w100,
                                        fontFamily: 'PoiretOne')),
                              ),
                            ),
                          ),

                    /// Category Row Selection
                    ///Task Lists
                    isMainSelected
                        ? Flexible(
                            child: Container(
                              width: 400,
                              height: 540,
                              child: ListBuilder(listCategory: 'Main'),
                            ),
                          )
                        : Expanded(
                            child: ListBuilder(listCategory: 'Dream'),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//PageView(
////                        physics: ScrollPhysics(),
//controller: PageController(viewportFraction: 0.8),
//scrollDirection: Axis.horizontal,
//pageSnapping: true,
//children: <Widget>[
//Category(
//bgColor: Colors.redAccent,
//tile: 'Today',
//),
//Container(
//margin: EdgeInsets.symmetric(horizontal: 8),
//color: Colors.greenAccent,
//width: 100,
//),
//Container(
//margin: EdgeInsets.symmetric(horizontal: 8),
//color: Colors.orangeAccent,
//width: 100,
//),
//],
//),

//
//InkWell(
//onTap: () {
//setState(() {
//if (!isMainSelected)
//isMainSelected = !isMainSelected;
//});
//},