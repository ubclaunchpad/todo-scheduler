import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do Scheduler',
      home: Scaffold(
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
              },
            ),
          ],
        )),
      ),
    );
  }
}
