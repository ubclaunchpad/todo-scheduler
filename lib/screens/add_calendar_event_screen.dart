import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_scheduler/screens/calendar_screen.dart';

class AddCalendarEventScreen extends StatefulWidget {
  @override
  _AddCalendarEventScreenState createState() => _AddCalendarEventScreenState();
}

class _AddCalendarEventScreenState extends State<AddCalendarEventScreen> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  Widget _renderCalendarEventTitle() => TextField(
    key: Key("Add Calendar Event Title"),
    decoration: InputDecoration(
      labelText: "Title"
    ),
    controller: _titleController
  );

  Widget _renderCalendarEventDate() => TextField(
    key: Key("Add Calendar Event Date"),
    decoration: InputDecoration(
      labelText: "Date"
    ),
    controller: _dateController
  );

  Widget _renderCalendarEventStartTime() => TextField(
    key: Key("Add Calendar Event Start Time"),
    decoration: InputDecoration(
      labelText: "Start Time"
    ),
    controller: _startTimeController
  );

  Widget _renderCalendarEventEndTime() => TextField(
    key: Key("Add Calendar Event End Time"),
    decoration: InputDecoration(
      labelText: "End Time"
    ),
    controller: _endTimeController
  );

  Widget _renderHomeScreenButton() => ElevatedButton(
    key: Key("Home Screen Button"),
    child: Text("Home Screen"),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CalendarScreen())
      );
    }

  );

  Widget renderAddCalendarEvent() {
    return Column(
      children: <Widget>[
        _renderCalendarEventTitle(),
        SizedBox(height: 20),
        _renderCalendarEventDate(),
        SizedBox(height: 20),
        _renderCalendarEventStartTime(),
        SizedBox(height: 20),
        _renderCalendarEventEndTime(),
        SizedBox(height: 20),

        _renderHomeScreenButton()
      ]
    )
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      key: Key("Add Calendar Event Screen"), 
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 30.0,
        ),
        child: renderAddCalendarEvent()
      ));
  }
}
