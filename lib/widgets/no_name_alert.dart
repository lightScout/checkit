import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';

void noNameAlert(BuildContext context, String type) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(32.0),
          ),
        ),
        backgroundColor: Colors.red[800].withOpacity(0.75),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Attetion!",
              style: Klogo.copyWith(
                fontSize: 16,
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
        content: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            "$type name is missing or contains only blank space.",
            style: Klogo.copyWith(
              fontSize: 18,
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
        actions: <Widget>[
          // Button at the bottom of the dialog
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: FloatingActionButton(
                  heroTag: 'NoTaskNameFAB',
                  splashColor: Colors.blue,
                  backgroundColor: Colors.white38,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: Klogo.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      shadows: [
                        Shadow(
                          offset: Offset(6, 6),
                          color: Colors.red[700],
                          blurRadius: 1,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      );
    },
  );
}
