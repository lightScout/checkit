import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  static const id = 'infoScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {
                  AppSettings.openAppSettings();
                },
                child: Icon(Icons.info),
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     GestureDetector(
              //       child: Icon(
              //         Icons.arrow_back,
              //         color: Colors.black,
              //       ),
              //     ),
              //   ],
              // ),
              Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'checKit',
                      style: TextStyle(fontSize: 55, color: Colors.black),
                    ),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
