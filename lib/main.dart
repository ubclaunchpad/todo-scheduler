import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart' hide Column;
import 'package:todo_scheduler/screens/add_todo_item.dart';
import 'package:todo_scheduler/screens/calendar_screen.dart';
import './data/moor_database.dart';

void main() =>
    runApp(TodoCalApp(LocalDatabase(FlutterQueryExecutor.inDatabaseFolder(
        path: 'db.sqlite', logStatements: true))));

class ScheduleItem {
  String eventTitle;
  var startTime;
  var endTime;
  bool eventType;
  ScheduleItem(this.eventTitle, this.startTime, this.endTime, this.eventType);
  @override
  String toString() {
    return '{ ${this.eventTitle}, ${this.startTime}, ${this.endTime}, ${this.eventType} }';
  }
}

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

  List<ScheduleItem> itemsEvents = [
    ScheduleItem('MATH 100 Lecture', 900, 1000, true),
    ScheduleItem('Pay house rent', 1030, 1045, false),
    ScheduleItem('MATH 100 Homework', 1100, 1145, false),
    ScheduleItem('PHYS 170 Lecture', 1200, 1300, true),
    ScheduleItem('CPSC 210 Lecture', 1300, 1430, true),
    ScheduleItem('Pay Phone Bill', 1430, 1445, false)
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          key: Key("Home Screen - App Bar"),
          title: Text('To-Do Scheduler'),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              SizedBox(height: 50),
              Text('Add To Do Item',
                  style: TextStyle(
                      fontFamily: "Open Sans",
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900,
                      fontSize: 20)),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 150, height: 50),
                    child: ElevatedButton(
                      key: Key("Home Screen - To-Do List Button"),
                      child: Text("To-Do List"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddTodoItemScreen(this.db)),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 150, height: 50),
                    child: ElevatedButton(
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
                  )
                ],
              ),
              SizedBox(height: 70),
              Text('Today\'s Schedule',
                  style: TextStyle(
                      fontFamily: "Open Sans",
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                      fontSize: 20)),
              SizedBox(height: 10),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: itemsEvents.length, //eventsList
                  padding: const EdgeInsets.all(8),
                  key: Key("Home Page - Events List"),
                  itemBuilder: (context, index) {
                    return Card(
                        key: Key('event'),
                        child: ListTile(
                          title: Text(itemsEvents[index].eventTitle,
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text(
                              itemsEvents[index].startTime.toString() +
                                  " - " +
                                  itemsEvents[index].endTime.toString()),
                          tileColor: itemsEvents[index].eventType == true
                              ? Colors.blue
                              : Colors.deepPurple,
                        ));
                  })
            ],
          )),
        ),
      ),
    );
  }
}
