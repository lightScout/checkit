import 'package:ciao_app/widgets/curve_painter_circules.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ciao_app/icons/rate_menu_icon_icons.dart';
import 'package:ciao_app/icons/about_menu_icon_icons.dart';
import 'settings_screen.dart';

class MenuScreen extends StatelessWidget {
  final Animation<Offset> slideAnimation;

  MenuScreen({this.slideAnimation});
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFF6B0F1A), Color(0xFF31081F)]),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Color(0xFF0F0F0F),
            ),
            width: 200,
            height: 660,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.all(30.0),
//                    child: CircleAvatar(
//                      radius: 50,
//                      backgroundColor: Color(0xFF0F0F0F),
//                    ),
//                  ),
                  SizedBox(
                    height: 10,
                  ),
//                  ListTile(
//                    leading: Icon(
//                      Icons.help,
//                      size: 40,
//                      color: Colors.white,
//                    ),
//                    title: Text(
//                      'Help',
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.w700,
//                          fontSize: 25.0,
//                          fontFamily: 'PoiretOne'),
//                    ),
//                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: Icon(
                      LineIcons.info_circle,
                      color: Colors.white,
                      size: 40,
                    ),
                    title: Text(
                      'Info',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'PoiretOne',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: Icon(
                      RateMenuIcon.emo_wink2,
                      color: Colors.white,
                      size: 40,
                    ),
                    title: Text(
                      'Rate it',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 24.0,
                        fontFamily: 'PoiretOne',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: InkWell(
                        child: Icon(
                          LineIcons.cog,
                          color: Colors.white,
                          size: 40,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => SingleChildScrollView(
                                child: Container(
                              child: SettingsScreen(),
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                            )),
                            backgroundColor: Colors.transparent,
                          );
                        }),
                    title: Text(
                      'Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 24.0,
                        fontFamily: 'PoiretOne',
                      ),
                    ),
                  ),
//                  Flexible(
//                      child: Circle(center: {"x": 20, "y": -800}, radius: 345)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
