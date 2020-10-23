import 'package:ciao_app/widgets/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatelessWidget {
  static const id = 'IntroScreen';
  static Widget svgPhoto1 = SvgPicture.asset(
    'images/intro1.svg',
    height: 200,
  );
  static Widget svgPhoto2 = SvgPicture.asset(
    'images/intro2.svg',
    height: 200,
  );
  static Widget svgPhoto3 = SvgPicture.asset(
    'images/intro3.svg',
    height: 200,
  );
  static Widget svgPhoto4 = SvgPicture.asset(
    'images/intro4.svg',
    height: 200,
  );
  List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      decoration: PageDecoration(pageColor: Colors.white),
      title: "Title of first page",
      body:
          "Here you can write the description of the page, to explain someting...",
      image: Center(
        child: svgPhoto1,
      ),
    ),
    // PageViewModel(
    //   decoration: PageDecoration(pageColor: Colors.white),
    //   title: "Title of first page",
    //   body:
    //       "Here you can write the description of the page, to explain someting...",
    //   image: Center(
    //     child: svgPhoto2,
    //   ),
    // ),
    // PageViewModel(
    //   decoration: PageDecoration(pageColor: Colors.white),
    //   title: "Title of first page",
    //   body:
    //       "Here you can write the description of the page, to explain someting...",
    //   image: Center(
    //     child: svgPhoto3,
    //   ),
    // ),
    // PageViewModel(
    //   decoration: PageDecoration(pageColor: Colors.white),
    //   title: "Title of first page",
    //   body:
    //       "Here you can write the description of the page, to explain someting...",
    //   image: Center(
    //     child: svgPhoto4,
    //   ),
    // ),
  ];
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewModel,
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () {
        Navigator.pushNamed(context, StackLayout.id);
      },
    ); //Material App;
  }
}
