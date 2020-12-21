import 'package:ciao_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:ciao_app/others/constants.dart' as Constant;

class IntroScreen extends StatefulWidget {
  static const id = 'IntroScreen';
  IntroScreen({Key key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/icon/$assetName.png', width: 250.0),
      alignment: Alignment.bottomCenter,
    );
  }

  String categoryIntroText =
      'checKit is now organizing your tasks under categories to help you structure your plans and goals. To create a new category, simply tap on the category icon whenever you see, give the category a name and voilà! To kick things off, a General category has been created for you.';
  String notificationIntroTet =
      'checKit is now also able to help you keep a steady flow of completing tasks, if you choose, by notifying you when the due date of a task is approaching. To create a task due-date notification, tap the notification icon when creating a new task and choose the specific due date you would like to have for the new task. This function is available only with checKit pro.';
  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontSize: 17.5,
      fontWeight: FontWeight.w500,
    );
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "checKit 2.0 is here!",
          body:
              "checKit has gone through a significant metamorphosis. It is now more robust, practical and charming than ever. Let's take a quick look at what is new.",
          image: _buildImage('app_icon_v2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Categories",
          body: categoryIntroText,
          image: Align(
            child: Icon(
              Icons.category,
              size: 250,
              color: Constant.KPersinanGreen,
            ),
            alignment: Alignment.bottomCenter,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Notfication",
          body: notificationIntroTet,
          image: Align(
            child: Icon(
              Icons.notifications,
              size: 250,
              color: Constant.KBabyBlue,
            ),
            alignment: Alignment.bottomCenter,
          ),
          decoration: pageDecoration,
        ),
        //TODO: PRO version intro page
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
