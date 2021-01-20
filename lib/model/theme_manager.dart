import 'package:ciao_app/model/store_manager.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData.dark();

  final lightTheme = ThemeData.light();

  ThemeData _themeData;
  String _themeMode;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
        _themeMode = 'light';
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
        _themeMode = 'dark';
      }
      notifyListeners();
    });
  }

  get getThemeMode {
    return _themeMode;
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    _themeMode = 'dark';
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    _themeMode = 'light';
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
