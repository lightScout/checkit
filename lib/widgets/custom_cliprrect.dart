import 'package:flutter/material.dart';

Widget customClipRRect({Widget child}) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(25)),
    child: Container(
      color: Colors.white12,
      child: child,
    ),
  );
}
