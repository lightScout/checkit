import 'package:flutter/material.dart';

Widget customClipRRect({Widget child, List<Color> colors}) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(60)),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors),
      ),
      child: child,
    ),
  );
}
