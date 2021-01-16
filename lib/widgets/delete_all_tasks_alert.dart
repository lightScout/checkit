import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';

void deleteCategoryAlert(BuildContext context, Function function) {
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
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Attetion!",
            textAlign: TextAlign.center,
            style: KAlertTextStyleTitle,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Are you sure you want to delete all tasks under this category?",
            style: KAlertTextStyleInfoText.copyWith(
              color: Colors.yellowAccent[700],
            ),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  heroTag: 'deleteCategoryFAB1',
                  splashColor: Colors.blue,
                  backgroundColor: Colors.white38,
                  onPressed: () {
                    function();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Yes',
                    style: KAlertTextStyleInfoText,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                FloatingActionButton(
                  heroTag: 'deleteCategoryFAB2',
                  splashColor: Colors.blue,
                  backgroundColor: Colors.white38,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: KAlertTextStyleInfoText,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
