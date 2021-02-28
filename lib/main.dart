import 'package:flutter/material.dart';
import 'package:todo_scheduler/screens/calendar_screen.dart';

void main() => runApp(TodoCalApp());

class TodoCalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: Key("Home Screen"),
      title: 'To-Do Scheduler',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          key: Key("Home Screen - App Bar"),
          title: Text('To-Do Scheduler'),
        ),
        body: Center(
            child: Column(
          children: [
            SizedBox(height: 200),
            ElevatedButton(
              key: Key("Home Screen - To-Do List Button"),
              child: Text("To-Do List"),
              onPressed: () {
                // TODO: implement navigation from Home Page to To-do List page using this button
              },
            ),
            ElevatedButton(
              key: Key("Home Screen - Calendar Button"),
              child: Text("Calendar"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarScreen()),
                );
              },
            ),
          ],
        )),
      ),
    );
  }
}
