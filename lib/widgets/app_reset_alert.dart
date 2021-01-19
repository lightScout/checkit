import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

AwesomeDialog appResetAlert(BuildContext context) {
  return animatedDialog(context);
}

AwesomeDialog animatedDialog(BuildContext context) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    animType: AnimType.BOTTOMSLIDE,
    btnOkOnPress: () {
      Hive.box('categories').clear();
      Hive.box('tasks').clear();
      Navigator.of(context).popUntil((route) => route.isCurrent);
    },
    btnCancelOnPress: () {
      Navigator.of(context).popUntil((route) => route.isCurrent);
    },
    headerAnimationLoop: false,
    body: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                "Attetion!",
                style: Klogo.copyWith(
                  fontFamily: KTextFontFamily,
                  fontSize: 30,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.red,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                  color: Colors.yellowAccent[700],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              "Reseting the app will wipe clean the app's database. Are you sure you want to do this?",
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
