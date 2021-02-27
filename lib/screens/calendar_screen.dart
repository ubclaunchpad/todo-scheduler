import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO: personalize title with user's name
      key: Key("Calendar Screen"),
      title: 'Calendar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Calendar(title: 'Calendar'),
    );
  }
}

class Calendar extends StatefulWidget {
  Calendar({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  // load Map at start of run, upon add -> add to disk + memory, same for rem
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    // _events = load from database
    _events = {
      _selectedDay.subtract(Duration(days: 12)): [
        'CPSC 310: 13:00 - 13:50',
        'CPSC 320: 14:00 - 14:50',
        'CPSC 322: 15:00 - 15:50',
        'Bike Practice: 18:00 - 19:25',
        'dummy event 1',
        'dummy event 2',
        'dummy event 3',
        'dummy event 4',
        'dummy event 5',
        'dummy event 6',
      ],
      _selectedDay.subtract(Duration(days: 5)): [
        'Launch Pad Meeting: 18:30 - 19:00'
      ],
      _selectedDay.subtract(Duration(days: 4)): [
        'CPSC 310: 13:00 - 13:50',
        'CPSC 320: 14:00 - 14:50',
        'CPSC 322: 15:00 - 15:50',
        'Bike Practice: 18:00 - 19:25',
      ],
    };

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
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildTableCalendar(),
          const SizedBox(height: 8.0),
          // _buildButtons(),
          // const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      key: Key("Calendar Screen - Table Calendar"),
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
      //onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
        key: Key("Calendar Screen - Events List"),
        padding: const EdgeInsets.all(8),
        itemCount: _selectedEvents.length,
        itemBuilder: (context, index) {
          // TODO: refactor in Event class issue
          // TODO: order events by time after Event class implemented
          final event = _selectedEvents[index].toString();
          return Card(
              child: ListTile(
            title: Text(event),
          ));
        });
  }
}
