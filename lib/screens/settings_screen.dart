import 'package:ciao_app/model/theme_manager.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/screens/info_screen.dart';
import 'package:ciao_app/widgets/app_reset_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeNotifier _theme = Provider.of<ThemeNotifier>(context);
    bool _isDarkMode = _theme.getThemeMode == 'dark' ? true : false;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
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
            height: 22,
          ),
          Text(
            'Settings',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontFamily: 'PressStart2P'),
          ),
          SizedBox(
            height: 40,
          ),

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, InfoScreen.id);
            },
            child: ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.white,
              ),
              title: Text(
                'About checKit',
                style: TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Colors.white,
                    fontSize: 12),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              appResetAlert(context);
            },
            child: ListTile(
              leading: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              title: Text(
                'Reset App',
                style: TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Colors.white,
                    fontSize: 12),
              ),
            ),
          ),

          ListTile(
            leading: Icon(
              Icons.star,
              color: Colors.white,
            ),
            title: Text(
              'Pro - Coming Soon!',
              style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Colors.white,
                  fontSize: 12),
            ),
          ),
          ListTile(
            leading: Switch(
              inactiveTrackColor: Colors.white12,
              activeColor: KMainOrange,
              value: _isDarkMode,
              onChanged: (value) {
                if (_isDarkMode) {
                  _theme.setLightMode();
                  _isDarkMode = false;
                } else if (!_isDarkMode) {
                  _theme.setDarkMode();
                  _isDarkMode = true;
                }
              },
            ),
            title: Text(
              'Dark mode',
              style: TextStyle(
                  fontFamily: 'PressStart2P',
                  color: Colors.white,
                  fontSize: 12),
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
