import 'package:flutter/material.dart';

Widget customClipRRect({Widget child, List<Color> colors}) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(25)),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: colors),
      ),
      child: child,
    ),
  );
}
