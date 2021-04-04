import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePageScreen(),
    );
  }
}

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

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

class _HomePageScreenState extends State<HomePageScreen> {
  List<ScheduleItem> itemsEvents = [
    ScheduleItem('MATH 100 Lecture', 1600, 1700, true),
    ScheduleItem('Launch Pad Meeting', 1700, 1730, true),
    ScheduleItem('MATH 100 Homework', 1800, 1945, false)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Home Page'),
        ),
        body: ListView.builder(
            itemCount: itemsEvents.length, //eventsList
            padding: const EdgeInsets.all(8),
            key: Key("Home Page - Events List"),
            itemBuilder: (context, index) {
              return Card(
                  key: Key('event'),
                  child: ListTile(
                    title: Text(itemsEvents[index].eventTitle,
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(itemsEvents[index].startTime.toString() +
                        " - " +
                        itemsEvents[index].endTime.toString()),
                    tileColor: itemsEvents[index].eventType == true
                        ? Colors.blue
                        : Colors.purple,
                  ));
            }));
  }
}
