import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

AwesomeDialog noNameAlert(
  BuildContext context,
  String type,
) {
  return animatedDialog(context, type);
}

AwesomeDialog animatedDialog(BuildContext context, String type) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    animType: AnimType.BOTTOMSLIDE,
    btnOkOnPress: () {
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
              "$type name is missing or contains only blank space.",
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
