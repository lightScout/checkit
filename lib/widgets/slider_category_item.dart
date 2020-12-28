import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';

class SliderCategoryItem extends StatelessWidget {
  final String categoryTitle;

  const SliderCategoryItem({this.categoryTitle});

  get getCategoryTitle {
    return categoryTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 25,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: Colors.orange,
          ),
          // color: Color(0xff420010),
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xff420010), KMainRed.withAlpha(200)]),
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        child: Center(
            child: Text(
          categoryTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'PressStart2P', fontSize: 11, color: Colors.white),
        )),
      ),
    );
  }
}
