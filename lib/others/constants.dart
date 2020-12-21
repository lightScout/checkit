library constants;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color KMainPurple = Color(0xFF071F86);
const Color KBabyBlue = Color(0xFF9bdeff);
const Color KPersinanGreen = Color(0xFF2A9D8F);
const Color KMainOrange = Color(0xFFFA9700);
const Color KMainRed = Color(0xFFFF1d1d);
const Color KTopLinearGradientColor = Color(0xFF9bdeff);
const Color KBottomLinearGradientColor = Color(0xFFEBF8FF);
const String KMainFontFamily = 'PressStart2P';

const LinearGradient KMainLinearGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [KTopLinearGradientColor, KBottomLinearGradientColor],
);

const TextStyle Klogo = TextStyle(
  fontSize: 33,
  color: Color(0xFF071F86),
  fontWeight: FontWeight.bold,
  fontFamily: 'PressStart2P',
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
