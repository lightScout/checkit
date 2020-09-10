import 'package:flutter/material.dart';
import 'package:ciao_app/widgets/task_tile.dart';

class MustDoTaskTile extends StatefulWidget {
  final String title;
  final Function deleteTask;
  final int isChecked;
  final Function isCheckCallBack;

  MustDoTaskTile({
    this.title,
    this.deleteTask,
    this.isChecked,
    this.isCheckCallBack,
  });

  @override
  _MustDoTaskTileState createState() => _MustDoTaskTileState();
}

class _MustDoTaskTileState extends State<MustDoTaskTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.only(
          topRight: Radius.elliptical(100, 100),
//          topLeft: Radius.elliptical(100, 100),
          bottomRight: Radius.elliptical(100, 100),
          bottomLeft: Radius.elliptical(100, 100),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: TaskTile(
          title: widget.title,
          category: 'MustDo',
          isCheckCallBack: widget.isCheckCallBack,
          isChecked: widget.isChecked,
          deleteTask: widget.deleteTask,
        ),
      ),
    );
  }
}
