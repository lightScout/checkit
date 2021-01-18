import 'package:flutter/material.dart';

class TitleBubble extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color insideColor;
  TitleBubble({this.child, this.borderColor, this.insideColor, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: borderColor,
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
              color: insideColor,
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
              bottom: 11,
              left: 14,
              right: 14,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
