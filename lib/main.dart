import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart' hide Column;
import 'package:todo_scheduler/screens/add_todo_item.dart';
import 'package:todo_scheduler/screens/calendar_screen.dart';
import './data/moor_database.dart';

void main() =>
    runApp(TodoCalApp(LocalDatabase(FlutterQueryExecutor.inDatabaseFolder(
        path: 'db.sqlite', logStatements: true))));

class TodoCalApp extends StatelessWidget {
  final LocalDatabase db;
  TodoCalApp(this.db);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: Key("Home Screen"),
      title: 'To-Do Scheduler',
      home: HomeScreen(this.db),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final LocalDatabase db;
  HomeScreen(this.db);

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTodoItemScreen()),
                );
              },
            ),
            ElevatedButton(
              key: Key("Home Screen - Calendar Button"),
              child: Text("Calendar"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CalendarScreen(this.db)),
                );
              },
            ),
          ],
        )),
      ),
    );
  }
}
