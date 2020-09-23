import 'package:ciao_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:ciao_app/widgets/list_builder.dart';
import 'package:line_icons/line_icons.dart';
import 'package:hive/hive.dart';
import 'package:ciao_app/others/constants.dart' as Constant;

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isCollapsed = true;
  bool isMainSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /**
             * Top section 'Appbar'
             * **/

          /**
             * Task list builder section
             * **/
        ],
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
