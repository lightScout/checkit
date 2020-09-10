import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatefulWidget {
  final String title;
  final Function deleteTask;
  final bool isChecked;
  final Function isCheckCallBack;
  final String category;
  final String dueDate;

  TaskTile(
      {this.title,
      this.deleteTask,
      this.isChecked = false,
      this.isCheckCallBack,
      this.category = 'Main',
      this.dueDate});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    bool check;
    if (widget.isChecked == 0) {
      check = false;
    } else {
      check = true;
    }
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          /**
           *
           * Circular Shadows
           *
           * **/
          boxShadow: [
            BoxShadow(
              color: !check ? Colors.red : Color(0xFFA3320B),
              offset: Offset(0.0, 0.0),
              blurRadius: 10.0,
              spreadRadius: 5.4,
            ),
          ],
        ),
        child: InkWell(
          onTap: widget.isCheckCallBack,
          child: CircleAvatar(
            radius: 16,
            child: check
                ? Icon(
                    LineIcons.dot_circle_o,
                    color: Colors.white,
                  )
                : null,
            backgroundColor: check ? Color(0xFFA3320B) : Colors.white,
          ),
        ),
      ),
      trailing: InkWell(
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        onTap: widget.deleteTask,
      ),
      title: Text(
        widget.title,
        style: TextStyle(
            fontFamily: 'PoiretOne',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            decoration: check ? TextDecoration.lineThrough : null),
      ),
      subtitle: Text(
        widget.dueDate,
        style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            fontWeight: FontWeight.w700,
            fontFamily: 'PoiretOne'),
      ),
    );
  }
}
