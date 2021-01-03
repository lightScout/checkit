import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';

class CarouselItem extends StatelessWidget {
  final String categoryTitle;

  const CarouselItem({this.categoryTitle});

  get getCategoryTitle {
    return categoryTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(.5),
      child: Container(
        height: 25,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(
            width: 5,
            color: Colors.white54,
          ),
          // color: Color(0xff420010),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                KMainPurple,
                Colors.teal[400],
              ]),
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        child: Center(
            child: Text(
          categoryTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'PressStart2P', fontSize: 11, color: Colors.blue[50]),
        )),
      ),
    );
  }
}
