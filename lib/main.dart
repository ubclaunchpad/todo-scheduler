import 'package:flutter/material.dart';
import 'package:todo_scheduler/screens/calendar.dart';

void main() => runApp(TodoCalApp());

class TodoCalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          title: Text('To-Do Scheduler'),
        ),
        body: Center(
            child: Column(
          children: [
            SizedBox(height: 200),
            ElevatedButton(
              child: Text("To-Do List"),
              onPressed: () {
                // TODO: implement navigation from Home Page to To-do List page using this button
              },
            ),
            ElevatedButton(
              child: Text("Calendar"),
              onPressed: () {
                // TODO: implement navigation from Home Page to Calendar page using this button
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
