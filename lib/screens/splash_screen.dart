import 'dart:async';

import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'SplashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  Animation<Color> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animation = ColorTween(begin: Colors.white70, end: Colors.lime)
        .animate(_controller);

    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
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
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFF8DE9D5), Color(0xFF0F8099)]),
            ),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'checKit',
                    style: TextStyle(
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: Colors.blue,
                            offset: Offset(5.0, 5.0),
                          ),
                          Shadow(
                            color: Colors.white,
                            blurRadius: 6.0,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                        fontSize: 33,
                        color: Color(0xFF071F86),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PressStart2P'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 22.0, left: 100),
                    child: Text(
                      'from JJ Lightscout',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 122),
                    child: CircularProgressIndicator(
                      valueColor: _animation,
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
