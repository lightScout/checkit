import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatefulWidget {
  final bool isBgGradientInverted;
  final String title;
  final Function deleteTask;
  final bool isChecked;
  final Function isCheckCallBack;
  final String category;
  final DateTime dueDate;
  final Color _checkedColor1 = Color(0xFF00458E);
  final Color _checkedColor2 = Color(0xFF000328);
  final Color _uncheckedColor1 = Colors.indigoAccent;

  TaskTile(
      {this.title,
      this.deleteTask,
      this.isChecked,
      this.isCheckCallBack,
      this.category = 'Main',
      this.dueDate,
      this.isBgGradientInverted = false});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onDoubleTap: widget.isCheckCallBack,
        child: Container(
            /**
           * Decoration
           * **/
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    // border: Border.all(
                    //   color: Colors.white12,
                    //   width: 6,
                    // ),
                    gradient: widget.isBgGradientInverted
                        ? widget.isChecked
                            ? LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Colors.red, KMainPurple])
                            : LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                    KMainPurple,
                                    Colors.cyan,
                                  ])
                        : widget.isChecked
                            ? LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                    widget._checkedColor1,
                                    widget._checkedColor2
                                  ])
                            : LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                    KTopLinearGradientColor,
                                    widget._uncheckedColor1
                                  ]),
                  ),
                  child: ListTile(
//            * Task Title
//            * **/
                      title: Text(
                        widget.title,
                        style: TextStyle(
                            fontFamily: 'DMSerifTextRegular',
                            color: widget.isBgGradientInverted
                                ? Colors.white.withOpacity(.88)
                                : Colors.blue[50],
                            fontSize: 20,
                            decoration: widget.isChecked
                                ? TextDecoration.combine(
                                    [TextDecoration.lineThrough])
                                : null),
                      ),
                      subtitle: (widget.dueDate != null)
                          ? Text(
                              "${DateFormat.yMd().add_jm().format(widget.dueDate)}",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white60,
                                fontWeight: FontWeight.w700,
                                fontFamily: KPageTitleFontFamily,
                              ),
                            )
                          : null
                      // : Text(
                      //     '${DateFormat.yMd().format(DateTime.now())}',
                      //     style: TextStyle(
                      //       fontSize: 10,
                      //       color: Colors.white60,
                      //       fontWeight: FontWeight.w700,
                      //       fontFamily: KMainFontFamily,
                      //     ),
                      //   ),
                      ),
                ),
                actions: <Widget>[
                  IconSlideAction(
                    caption: 'checKit',
                    color: widget.isBgGradientInverted
                        ? Color(0xFF071F86)
                        : Colors.teal[500].withOpacity(.9),
                    icon: Icons.check,
                    onTap: widget.isCheckCallBack,
                  ),
                  //TODO: research on how to share to phone system
                  // IconSlideAction(
                  //   caption: 'Share',
                  //   color: Colors.indigo,
                  //   icon: Icons.share,
                  //   onTap: () => {},
                  // ),
                ],
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Delete',
                    color: widget.isBgGradientInverted
                        ? Colors.red
                        : Colors.blue[500].withOpacity(.9),
                    icon: Icons.delete,
                    onTap: widget.deleteTask,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

// ListTile(

//           //  * Possible Task Delete Icon
//           //  * **/
//           //TODO: implement delete task here
//           trailing: InkWell(
//             child: Icon(
//               Icons.delete_sweep,
//               color: Colors.white,
//               size: 30,
//             ),
//             onTap: widget.deleteTask,
//           ),
//           /**
//            * Task Title
//            * **/
//           title: Text(
//             widget.title,
//             style: TextStyle(
//                 fontFamily: widget._fontFamily,
//                 color: Color(0xFFf8f0bc),
//                 fontSize: 14,
//                 decoration:
//                     widget.isChecked ? TextDecoration.lineThrough : null),
//           ),
//           /**
//            * Pro: Task Due Date
//            * **/
//           subtitle: (widget.dueDate != null)
//               ? Text(
//                   "${DateFormat.yMd().add_jm().format(widget.dueDate)}",
//                   style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.white60,
//                       fontWeight: FontWeight.w700,
//                       fontFamily: widget._fontFamily),
//                 )
//               : null,
//         ),
