import 'dart:async';

import 'package:ciao_app/others/constants.dart';
import 'package:ciao_app/screens/home_screen.dart';
import 'package:ciao_app/screens/intro_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'SplashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation<Color> _animation;
  // AnimationController _controller;

  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: 2),
      () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF000000),
                    Colors.indigo[900],
                  ]),
            ),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(120)),
                    child: Container(
                      color: Colors.black.withOpacity(.3),
                      height: 180,
                      width: 180,
                      child: Image(
                        image: AssetImage(
                            'assets/textures/splash_screen_texture.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
