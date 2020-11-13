import 'package:ciao_app/widgets/list_builder.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TestScreen extends StatefulWidget {
  static String id = 'TestScreen';

  const TestScreen({Key key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _current = 0;
  List<Widget> list = [
    testList(),
    testList(),
    testList(),
    testList(),
    testList(),
    testList(),
    testList(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                    aspectRatio: 1.0,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
                items: list,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: list.map((url) {
                  int index = list.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget testList() {
  return Column(
    children: [
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListBuilder(listCategory: 'Main'),
        ),
      )
    ],
  );
}
