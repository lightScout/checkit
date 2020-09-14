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
      this.isChecked,
      this.isCheckCallBack,
      this.category = 'Main',
      this.dueDate});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: widget.isChecked
            ? LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF00458E), Color(0xFF000328)])
            : LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF8DE9D5), Color(0xFF0F8099)]),
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: ListTile(
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
                color: !widget.isChecked ? Colors.white : Color(0xFF00458E),
                offset: Offset(0.0, 0.0),
                blurRadius: 20.0,
                spreadRadius: 5.4,
              ),
            ],
          ),
          child: InkWell(
            onTap: widget.isCheckCallBack,
            child: CircleAvatar(
              radius: 16,
              child: widget.isChecked
                  ? Icon(
                      LineIcons.dot_circle_o,
                      color: Colors.white,
                    )
                  : null,
              backgroundColor:
                  widget.isChecked ? Color(0xFF00458E) : Colors.white,
            ),
          ),
        ),
        // trailing: InkWell(
        //   child: Icon(
        //     Icons.delete,
        //     color: Colors.white,
        //     size: 30,
        //   ),
        //   onTap: widget.deleteTask,
        // ),
        title: Text(
          widget.title,
          style: TextStyle(
              fontFamily: 'PoiretOne',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              decoration: widget.isChecked ? TextDecoration.lineThrough : null),
        ),
        subtitle: Text(
          widget.dueDate,
          style: TextStyle(
              fontSize: 15,
              color: Colors.white60,
              fontWeight: FontWeight.w700,
              fontFamily: 'PoiretOne'),
        ),
      ),
    );
  }
}
