import 'package:ciao_app/model/theme_manager.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        width: 120,
        //TODO: make the category item with less height
        // constraints: BoxConstraints(
        //   maxHeight: 5,
        // ),
        decoration: BoxDecoration(
          // border: Border.all(
          //   width: 0,
          //   color: Colors.white54,
          // ),
          // color: Color(0xff420010),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors:
                  (Provider.of<ThemeNotifier>(context).getThemeMode == 'dark')
                      ? KButtonsBGGrandientColorsDark
                      : [
                          Colors.indigo[900],
                          Colors.purple,
                        ]),
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Center(
            child: Text(
          categoryTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'DMSerifTextRegular',
              fontSize: 18,
              color: Colors.blue[50]),
        )),
      ),
    );
  }
}
