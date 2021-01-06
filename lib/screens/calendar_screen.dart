import 'package:ciao_app/model/task.dart';
import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CalendarScreen extends StatefulWidget {
  static const id = 'calendar_screen';
  CalendarScreen({Key key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  CalendarController _calendarController;
  AnimationController _animationController;
  Map<DateTime, List> _events = {};
  List _selectedEvents;
  double yOffset = 0;
  Box tasksBox = Hive.box('tasks');

  @override
  void initState() {
    super.initState();
    _fillCalendarWithScheduleTasks();

    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Calendar',
          style: TextStyle(fontFamily: KMainFontFamily),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 8, right: 8, bottom: 8),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: TableCalendar(
                  calendarController: _calendarController,
                  events: _events,
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonVisible: true,
                    titleTextStyle: TextStyle().copyWith(
                      color: Colors.blue[800],
                      fontSize: 12,
                      fontFamily: KMainFontFamily,
                    ),
                    formatButtonTextStyle: TextStyle().copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: KMainFontFamily),
                    formatButtonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.blue[800],
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 33,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 33,
                    ),
                  ),
                  formatAnimation: FormatAnimation.slide,
                  calendarStyle: CalendarStyle(
                    outsideStyle: TextStyle().copyWith(
                      color: Colors.grey.shade400,
                      fontSize: 10,
                      fontFamily: KMainFontFamily,
                    ),
                    outsideWeekendStyle: TextStyle().copyWith(
                      color: Colors.grey.shade400,
                      fontSize: 10,
                      fontFamily: KMainFontFamily,
                    ),
                    todayStyle: TextStyle().copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: KMainFontFamily,
                    ),
                    selectedColor: Colors.amber,
                    selectedStyle: TextStyle().copyWith(
                      color: Colors.blue[800],
                      fontSize: 20,
                      fontFamily: KMainFontFamily,
                    ),
                    eventDayStyle: TextStyle().copyWith(
                      color: Colors.blue[800],
                      fontSize: 20,
                      fontFamily: KMainFontFamily,
                    ),
                    weekdayStyle: TextStyle().copyWith(
                        color: Colors.blue[800],
                        fontSize: 18,
                        fontFamily: KMainFontFamily),
                    weekendStyle: TextStyle().copyWith(
                        color: Colors.red[800], fontFamily: KMainFontFamily),
                    holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
                  ),
                  builders: CalendarBuilders(
                    markersBuilder: (context, date, events, holidays) {
                      final children = <Widget>[];

                      if (events.isNotEmpty) {
                        children.add(
                          Positioned(
                            right: 1,
                            bottom: 1,
                            child: _buildEventsMarker(date, events),
                          ),
                        );
                      }

                      // if (holidays.isNotEmpty) {
                      //   children.add(
                      //     Positioned(
                      //       right: -2,
                      //       top: -2,
                      //       child: _buildHolidaysMarker(),
                      //     ),
                      //   );
                      // }

                      return children;
                    },
                  ),
                  onDaySelected: (date, events, holiday) =>
                      _onDaySelected(date, events, holiday),
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(child: _buildEventList()),
            ],
          ),
        ),
      ),
    );
  }

  void _fillCalendarWithScheduleTasks() {
    List listOfTaksKeys = tasksBox.keys.toList();
    var initialDate = DateTime.now();
    var updateInitialDate = false;

    listOfTaksKeys.forEach((element) {
      Task task = tasksBox.get(element) as Task;
      task.key = element;

      if (task.dueDateTime != null) {
        if (!updateInitialDate) {
          initialDate = _formatDateToMapIndex(task.dueDateTime);
          updateInitialDate = true;
        }
        if (updateInitialDate) {
          if (task.dueDateTime.isBefore(initialDate)) {
            initialDate = _formatDateToMapIndex(task.dueDateTime);
            // print('task date is before previous task date');
            // print(initialDate);
          }
        }
        var mapIndex = task.dueDateTime
            .subtract(Duration(seconds: task.dueDateTime.second))
            .subtract(Duration(minutes: task.dueDateTime.minute))
            .subtract(Duration(hours: task.dueDateTime.hour));
        // print(mapIndex);
        if (_events.containsKey(mapIndex)) {
          _events[mapIndex].add(
            '${task.name}',
          );
        } else {
          _events.addAll(
            {
              mapIndex: ['${task.name}']
            },
          );
        }
      }
    });
    _selectedEvents = _events[initialDate] ?? [];
    print(_selectedEvents);
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
    print(events);
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.blue[400]
            : _calendarController.isToday(date)
                ? Colors.blue[400]
                : Colors.red,
      ),
      width: 18.0,
      height: 18.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 11.0,
            fontFamily: KMainFontFamily,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString(),
                      style: TextStyle().copyWith(
                        color: Colors.white,
                        fontFamily: KMainFontFamily,
                        fontSize: 12,
                      )),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }

  DateTime _formatDateToMapIndex(DateTime date) {
    return date
        .subtract(Duration(seconds: date.second))
        .subtract(Duration(minutes: date.minute))
        .subtract(Duration(hours: date.hour));
  }
}
