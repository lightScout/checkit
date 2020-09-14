import 'package:ciao_app/model/task_data.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
        ),
      ),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              shadows: [
                BoxShadow(
                  color: Color(0xFFA3320B),
                  offset: Offset(0.0, 0.0),
                  blurRadius: 10.0,
                  spreadRadius: 5.4,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '0',
            style: TextStyle(
              color: Color(0xFFdb4c40),
              fontSize: 100,
              fontWeight: FontWeight.w600,
              fontFamily: 'PoiretOne',
            ),
          ),
          Text(
            'checKit',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontFamily: 'PoiretOne',
              fontWeight: FontWeight.w800,
            ),
          ),
//          SizedBox(
//            height: 20,
//          ),
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: SingleChildScrollView(
//              child: ListView(
//                shrinkWrap: true,
//                children: <Widget>[
//                  ListTile(
//                    leading: LiteRollingSwitch(
//                      //initial value
//                      animationDuration: Duration(milliseconds: 200),
//                      value: true,
//                      textOn: 'ON',
//                      textOff: 'OFF',
//                      colorOn: Colors.greenAccent[700],
//                      colorOff: Colors.redAccent[700],
//                      iconOn: Icons.done,
//                      iconOff: Icons.remove_circle_outline,
//                      textSize: 16.0,
//                      onChanged: (bool state) {
//                        //Use it to manage the different states
//                        print('Current State of SWITCH IS: $state');
//                      },
//                    ),
//                    title: Text(
//                      'Dream Category',
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 19,
//                          fontWeight: FontWeight.w700,
//                          fontFamily: 'PoiretOne'),
//                    ),
//                  )
//                ],
//              ),
//            ),
//          )
        ],
      ),
    );
  }
}
