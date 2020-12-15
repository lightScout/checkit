import 'package:flutter/material.dart';

Widget customClipRRect({Widget child}) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(25)),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF2A9D8F),
              Color(0xFF9bdeff),
            ]),
      ),
      child: child,
    ),
  );
}
