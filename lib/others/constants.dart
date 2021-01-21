library constants;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

const Color KMainPurple = Color(0xFF071F86);
const Color KBabyBlue = Color(0xFF9bdeff);
const Color KPersinanGreen = Color(0xFF2A9D8F);
const Color KMainOrange = Color(0xFFFA9700);
const Color KMainRed = Color(0xFFFF1d1d);
const Color KTopLinearGradientColor = KMainPurple;
const Color KBottomLinearGradientColor = Color(0xFFEBF8FF);
const String KPageTitleFontFamily = 'FrauncesBoldItalic';
const String KTextFontFamily = 'DMSerifTextRegular';

const LinearGradient KDashboardBGGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [Color(0xFF9bdeff), KBottomLinearGradientColor],
);

const LinearGradient KDashboardBGGradientDark = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [Color(0xFF54525E), Color(0xFF13111B)],
);

const LinearGradient KCarouselItemForTaskScreenBGGradient = LinearGradient(
  begin: Alignment.center,
  end: Alignment.bottomLeft,
  colors: [Color(0xFF9bdeff), Color(0xFFEBF8FF)],
);
const LinearGradient KCarouselItemForTaskScreenBGGradientDark = LinearGradient(
  begin: Alignment.center,
  end: Alignment.bottomLeft,
  colors: [
    Colors.transparent,
    Colors.transparent,
  ],
);

const List<Color> KButtonsBGGrandientColors = [
  Colors.white,
  Colors.white10,
];
const List<Color> KButtonsBGGrandientColorsDark = [
  Color(0xFFFFB74D),
  Color(0xFFEF6C00),
];

const TextStyle KCarouseItemForTaskScreenTitleStyle = TextStyle(
  color: KMainPurple,
  fontFamily: 'DMSerifTextRegular',
  fontWeight: FontWeight.bold,
  fontSize: 22,
  shadows: [
    Shadow(
      blurRadius: 2.0,
      color: Colors.blue,
      offset: Offset(3.3, 3.3),
    ),
    Shadow(
      color: Colors.white,
      blurRadius: 6.0,
      offset: Offset(2.0, 2.0),
    ),
  ],
);

const TextStyle KCarouseItemForTaskScreenTitleStyleDark = TextStyle(
  color: Colors.white,
  fontFamily: 'DMSerifTextRegular',
  fontWeight: FontWeight.bold,
  fontSize: 22,
  shadows: [
    Shadow(
      color: Colors.white24,
      blurRadius: 1.0,
      offset: Offset(4.0, 4.0),
    ),
  ],
);

const BoxShadow KCarouselItemBoxShadow = BoxShadow(
  color: Color(0xFF448AFF),
  offset: Offset(5.0, 5.0), //(x,y)
  blurRadius: 5.0,
);

const BoxShadow KCarouselItemBoxShadowDark = BoxShadow(
  color: Colors.transparent,
);

const TextStyle KDashboardScreenTitle = TextStyle(
  fontFamily: 'FrauncesBoldItalic',
  color: Colors.white,
  fontSize: 43,
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
);

const TextStyle KDashboardScreenTitleDark = TextStyle(
  fontFamily: 'FrauncesBoldItalic',
  color: Colors.white,
  fontSize: 43,
  shadows: [
    Shadow(
      color: Colors.white24,
      blurRadius: 1.0,
      offset: Offset(4.0, 4.0),
    ),
  ],
);

const TextStyle Klogo = TextStyle(
  fontSize: 33,
  color: Colors.white,
  fontFamily: 'FrauncesBoldItalic',
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
);

const TextStyle KAlertTextStyleInfoText = TextStyle(
  fontFamily: 'DMSerifTextRegular',
  fontSize: 22,
  shadows: [
    Shadow(
      blurRadius: 2.0,
      color: Colors.red,
      offset: Offset(5.0, 5.0),
    ),
  ],
);

const TextStyle KAlertTextStyleTitle = TextStyle(
  fontFamily: 'DMSerifTextRegular',
  fontSize: 33,
  shadows: [
    Shadow(
      blurRadius: 2.0,
      color: Colors.red,
      offset: Offset(5.0, 5.0),
    ),
  ],
  color: Colors.white,
);

const TextStyle KAddTaskScreenTitles = TextStyle(
  fontSize: 14,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'PressStart2P',
  shadows: [],
);

const OutlineInputBorder KInputFieldRoundedCorners = OutlineInputBorder(
  borderRadius: const BorderRadius.all(
    const Radius.circular(25.0),
  ),
);
