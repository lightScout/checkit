import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';

AwesomeDialog infoAlert(BuildContext context, String information, String page) {
  return AwesomeDialog(
    context: context,
    customHeader: Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          //TODO: update add task icon to one with more opacity
          image: (page == 'AddCategory')
              ? AssetImage('assets/textures/add_category_screen_texture2.png')
              : AssetImage('assets/textures/add_task_screen_texture.png'),
        ),
      ),
    ),
    animType: AnimType.LEFTSLIDE,
    btnOkOnPress: () {
      Navigator.of(context).popUntil((route) => route.isCurrent);
    },
    btnOkColor: KMainOrange,
    headerAnimationLoop: false,
    body: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              information,
              textAlign: TextAlign.center,
              style: Klogo.copyWith(
                fontFamily: KTextFontFamily,
                fontSize: 22,
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.red,
                    offset: Offset(5.0, 5.0),
                  ),
                ],
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
    dialogBackgroundColor: Colors.red[800].withOpacity(0.75),
  )..show();
}
