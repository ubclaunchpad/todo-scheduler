import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_scheduler/screens/calendar_screen.dart';
import '../data/moor_database.dart';

class AddCalendarEventScreen extends StatefulWidget {
  final LocalDatabase db;

  AddCalendarEventScreen(this.db);

  @override
  _AddCalendarEventScreenState createState() =>
      _AddCalendarEventScreenState(this.db);
}

class _AddCalendarEventScreenState extends State<AddCalendarEventScreen> {
  _AddCalendarEventScreenState(LocalDatabase localDatabase) {
    this.db = localDatabase;
    this.calendarItemDao = CalendarItemDao(this.db);
  }

  LocalDatabase db;
  CalendarItemDao calendarItemDao;

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  Widget _renderCalendarEventTitle() => TextField(
      key: Key("Add Calendar Event Title"),
      decoration: InputDecoration(
        labelText: "Title",
      ),
      controller: _titleController);

  Widget _renderCalendarEventDate() => TextField(
      key: Key("Add Calendar Event Date"),
      decoration: InputDecoration(labelText: "Date", hintText: "yyyy-mm-dd"),
      controller: _dateController);

  Widget _renderCalendarEventStartTime() => TextField(
      key: Key("Add Calendar Event Start Time"),
      decoration: InputDecoration(
        labelText: "Start Time",
        hintText: "hh:mm",
      ),
      controller: _startTimeController);

  Widget _renderCalendarEventEndTime() => TextField(
      key: Key("Add Calendar Event End Time"),
      decoration: InputDecoration(
        labelText: "End Time",
        hintText: "hh:mm",
      ),
      controller: _endTimeController);

  void _addCalendarEvent() async {
    String title = _titleController.text.trim();
    String date = _dateController.text.trim();
    String startTime = _startTimeController.text.trim();
    String endTime = _endTimeController.text.trim();

    CalendarItem calendarEvent;

    try {
      calendarEvent = CalendarItem(
          title: title,
          date: DateTime.parse(date),
          startTime: DateTime.parse(date + " " + startTime + ":00"),
          endTime: DateTime.parse(date + " " + endTime + ":00"));
    } catch (exception) {
      _titleController.clear();
      _dateController.clear();
      _startTimeController.clear();
      _endTimeController.clear();

      print("PROBLEMO");

      return;
    }

    _titleController.clear();
    _dateController.clear();
    _startTimeController.clear();
    _endTimeController.clear();

    bool isValidCalendarEvent = title.length >= 1;

    if (isValidCalendarEvent) {
      //Add the "calendarEvent" instance to the DB here
      await calendarItemDao.insertCalendarItem(calendarEvent);
      return;
    }
  }

  Widget _renderAddCalendarEventButton() => ElevatedButton(
      key: Key("Add Calendar Event Button"),
      child: Text("Add Event"),
      onPressed: () {
        _addCalendarEvent();
      });

  Widget renderAddCalendarEvent() {
    return Column(children: <Widget>[
      _renderCalendarEventTitle(),
      SizedBox(height: 20),
      _renderCalendarEventDate(),
      SizedBox(height: 20),
      _renderCalendarEventStartTime(),
      SizedBox(height: 20),
      _renderCalendarEventEndTime(),
      SizedBox(height: 20),
      _renderAddCalendarEventButton(),
    ]);
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
        key: Key("Add Calendar Event Screen"),
        appBar: AppBar(title: const Text("Add Calendar Event")),
        body: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 30.0,
            ),
            child: renderAddCalendarEvent()));
  }
}
