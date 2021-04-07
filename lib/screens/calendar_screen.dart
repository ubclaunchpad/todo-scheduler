import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_scheduler/screens/add_calendar_event_screen.dart';
import '../data/moor_database.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatelessWidget {
  final LocalDatabase db;
  CalendarScreen(this.db);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: personalize title with user's name
      key: Key("calendar_screen"),
      body: Calendar(title: 'Calendar', db: this.db),
    );
  }
}

class Calendar extends StatefulWidget {
  Calendar({Key key, this.title, this.db}) : super(key: key);

  final String title;
  final LocalDatabase db;

  @override
  _CalendarState createState() => _CalendarState(this.db);
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  // load Map at start of run, upon add -> add to disk + memory, same for rem
  _CalendarState(LocalDatabase localDb) {
    this.db = localDb;
    this.calendarItemDao = CalendarItemDao(this.db);
  }

  LocalDatabase db;
  CalendarItemDao calendarItemDao;
  Map<DateTime, List> _events = HashMap();
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<Map<DateTime, List>> _initEvents() async {
    Map<DateTime, List> _asyncEvents = HashMap();
    List<CalendarItem> calendarItems =
        await calendarItemDao.getAllCalendarItems();
    for (CalendarItem calendarItem in calendarItems) {
      bool dateExists = false;
      for (MapEntry entry in _asyncEvents.entries) {
        if (_isSameDate(entry.key, calendarItem.date)) {
          entry.value.add(calendarItem);
          dateExists = true;
          break;
        }
      }
      if (!dateExists) {
        _asyncEvents[calendarItem.date] = [calendarItem];
      }
    }
    return _asyncEvents;
  }

  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _initEvents().then((response) {
      setState(() {
        _events = response;
      });
    });

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400), //?
    );

    _animationController.forward();
  }

  // https://github.com/aleksanderwozniak/table_calendar/blob/master/example/lib/main.dart
  @override
  dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
      if (_selectedEvents.isNotEmpty) {
        _selectedEvents
            .sort((item1, item2) => item1.startTime.compareTo(item2.startTime));
      }
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: Key("calendar_app_bar"),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCalendarEventScreen(this.db)));
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendar(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      key: Key('calendar_widget'),
      calendarController: _calendarController,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.blue[700],
        todayColor: Colors.blue[200],
        markersColor: Colors.deepPurple[400],
        outsideDaysVisible: true,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepPurple[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
        key: Key("Calendar Screen - Events List"),
        padding: const EdgeInsets.all(8),
        itemCount: _selectedEvents.length,
        itemBuilder: (context, index) {
          final CalendarItem event = _selectedEvents[index];
          return Card(
              key: Key('calendar_event'),
              child: ListTile(
                  title: Text(event.title,
                      style: TextStyle(color: Colors.blueGrey[900])),
                  subtitle: Text(
                      DateFormat.jm().format(event.startTime).toString() +
                          " - " +
                          DateFormat.jm().format(event.endTime).toString()),
                  tileColor: Colors.cyanAccent[400]));
        });
  }
}
