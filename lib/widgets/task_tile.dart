import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatefulWidget {
  final String title;
  final Function deleteTask;
  final bool isChecked;
  final Function isCheckCallBack;
  final String category;
  final String dueDate;
  final String _fontFamily = 'PressStart2P';
  final Color _checkedColor1 = Color(0xFF00458E);
  final Color _checkedColor2 = Color(0xFF000328);
  final Color _uncheckedColor1 = Color(0xFF0F8099);

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
    return GestureDetector(
      onDoubleTap: widget.isCheckCallBack,
      child: Container(
        /**
         * Decoration
         * **/
        decoration: BoxDecoration(
          gradient: widget.isChecked
              ? LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [widget._checkedColor1, widget._checkedColor2])
              : LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [KTopBGColor, widget._uncheckedColor1]),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: ListTile(
          // leading: Container(
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     /**
          //      * Circular Shadows
          //      * **/
          //     boxShadow: [
          //       BoxShadow(
          //         color: !widget.isChecked ? Colors.white : Color(0xFF00458E),
          //         offset: Offset(0.0, 0.0),
          //         blurRadius: 20.0,
          //         spreadRadius: 5.4,
          //       ),
          //     ],
          //   ),
          //   /**
          //    * Check Icon
          //    * **/
          //   child: CircleAvatar(
          //     radius: 16,
          //     child: null,
          //     backgroundColor:
          //         widget.isChecked ? Color(0xFF00458E) : Colors.white,
          //   ),
          // ),
          // /**
          //  * Possible Task Delete Icon
          //  * **/
          //TODO: implement delete task here
          trailing: InkWell(
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
            onTap: widget.deleteTask,
          ),
          /**
           * Task Title
           * **/
          title: Text(
            widget.title,
            style: TextStyle(
                fontFamily: widget._fontFamily,
                color: Color(0xFFf8f0bc),
                fontSize: 14,
                decoration:
                    widget.isChecked ? TextDecoration.lineThrough : null),
          ),
          /**
           * Pro: Task Due Date
           * **/
          subtitle: (widget.dueDate != null)
              ? Text(
                  widget.dueDate,
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.white60,
                      fontWeight: FontWeight.w700,
                      fontFamily: widget._fontFamily),
                )
              : null,
        ),
      ),
    );
  }
}
