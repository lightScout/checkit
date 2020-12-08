import 'package:flutter/material.dart';

Widget customClipRRect({Widget child}) {
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(60)),
    child: Container(
      color: Colors.white30,
      child: child,
    ),
  );
}
