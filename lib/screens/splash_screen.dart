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
    // _controller =
    //     AnimationController(duration: const Duration(seconds: 2), vsync: this);
    // _animation = ColorTween(begin: Colors.white70, end: Colors.lime)
    //     .animate(_controller);

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
                  colors: [Colors.white, Color(0xFF9bdeff)]),
            ),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Text(
                  //   'checKit',
                  //   style: Klogo,
                  // ),

                  // SizedBox(
                  //   height: 30,
                  // ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(90)),
                    child: Container(
                      height: 140,
                      width: 140,
                      child: Image(
                        image: AssetImage('assets/icon/app_icon_v2.png'),
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(top: 122),
                  //   child: CircularProgressIndicator(
                  //     valueColor: _animation,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(bottom: 10.0),
          //       child: Text(
          //         'from JJ Lightscout',
          //         style: TextStyle(
          //           fontSize: 14,
          //           fontWeight: FontWeight.bold,
          //           color: KMainPurple,
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(bottom: 5.0),
          //       child: Text(
          //         '2.0',
          //         style: TextStyle(
          //           fontSize: 14,
          //           fontWeight: FontWeight.bold,
          //           color: KMainPurple.withOpacity(0.6),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
