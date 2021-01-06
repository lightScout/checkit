import 'package:ciao_app/model/task.dart';
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
  Map<DateTime, List> _events;
  List _selectedEvents;
  double yOffset = 0;
  Box tasksBox = Hive.box('tasks');

  @override
  void initState() {
    super.initState();
    buildCalendarWithTask();
    final _selectedDay = DateTime.now();
    _events = {
      _selectedDay.subtract(Duration(days: 1)): [
        'Event A0',
        'Event B0',
        'Event C0',
        'Event B0',
        'Event B0',
        'Event B0',
        'Event B0'
      ],
    };
    _selectedEvents = _events[_selectedDay] ?? [];

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
                    titleTextStyle: TextStyle()
                        .copyWith(color: Colors.blue[800], fontSize: 18),
                    formatButtonTextStyle:
                        TextStyle().copyWith(color: Colors.white, fontSize: 18),
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
                    selectedColor: Colors.amber,
                    eventDayStyle: TextStyle()
                        .copyWith(color: Colors.blue[800], fontSize: 20),
                    weekdayStyle: TextStyle()
                        .copyWith(color: Colors.blue[800], fontSize: 20),
                    weekendStyle: TextStyle().copyWith(color: Colors.red[800]),
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

  void buildCalendarWithTask() {
    List<Task> listOfTask = [];
    List listOfTaksKeys = tasksBox.keys.toList();

    listOfTaksKeys.forEach((element) {
      Task task = tasksBox.get(element) as Task;
      task.key = element;
      if (task.dueDateTime != null) {
        //listOfTask.add(task);
        print(task.dueDateTime);
      }
    });
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
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
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
                  title: Text(
                    event.toString(),
                    style: TextStyle().copyWith(color: Colors.white),
                  ),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }
}
